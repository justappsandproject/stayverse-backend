import mongoose from 'mongoose';
import * as bcrypt from 'bcrypt';
import * as fs from 'fs';
import * as path from 'path';
import { User, UserSchema } from '../src/modules/user/schemas/user.schema';
import { Agent, AgentSchema } from '../src/modules/agent/schemas/agent.schema';
import { Apartment, ApartmentSchema } from '../src/modules/apartment/schemas/apartment.schema';
import { Ride, RideSchema } from '../src/modules/rides/schemas/rides.schema';
import { Chef, ChefSchema } from '../src/modules/chef/schemas/chef.schema';
import { Roles, ServiceStatus, ServiceType } from '../src/common/constants/enum';

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

function coordsForIndex(i: number): [number, number] {
  const lng = 3.34 + (i % 10) * 0.01;
  const lat = 6.52 + (i % 10) * 0.01;
  return [lng, lat];
}

async function ensureAgent(
  UserModel: any,
  AgentModel: any,
  serviceType: ServiceType,
  email: string,
  phoneNumber: string,
) {
  const passwordHash = await bcrypt.hash('Pass1234!', 10);
  const user = await UserModel.findOneAndUpdate(
    { email },
    {
      $set: {
        firstname: `Demo ${serviceType}`,
        lastname: 'Agent',
        email,
        phoneNumber,
        passwordHash,
        role: Roles.AGENT,
        isEmailVerified: true,
        isDeleted: false,
      },
    },
    { new: true, upsert: true },
  ).lean();

  const agent = await AgentModel.findOneAndUpdate(
    { userId: user._id },
    {
      $set: {
        userId: user._id,
        serviceType,
        isDeleted: false,
      },
    },
    { new: true, upsert: true },
  ).lean();

  return { user, agent };
}

async function seedApartments(ApartmentModel: any, agentId: string, total = 30) {
  for (let i = 1; i <= total; i++) {
    const [lng, lat] = coordsForIndex(i);
    await ApartmentModel.findOneAndUpdate(
      { agentId, apartmentName: `Demo Apartment ${i}` },
      {
        $set: {
          agentId,
          apartmentName: `Demo Apartment ${i}`,
          details: `Spacious demo apartment listing ${i} for app testing.`,
          address: `No ${i} Demo Avenue, Lekki, Lagos`,
          placeId: `demo-apartment-place-${i}`,
          location: { type: 'Point', coordinates: [lng, lat] },
          apartmentType: i % 2 === 0 ? '2-bedroom' : '1-bedroom',
          numberOfBedrooms: i % 2 === 0 ? 2 : 1,
          amenities: ['WiFi', 'Air Conditioning', 'Security'],
          pricePerDay: 45000 + i * 500,
          houseRules: 'No smoking. Keep environment clean.',
          maxGuests: i % 2 === 0 ? 4 : 2,
          checkIn: new Date('2026-01-01T12:00:00.000Z'),
          checkOut: new Date('2026-12-31T12:00:00.000Z'),
          cautionFee: 50000,
          apartmentImages: [
            `https://picsum.photos/seed/apartment-${i}-1/1200/800`,
            `https://picsum.photos/seed/apartment-${i}-2/1200/800`,
          ],
          status: ServiceStatus.APPROVED,
          bookedStatus: 'available',
          isDeleted: false,
        },
      },
      { new: true, upsert: true },
    );
  }
}

async function seedRides(RideModel: any, agentId: string, total = 30) {
  for (let i = 1; i <= total; i++) {
    const [lng, lat] = coordsForIndex(i + 20);
    await RideModel.findOneAndUpdate(
      { agentId, rideName: `Demo Ride ${i}` },
      {
        $set: {
          agentId,
          rideName: `Demo Ride ${i}`,
          rideDescription: `Reliable demo ride listing ${i} for testing.`,
          address: `No ${i} Demo Road, Ikeja, Lagos`,
          placeId: `demo-ride-place-${i}`,
          location: { type: 'Point', coordinates: [lng, lat] },
          rideType: i % 3 === 0 ? 'SUV' : 'Sedan',
          features: ['Air Conditioning', 'GPS', 'Bluetooth'],
          pricePerHour: 8000 + i * 200,
          rules: 'No smoking in vehicle.',
          maxPassengers: i % 3 === 0 ? 6 : 4,
          rideImages: [
            `https://picsum.photos/seed/ride-${i}-1/1200/800`,
            `https://picsum.photos/seed/ride-${i}-2/1200/800`,
            `https://picsum.photos/seed/ride-${i}-3/1200/800`,
          ],
          plateNumber: `STV-${1000 + i}`,
          registrationNumber: `REG-${9000 + i}`,
          color: i % 2 === 0 ? 'Black' : 'White',
          vehicleVerificationNumber: `VVN-DEMO-${100000 + i}`,
          status: ServiceStatus.APPROVED,
          bookedStatus: 'available',
          serviceType: ServiceType.RIDE,
          security: i % 2 === 0,
          airportPickup: i % 2 !== 0,
          cautionFee: 50000,
          isDeleted: false,
        },
      },
      { new: true, upsert: true },
    );
  }
}

