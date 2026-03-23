import Image from "next/image";
import Link from "next/link";
import { Footer } from "../component/footer";

export default function TermsPage() {
  return (
    <div className="w-full min-h-screen flex flex-col bg-gray-50">
      {/* Header - Dark theme to match Brand Identity and Logo */}
      <header className="w-full bg-[#0D0D0D] flex justify-between items-center gap-10 px-[22px] lg:px-[100px] py-[30px] lg:py-[40px] z-10 sticky top-0 shadow-md">
        <Link href="/">
          <Image
            src={"/logo-white.png"}
            width={144}
            height={25}
            alt="stayverse logo"
            className="hover:scale-105 transition-transform duration-300 cursor-pointer"
          />
        </Link>
        <nav className="hidden lg:flex justify-center items-center gap-[60px]">
          <Link
            href={"/"}
            className="text-white text-base font-normal leading-8 hover:text-primary-500 transition-colors duration-300"
          >
            Home
          </Link>
          <Link
            href="/#about-us"
            className="text-white text-base font-normal leading-8 hover:text-primary-500 transition-colors duration-300"
          >
            About Us
          </Link>
          <Link
            href="/#contact-us"
            className="text-white text-base font-normal leading-8 hover:text-primary-500 transition-colors duration-300"
          >
            Contact Us
          </Link>
          <Link
            href="/#faqs"
            className="text-white text-base font-normal leading-8 hover:text-primary-500 transition-colors duration-300"
          >
            FAQs
          </Link>
        </nav>
        <Link
          href="https://onelink.to/zvdpw6"
          target="_blank"
          rel="noopener noreferrer"
          className="bg-primary-500 px-5 py-[10px] rounded-[50px] flex justify-center hover:bg-primary-600 transition-all duration-300 transform hover:scale-105 font-medium text-black"
        >
          Get App
        </Link>
      </header>

      {/* Main Content */}
      <main className="flex-grow w-full max-w-5xl mx-auto px-[22px] lg:px-[40px] py-[60px] lg:py-[100px] animate-fadeIn">
        {/* Terms of Service Section */}
        <section id="terms" className="mb-[80px]">
          <h1 className="text-[32px] lg:text-[48px] font-bold text-gray-900 mb-6 leading-tight">
            Stayverse Terms and Conditions
          </h1>
          <p className="text-gray-600 text-lg mb-10 leading-relaxed">
            Welcome to Stayverse! These Terms and Conditions govern your use of
            our platform, services, and applications. By accessing or using
            Stayverse, you agree to comply with and be bound by these Terms. If
            you do not agree, please refrain from using our services.
          </p>

          <div className="space-y-12">
            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                1. Use of Services
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Stayverse provides a platform that connects users to verified
                apartments, vehicles, and catering services. Users must be at
                least 18 years old to use our platform. You agree to provide
                accurate information and comply with all applicable laws when
                using our services.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                2. Bookings and Payments
              </h2>
              <p className="text-gray-600 leading-relaxed">
                All bookings made through Stayverse must be paid in full at the
                time of confirmation unless otherwise stated. You authorize
                Stayverse to charge your selected payment method for all
                bookings and related fees.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                3. Cancellations and Refunds
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Cancellations are subject to the Stayverse Cancellation Policy.
                Refund eligibility will depend on the timing of your
                cancellation. No-shows are non-refundable.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                4. User Responsibilities
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Users are expected to treat hosts, drivers, and chefs
                respectfully and responsibly. Any misuse, abuse, or violation of
                our policies may result in account suspension or termination.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                5. Liability
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Stayverse acts as an intermediary platform and is not directly
                responsible for the services provided by hosts, drivers, or
                chefs. We do not guarantee the accuracy of listings but ensure
                all are verified at the time of posting.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                6. Modifications
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Stayverse reserves the right to modify or update these Terms at
                any time. Continued use of our services after updates
                constitutes acceptance of the revised Terms.
              </p>
            </div>
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
