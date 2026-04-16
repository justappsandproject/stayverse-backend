import mongoose from 'mongoose';
import * as bcrypt from 'bcrypt';
import { User, UserSchema } from '../src/modules/user/schemas/user.schema';
import { Roles } from '../src/common/constants/enum';
import * as fs from 'fs';
import * as path from 'path';

function getArg(name: string) {
  const idx = process.argv.findIndex((a) => a === `--${name}`);
  return idx >= 0 ? process.argv[idx + 1] : undefined;
}

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

async function main() {
  loadEnvFromDotEnvIfPresent();

  const DATABASE_URL = process.env.DATABASE_URL;
  if (!DATABASE_URL) {
    throw new Error('DATABASE_URL is required (set it in stayverse-backend-main/.env)');
  }

  const email = getArg('email') ?? 'admin@stayverse.local';
  const password = getArg('password') ?? 'Admin123!';
  const firstname = getArg('firstname') ?? 'Admin';
  const lastname = getArg('lastname') ?? 'User';
  const phoneNumber = getArg('phone') ?? '08000000000';

  await mongoose.connect(DATABASE_URL);

  // NOTE: keep this untyped to avoid TS issues if mongoose types
  // are duplicated across dependencies in the repo.
  const UserModel =
    (mongoose.models[User.name] as any | undefined) ??
    (mongoose.model(User.name, UserSchema as any) as any);

  const passwordHash = await bcrypt.hash(password, 10);

  const user = await UserModel.findOneAndUpdate(
    { email },
    {
      $set: {
        firstname,
        lastname,
        email,
        phoneNumber,
        role: Roles.ADMIN,
        isEmailVerified: true,
        isDeleted: false,
        otp: null,
        pinExpires: null,
        passwordHash,
      },
    },
    { new: true, upsert: true }
  ).lean();

  // eslint-disable-next-line no-console
  console.log('Admin user ready:');
  // eslint-disable-next-line no-console
  console.log({
    _id: user?._id,
    email,
    password,
    role: user?.role,
    isEmailVerified: user?.isEmailVerified,
  });

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
