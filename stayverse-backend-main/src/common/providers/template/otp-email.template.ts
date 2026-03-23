export const otpEmailTemplate = (
  name: string,
  otp: string,
  purpose: 'verification' | 'reset',
  baseUrl: string
): string => {
  const isVerification = purpose === 'verification';
  const title = isVerification
    ? 'Verify Your Email Address'
    : 'Reset Your Password';
  const message = isVerification
    ? `To ensure the security of your Stayverse account, please verify your email address using the one-time password (OTP) below.`
    : `You requested to reset your Stayverse account password. Use the one-time password (OTP) below to proceed.`;

  return `
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>${title}</title>
      <style>
          body {
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
              background-color: #f5f5f5;
              margin: 0;
              padding: 20px;
              line-height: 1.6;
          }
          .email-container {
              max-width: 600px;
              margin: 0 auto;
              background-color: #ffffff;
              border-radius: 12px;
              overflow: hidden;
              box-shadow: 0 2px 10px rgba(0,0,0,0.1);
          }
          .email-body {
              padding: 48px 32px;
          }
          .email-title {
              font-size: 30px;
              font-weight: 600;
              color: #000000;
              margin: 0 0 32px 0;
              line-height: 1.1;
          }
          .greeting {
              color: #6B7280;
              font-size: 16px;
              margin: 0 0 24px 0;
          }
          .content-text {
              color: #6B7280;
              font-size: 16px;
              line-height: 1.6;
              margin: 0 0 24px 0;
          }
          .otp-box {
              border-radius: 12px;
              padding: 24px;
              text-align: center;
              margin: 32px 0;
              background-color: #FFFBEB;
              border: 1px solid #EAB308;
          }
          .otp-label {
              margin: 0 0 12px 0;
              color: #6B7280;
              font-size: 14px;
          }
          .otp-code {
              font-size: 42px;
              font-weight: 700;
              color: #000000;
              letter-spacing: 12px;
              margin: 12px 0;
              font-family: 'Courier New', monospace;
          }
          .otp-expiry {
              margin: 12px 0 0 0;
              color: #6B7280;
              font-size: 14px;
          }
          .section-title {
              color: #000000;
              font-size: 16px;
              font-weight: 600;
              margin: 32px 0 16px 0;
          }
          .bullet-list {
              list-style: none;
              padding: 0;
              margin: 0 0 24px 0;
          }
          .bullet-list li {
              color: #6B7280;
              font-size: 16px;
              line-height: 1.6;
              margin-bottom: 12px;
          }
          .closing {
              color: #6B7280;
              font-size: 16px;
              margin: 32px 0 8px 0;
          }
          .signature {
              color: #6B7280;
              font-size: 16px;
              margin: 0;
          }
          .footer {
              text-align: center;
              padding: 40px 32px;
              background-color: #ffffff;
          }
          .logo-container {
              margin-bottom: 24px;
          }
          .logo-icon {
              width: 64px;
              height: 64px;
              background-color: #EAB308;
              border-radius: 12px;
              margin: 0 auto;
              display: flex;
              align-items: center;
              justify-content: center;
          }
          .social-text {
              color: #6B7280;
              font-size: 15px;
              margin: 0 0 20px 0;
          }
          .social-icons {
              display: flex;
              justify-content: center;
              gap: 16px;
          }
          .social-icon {
              width: 48px;
              height: 48px;
              background-color: #EAB308;
              border-radius: 50%;
              display: flex;
              align-items: center;
              justify-content: center;
              text-decoration: none;
          }
          .social-icon svg {
              width: 22px;
              height: 22px;
              fill: #000000;
          }
      </style>
  </head>
  <body>
      <div class="email-container">
          <div class="email-body">
              <h1 class="email-title">${title}</h1>
              <p class="greeting">Hi ${name},</p>
              <p class="content-text">${message}</p>

              <div class="otp-box">
                  <p class="otp-label">Your ${isVerification ? 'verification' : 'reset'} code is:</p>
                  <div class="otp-code">${otp}</div>
                  <p class="otp-expiry">This code will expire in 10 minutes</p>
              </div>

              <p class="content-text">
                  ${
                    isVerification
                      ? 'Enter this code on the verification page to complete your registration and access all Stayverse features.'
                      : 'Enter this code on the password reset page to securely change your password.'
                  }
              </p>

              <p class="section-title">Security Tips:</p>
              <ul class="bullet-list">
                  <li>• Never share this code with anyone, including Stayverse staff</li>
                  <li>• Stayverse will never ask for your OTP via email or phone</li>
                  <li>• If you didn’t request this code, please ignore this email</li>
                  <li>• For security concerns, contact our support team immediately</li>
              </ul>

              <p class="closing">Stay secure,</p>
              <p class="signature">The Stayverse Team</p>
          </div>

          <div class="footer">
              <div class="logo-container">
                  <div class="logo-icon">
                      <img height="64" width="64" src="https://stayversepro.sfo3.cdn.digitaloceanspaces.com/stayverse-new-logo.png" alt="Stayverse Logo" />
                  </div>
              </div>
              <p class="social-text">Please visit our other socials</p>
          </div>
      </div>
  </body>
  </html>
  `;
};
