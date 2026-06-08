import * as fs from 'fs';
import * as path from 'path';
import * as nodemailer from 'nodemailer';

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
    const value = trimmed.slice(eq + 1).trim();
    if (!process.env[key]) process.env[key] = value;
  }
}

async function main() {
  loadEnvFromDotEnvIfPresent();

  const host = process.env.MAIL_HOST;
  const port = Number(process.env.MAIL_PORT || 587);
  const user = process.env.MAIL_USER;
  const pass = process.env.MAIL_PASS;
  const from = process.env.MAIL_FROM || user;
  const to = process.argv[2];

  if (!host || !user || !pass || !to) {
    console.error(
      'Usage: npm run test:email -- recipient@example.com\nRequires MAIL_HOST, MAIL_USER, MAIL_PASS in .env',
    );
    process.exit(1);
  }

  const transporter = nodemailer.createTransport({
    host,
    port,
    secure: port === 465,
    auth: { user, pass },
    connectionTimeout: 10000,
    greetingTimeout: 10000,
    socketTimeout: 20000,
    ...(port === 587 ? { requireTLS: true } : {}),
  });

  console.log(`Verifying SMTP ${host}:${port}...`);
  await transporter.verify();
  console.log('SMTP connection verified.');

  const info = await transporter.sendMail({
    from: `"Stayverse" <${from}>`,
    to,
    subject: 'Stayverse email test',
    html: '<p>If you received this, SMTP is configured correctly.</p>',
  });

  console.log(`Test email sent: ${info.messageId}`);
}

main().catch((error) => {
  console.error('Email test failed:', error.message);
  process.exit(1);
});
