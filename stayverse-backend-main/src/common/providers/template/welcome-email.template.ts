export const welcomeEmailTemplate = (name: string): string => {
  return `
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Welcome Email Templates</title>
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
              border-radius: 10px;
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
              letter-spacing: -0.5px;
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
          .bullet-list li strong {
              color: #000000;
          }
          .cta-button {
              display: inline-block;
              background-color: #EAB308;
              color: #000000;
              text-decoration: none;
              padding: 14px 28px;
              border-radius: 6px;
              font-weight: 600;
              margin: 24px 0;
              font-size: 16px;
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
              overflow: hidden;
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
              <h1 class="email-title">Your Stayverse Adventure Starts Now</h1>
              
              <p class="greeting">Hi ${name},</p>
              
              <p class="content-text">
                  Welcome to Stayverse — and thank you for signing up! We're thrilled to have you join our community of explorers, wanderers, and relaxation seekers.
              </p>
              
              <p class="section-title">Here's what you can do next:</p>
              
              <ul class="bullet-list">
                  <li>• <strong>Complete Your Profile:</strong> Personalize your Stayverse experience.</li>
                  <li>• <strong>Discover Unique Stays:</strong> Browse through handpicked locations tailored to your vibe.</li>
                  <li>• <strong>Plan Your Escape:</strong> Save favorites, create wishlists, and start building your itinerary.</li>
                  <li>• <strong>Book Seamlessly:</strong> Enjoy a hassle-free booking process with secure payments.</li>
              </ul>
              
              <p class="content-text">
                  As a welcome gift, your first booking comes with a special discount — just for you!
              </p>
              
              <a href="https://stayversepro.com" class="cta-button">Start Exploring</a>
              
              <p class="content-text">
                  If you have any questions or need assistance, our support team is here to help.
              </p>
              
              <p class="closing">Happy travels,</p>
              <p class="signature">The Stayverse Team</p>
          </div>
          
          <div class="footer">
              <div class="logo-container">
                  <div class="logo-icon">
                      <img src="https://stayversepro.sfo3.cdn.digitaloceanspaces.com/stayverse-new-logo.png" width="64" height="64" alt="Stayverse Logo" />
                  </div>
              </div>
              <p class="social-text">Please visit our other socials</p>
              <div class="social-icons">
                  <a href="#" class="social-icon">
                      <svg viewBox="0 0 24 24">
                          <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069z"/>
                      </svg>
                  </a>
                  <a href="#" class="social-icon">
                      <svg viewBox="0 0 24 24">
                          <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                      </svg>
                  </a>
                  <a href="#" class="social-icon">
                      <svg viewBox="0 0 24 24">
                          <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
                      </svg>
                  </a>
              </div>
          </div>
      </div>
  </body>
  </html>
  `;
};
