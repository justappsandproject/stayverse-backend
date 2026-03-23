import Image from "next/image";
import Link from "next/link";
import { Footer } from "../component/footer";

export default function PrivacyPage() {
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
        {/* Privacy Policy Section */}
        <section id="privacy" className="mb-[80px]">
          <h1 className="text-[32px] lg:text-[48px] font-bold text-gray-900 mb-6 leading-tight">
            Stayverse Privacy Policy
          </h1>
          <p className="text-gray-600 text-lg mb-10 leading-relaxed">
            Stayverse values your privacy and is committed to protecting your
            personal information. This Privacy Policy explains how we collect,
            use, and protect your data when you use our platform and services.
          </p>

          <div className="space-y-12">
            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                1. Information We Collect
              </h2>
              <p className="text-gray-600 leading-relaxed">
                We may collect personal details such as your name, email
                address, phone number, payment information, and booking history.
                We may also collect non-personal information such as device
                type, browser, and location data for service optimization.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                2. How We Use Your Information
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Your information is used to process bookings, facilitate
                communication with hosts and service providers, improve our
                services, and provide customer support.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                3. Sharing of Information
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Stayverse will never sell your information to third parties. We
                may share your information with hosts, drivers, and chefs
                strictly for fulfilling your bookings. We may also disclose data
                if required by law or to protect our rights.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                4. Data Security
              </h2>
              <p className="text-gray-600 leading-relaxed">
                We implement industry-standard security measures to safeguard
                your data. However, no method of transmission over the internet
                is 100% secure, and we cannot guarantee absolute security.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                5. Your Rights
              </h2>
              <p className="text-gray-600 leading-relaxed">
                You have the right to access, update, or request deletion of
                your personal information. You may also opt out of marketing
                communications at any time.
              </p>
            </div>

            <div>
              <h2 className="text-2xl font-bold text-gray-900 mb-4">
                6. Updates to this Policy
              </h2>
              <p className="text-gray-600 leading-relaxed">
                Stayverse may update this Privacy Policy from time to time. Any
                changes will be communicated on our platform. Continued use of
                our services indicates acceptance of the revised policy.
              </p>
            </div>
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