async function seedChefs(ChefModel: any, agentId: string, total = 30) {
  for (let i = 1; i <= total; i++) {
    const [lng, lat] = coordsForIndex(i + 40);
    await ChefModel.findOneAndUpdate(
      { agentId, fullName: `Demo Chef ${i}` },
      {
        $set: {
          agentId,
          fullName: `Demo Chef ${i}`,
          address: `No ${i} Demo Close, Victoria Island, Lagos`,
          placeId: `demo-chef-place-${i}`,
          location: { type: 'Point', coordinates: [lng, lat] },
          bio: `Professional demo chef profile ${i}.`,
          about: `Experienced in local and continental dishes. Demo profile ${i}.`,
          culinarySpecialties: ['Nigerian Cuisine', 'Continental'],
          pricingPerHour: 12000 + i * 300,
          profilePicture: `https://picsum.photos/seed/chef-${i}-profile/800/800`,
          coverPhoto: `https://picsum.photos/seed/chef-${i}-cover/1200/800`,
          status: ServiceStatus.APPROVED,
          hasExperience: false,
          hasCertifications: false,
        },
      },
      { new: true, upsert: true },
    );
  }
}

async function countAndLog(ApartmentModel: any, RideModel: any, ChefModel: any) {
  const [apartments, rides, chefs] = await Promise.all([
    ApartmentModel.countDocuments({ apartmentName: /Demo Apartment/i }),
    RideModel.countDocuments({ rideName: /Demo Ride/i }),
    ChefModel.countDocuments({ fullName: /Demo Chef/i }),
  ]);
  // eslint-disable-next-line no-console
  console.table([
    { service: 'apartments', count: apartments },
    { service: 'rides', count: rides },
    { service: 'chefs', count: chefs },
  ]);
}

async function main() {
  loadEnvFromDotEnvIfPresent();
  const DATABASE_URL = process.env.DATABASE_URL;
  if (!DATABASE_URL) throw new Error('DATABASE_URL is required in stayverse-backend-main/.env');

  await mongoose.connect(DATABASE_URL);

  const UserModel = (mongoose.models[User.name] as any) ?? mongoose.model(User.name, UserSchema as any);
  const AgentModel = (mongoose.models[Agent.name] as any) ?? mongoose.model(Agent.name, AgentSchema as any);
  const ApartmentModel =
    (mongoose.models[Apartment.name] as any) ?? mongoose.model(Apartment.name, ApartmentSchema as any);
  const RideModel = (mongoose.models[Ride.name] as any) ?? mongoose.model(Ride.name, RideSchema as any);
  const ChefModel = (mongoose.models[Chef.name] as any) ?? mongoose.model(Chef.name, ChefSchema as any);

  const apartmentAgent = await ensureAgent(
    UserModel,
    AgentModel,
    ServiceType.APARTMENT,
    'agent.apartment@stayverse.local',
    '08030000012',
  );
  const rideAgent = await ensureAgent(
    UserModel,
    AgentModel,
    ServiceType.RIDE,
    'agent.ride@stayverse.local',
    '08030000013',
  );
  const chefAgent = await ensureAgent(
    UserModel,
    AgentModel,
    ServiceType.CHEF,
    'agent.chef@stayverse.local',
    '08030000011',
  );

  await seedApartments(ApartmentModel, apartmentAgent.agent._id, 30);
  await seedRides(RideModel, rideAgent.agent._id, 30);
  await seedChefs(ChefModel, chefAgent.agent._id, 30);

  // eslint-disable-next-line no-console
  console.log('Demo services seeded successfully.');
  await countAndLog(ApartmentModel, RideModel, ChefModel);

  await mongoose.disconnect();
}

main().catch(async (error) => {
  // eslint-disable-next-line no-console
  console.error(error);
  try {
    await mongoose.disconnect();
  } catch {
    // ignore
  }
  process.exit(1);
});
