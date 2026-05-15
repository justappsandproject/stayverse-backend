import mongoose from 'mongoose';
import * as fs from 'fs';
import * as path from 'path';
import { Testimonial, TestimonialSchema } from '../src/modules/testimonial/schemas/testimonial.schema';

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

const DEFAULT_TESTIMONIALS = [
  {
    name: 'Amaka E.',
    role: 'Frequent traveler',
    city: 'Lagos',
    rating: 5,
    quote:
      'Stayverse made my Lagos trip effortless. Apartment, ride, and chef booking all happened in minutes.',
    sortOrder: 0,
  },
  {
    name: 'David O.',
    role: 'Business consultant',
    city: 'Abuja',
    rating: 5,
    quote:
      'The apartments are exactly as advertised and the ride service is super reliable. Smooth experience end-to-end.',
    sortOrder: 1,
  },
  {
    name: 'Kemi A.',
    role: 'Lifestyle creator',
    city: 'Port Harcourt',
    rating: 5,
    quote:
      'I loved the private chef option. It gave my stay a premium feel without the stress of planning meals.',
    sortOrder: 2,
  },
  {
    name: 'Tunde M.',
    role: 'Remote worker',
    city: 'Benin City',
    rating: 5,
    quote:
      'Clean UI, fast support, and quality listings. Stayverse is now my default for short stays in new cities.',
    sortOrder: 3,
  },
  {
    name: 'Chioma N.',
    role: 'Weekend explorer',
    city: 'Lagos',
    rating: 5,
    quote:
      'Everything felt curated and safe. Booking a place and a ride in one app saved me so much time.',
    sortOrder: 4,
  },
];

async function main() {
  loadEnvFromDotEnvIfPresent();
  const DATABASE_URL = process.env.DATABASE_URL;
  if (!DATABASE_URL) throw new Error('DATABASE_URL is required');

  await mongoose.connect(DATABASE_URL);
  const TestimonialModel =
    (mongoose.models[Testimonial.name] as any | undefined) ??
    mongoose.model(Testimonial.name, TestimonialSchema as any);

  for (const item of DEFAULT_TESTIMONIALS) {
    await TestimonialModel.findOneAndUpdate(
      { name: item.name, quote: item.quote },
      { $set: { ...item, isActive: true } },
      { upsert: true, new: true },
    );
  }

  const count = await TestimonialModel.countDocuments({});
  // eslint-disable-next-line no-console
  console.log(`Testimonials seeded. Total in database: ${count}`);
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
