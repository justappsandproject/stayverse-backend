import mongoose from 'mongoose';
import * as bcrypt from 'bcrypt';
import * as fs from 'fs';
import * as path from 'path';
import { User, UserSchema } from '../src/modules/user/schemas/user.schema';
import { Agent, AgentSchema } from '../src/modules/agent/schemas/agent.schema';
import { Roles, ServiceType } from '../src/common/constants/enum';

function loadEnvFromDotEnvIfPresent() {
  const envPath = path.resolve(process.cwd(), '.env');
  if (!fs.existsSync(envPath)) return;

  const raw = fs.readFileSync(envPath, 'utf8');
  for (const line of raw.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    const eq = trimmed.indexOf('=');
    if (eq === -1) continue;
    const key = trimmed.slice(0, eq).trim();
    let value = trimmed.slice(eq + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    if (!(key in process.env)) process.env[key] = value;
  }
}

async function upsertUser(
  UserModel: any,
  payload: {
    firstname: string;
    lastname: string;
    email: string;
    phoneNumber: string;
    password: string;
    role: Roles;
  }
) {
  const passwordHash = await bcrypt.hash(payload.password, 10);
  return UserModel.findOneAndUpdate(
    { email: payload.email },
    {
      $set: {
        firstname: payload.firstname,
        lastname: payload.lastname,
        email: payload.email,
        phoneNumber: payload.phoneNumber,
        passwordHash,
        role: payload.role,
        isEmailVerified: true,
        isDeleted: false,
        otp: null,
        pinExpires: null,
      },
    },
    { new: true, upsert: true }
  ).lean();
}

async function main() {
  loadEnvFromDotEnvIfPresent();
  const DATABASE_URL = process.env.DATABASE_URL;
  if (!DATABASE_URL) {
    throw new Error('DATABASE_URL is required in stayverse-backend-main/.env');
  }

  await mongoose.connect(DATABASE_URL);

  const UserModel =
    (mongoose.models[User.name] as any | undefined) ??
    (mongoose.model(User.name, UserSchema as any) as any);
  const AgentModel =
    (mongoose.models[Agent.name] as any | undefined) ??
    (mongoose.model(Agent.name, AgentSchema as any) as any);

  const basePassword = 'Pass1234!';
  const created: any[] = [];

  const user = await upsertUser(UserModel, {
    firstname: 'Demo',
    lastname: 'User',
    email: 'user.demo@stayverse.local',
    phoneNumber: '08030000001',
    password: basePassword,
    role: Roles.USER,
  });
  created.push({ type: 'user', email: user.email, password: basePassword, role: user.role });

  const agents = [
    {
      firstname: 'Chef',
      lastname: 'Agent',
      email: 'agent.chef@stayverse.local',
      phoneNumber: '08030000011',
      serviceType: ServiceType.CHEF,
    },
    {
      firstname: 'Apartment',
      lastname: 'Agent',
      email: 'agent.apartment@stayverse.local',
      phoneNumber: '08030000012',
      serviceType: ServiceType.APARTMENT,
    },
    {
      firstname: 'Ride',
      lastname: 'Agent',
      email: 'agent.ride@stayverse.local',
      phoneNumber: '08030000013',
      serviceType: ServiceType.RIDE,
    },
  ];

  for (const item of agents) {
    const agentUser = await upsertUser(UserModel, {
      firstname: item.firstname,
      lastname: item.lastname,
      email: item.email,
      phoneNumber: item.phoneNumber,
      password: basePassword,
      role: Roles.AGENT,
    });

    await AgentModel.findOneAndUpdate(
      { userId: agentUser._id },
      {
        $set: {
          userId: agentUser._id,
          serviceType: item.serviceType,
          isDeleted: false,
        },
      },
      { new: true, upsert: true }
    ).lean();

    created.push({
      type: 'agent',
      serviceType: item.serviceType,
      email: item.email,
      password: basePassword,
      role: Roles.AGENT,
    });
  }

  // eslint-disable-next-line no-console
  console.log('Demo accounts ready:');
  // eslint-disable-next-line no-console
  console.table(created);

  await mongoose.disconnect();
}

main().catch(async (err) => {
  // eslint-disable-next-line no-console
  console.error(err);
  try {
    await mongoose.disconnect();
  } catch {
    // ignore
  }
  process.exit(1);
});
