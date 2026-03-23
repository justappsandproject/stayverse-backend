import Image from "next/image";
import Link from "next/link";
import { Footer } from "../component/footer";

export default function PlatformPolicyPage() {
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
        <h1 className="text-[32px] lg:text-[48px] font-bold text-gray-900 mb-6 leading-tight text-center">
          Stayverse Policy & Process Overview
        </h1>

        <div className="space-y-16">
          {/* SECTION 1: CULINARY */}
          <section>
            <div className="flex items-center gap-4 mb-6 pb-2 border-b border-gray-200">
              <span className="bg-primary-500 text-black p-2 rounded-lg">
                <Image
                  src="/svg/chef-hat-hold.svg"
                  width={24}
                  height={24}
                  alt="Chef"
                  className="w-6 h-6"
                />
              </span>
              <h2 className="text-3xl font-bold text-gray-900">
                STAYVERSE CHEF — Policies & Operating Guidelines
              </h2>
            </div>

            <div className="space-y-8">
              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  Requirements to Join as a Stayverse Chef
                </h3>
                <div className="bg-white rounded-xl p-6 border border-gray-100">
                  <h4 className="font-semibold mb-2">Verification Documents</h4>
                  <ul className="list-disc pl-5 space-y-2 text-gray-700">
                    <li>
                      Valid Government ID (NIN, International Passport, or
                      Driver’s License)
                    </li>
                    <li>
                      Professional Culinary Proof:
                      <ul className="list-circle pl-5 mt-1 text-gray-600">
                        <li>
                          Certificate from culinary school (if available), or
                        </li>
                        <li>
                          Portfolio of past work (food photos + client
                          references)
                        </li>
                      </ul>
                    </li>
                    <li>
                      Business registration (optional but recommended for
                      companies)
                    </li>
                  </ul>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  Operational Standards
                </h3>
                <ul className="grid md:grid-cols-2 gap-4">
                  <li className="bg-white p-4 rounded-lg border border-gray-100 flex items-center gap-3">
                    <span className="w-2 h-2 rounded-full bg-primary-500"></span>
                    Clear menu with prices and portion sizes
                  </li>
                  <li className="bg-white p-4 rounded-lg border border-gray-100 flex items-center gap-3">
                    <span className="w-2 h-2 rounded-full bg-primary-500"></span>
                    Minimum booking notice: 48–72 hours
                  </li>
                  <li className="bg-white p-4 rounded-lg border border-gray-100 flex items-center gap-3">
                    <span className="w-2 h-2 rounded-full bg-primary-500"></span>
                    Timely confirmation of orders via the app
                  </li>
                  <li className="bg-white p-4 rounded-lg border border-gray-100 flex items-center gap-3">
                    <span className="w-2 h-2 rounded-full bg-primary-500"></span>
                    Excellent food hygiene and preparation standards
                  </li>
                  <li className="bg-white p-4 rounded-lg border border-gray-100 flex items-center gap-3">
                    <span className="w-2 h-2 rounded-full bg-primary-500"></span>
                    Receipts for ingredients when necessary
                  </li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-4">
                  Refund & Cancellation Policy (Chef Service)
                </h3>

                <div className="overflow-x-auto mb-6">
                  <table className="w-full text-left border-collapse bg-white rounded-lg overflow-hidden shadow-sm">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          For Customers (Guests) - Situations
                        </th>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Refund Policy
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel 7+ days before service
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel less than 7 days before service
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-yellow-600 bg-yellow-50">
                          50% refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel under 24 hours / No-show
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-red-600 bg-red-50">
                          No refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Chef fails to deliver
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Valid quality complaint
                        </td>
                        <td className="p-4 text-gray-700 font-medium">
                          Partial or full refund after review
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <p className="text-sm text-gray-500 mt-2 italic px-2">
                    **** Customers must provide evidence for quality complaints.
                    Refunds are issued after review.
                  </p>
                </div>

                <div className="overflow-x-auto">
                  <table className="w-full text-left border-collapse bg-white rounded-lg overflow-hidden shadow-sm">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          For Chefs (Provider) - Situations
                        </th>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Policy
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      <tr>
                        <td className="p-4 text-gray-700">
                          Chef cancels booking
                        </td>
                        <td className="p-4 text-gray-700">
                          Full refund to Guest + Chef penalty
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Chef missing an appointment time/date
                        </td>
                        <td className="p-4 text-gray-700">
                          Guest may request refund or discount
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Frequent cancellations (&gt;3 times)
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-red-600 bg-red-50">
                          Temporary suspension
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Disputes between Chef and Guest
                        </td>
                        <td className="p-4 text-gray-700">
                          Payment held until resolution
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <div className="grid md:grid-cols-2 gap-8">
                <div className="bg-white p-6 rounded-xl border border-gray-100">
                  <h3 className="text-lg font-bold text-gray-900 mb-3">
                    Payout & Commission Structure
                  </h3>
                  <ul className="space-y-3 text-gray-700">
                    <li className="flex justify-between border-b border-gray-100 pb-2">
                      <span>Payout Timing</span>
                      <span className="font-medium text-right">
                        After customer confirms delivery
                      </span>
                    </li>
                    <li className="flex justify-between border-b border-gray-100 pb-2">
                      <span>Chef Commission</span>
                      <span className="font-medium text-right">
                        5% (Deducted)
                      </span>
                    </li>
                    <li className="flex justify-between pb-2">
                      <span>Customer Service Fee</span>
                      <span className="font-medium text-right">5%</span>
                    </li>
                  </ul>
                </div>

                <div className="bg-primary-50 p-6 rounded-xl border border-primary-100">
                  <h3 className="text-lg font-bold text-gray-900 mb-3">
                    Communication & Ordering
                  </h3>
                  <p className="text-sm text-gray-600 mb-4">
                    All communication happens inside the Stayverse in-app chat.
                  </p>
                  <ul className="space-y-2 text-sm text-gray-800">
                    <li className="flex items-center gap-2">
                      ✔ Customer sends meal request
                    </li>
                    <li className="flex items-center gap-2">
                      ✔ Chef shares price and confirms details
                    </li>
                    <li className="flex items-center gap-2">
                      ✔ Customer pays in-app
                    </li>
                    <li className="flex items-center gap-2">
                      ✔ Chef sees money pending in dashboard
                    </li>
                    <li className="flex items-center gap-2">
                      ✔ After delivery → Chef is paid
                    </li>
                  </ul>
                </div>
              </div>

              <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4">
                <div className="flex">
                  <div className="ml-3">
                    <h3 className="text-sm font-medium text-yellow-800">
                      🔔 Important Notice for Chefs
                    </h3>
                    <div className="mt-2 text-sm text-yellow-700">
                      <p>
                        Chefs must monitor notifications to avoid missing orders
                        or delays. Missed confirmations may lead to booking loss
                        or penalties.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <hr className="border-gray-200" />

          {/* SECTION 2: CAR RENTALS */}
          <section>
            <div className="flex items-center gap-4 mb-6 pb-2 border-b border-gray-200">
              <span className="bg-primary-500 text-black p-2 rounded-lg">
                <Image
                  src="/svg/car.svg"
                  width={24}
                  height={24}
                  alt="Car"
                  className="w-6 h-6"
                />
              </span>
              <h2 className="text-3xl font-bold text-gray-900">
                STAYVERSE CAR RENTALS — Policies & Guidelines
              </h2>
            </div>

            <p className="text-gray-600 mb-8">
              Stayverse connects customers with verified ride agents, ensuring a
              safe, reliable, and comfortable experience for everyone.
            </p>

            <div className="space-y-8">
              <div className="grid md:grid-cols-2 gap-8">
                <div>
                  <h3 className="text-xl font-bold text-gray-900 mb-3">
                    A. Hourly Rides (Standard)
                  </h3>
                  <ul className="list-disc pl-5 space-y-2 text-gray-700">
                    <li>Customer books for a set number of hours.</li>
                    <li>Payment is made upfront through the app.</li>
                    <li>Stayverse holds the funds securely.</li>
                    <li>
                      After first 2 hours of service, payment is released to
                      agent’s wallet.
                    </li>
                    <li>Remaining balance is released after the ride ends.</li>
                  </ul>
                </div>
                <div>
                  <h3 className="text-xl font-bold text-gray-900 mb-3">
                    B. Special Trips (Custom)
                  </h3>
                  <ul className="list-disc pl-5 space-y-2 text-gray-700">
                    <li>Used for long-distance or special travel needs.</li>
                    <li>Customer and agent negotiate price inside the app.</li>
                    <li>Once agreed, customer proceeds with payment.</li>
                    <li>Payment is held by Stayverse until service begins.</li>
                  </ul>
                </div>
              </div>

              <div className="bg-gray-50 p-6 rounded-xl">
                <h3 className="text-xl font-bold text-gray-900 mb-4">
                  Fees & Vehicle Standards
                </h3>
                <div className="grid md:grid-cols-2 gap-8">
                  <div>
                    <h4 className="font-semibold mb-2">Fees & Charges</h4>
                    <ul className="space-y-2 text-gray-700">
                      <li>
                        • <strong>5% Commission</strong> deducted from agent
                        payment.
                      </li>
                      <li>
                        • <strong>5% Service Charge</strong> applies to
                        customer.
                      </li>
                      <li>
                        • <strong>Security Escort Fee</strong> (₦15,000–₦20,000)
                        for evening/night rides if required.
                      </li>
                    </ul>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">
                      Vehicle & Driver Standards
                    </h4>
                    <ul className="space-y-2 text-gray-700">
                      <li>• AC functional & clean vehicle.</li>
                      <li>• Must pass safety inspection.</li>
                      <li>• Driver professionally trained & neatly dressed.</li>
                      <li>• No smoking/drinking during trips.</li>
                    </ul>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  Refund & Cancellation Policy (Car Rentals)
                </h3>
                <div className="overflow-x-auto mb-6">
                  <table className="w-full text-left border-collapse bg-white rounded-lg overflow-hidden shadow-sm">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Situation
                        </th>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Refund Policy
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      <tr>
                        <td className="p-4 text-gray-700">
                          Customer cancel before ride confirmation
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Customer cancel after confirmation (before start)
                        </td>
                        <td className="p-4 text-gray-700">
                          Refund minus cancellation fee
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Customer cancel after start time
                        </td>
                        <td className="p-4 text-gray-700">
                          Refund only for unused time (case dependent)
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Agent cancels before ride confirmation
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                    </tbody>
                  </table>
                  <p className="text-sm text-gray-500 mt-2 italic px-2">
                    *** Agents may face penalties for repeated cancellations.
                  </p>
                </div>
              </div>
            </div>
          </section>

          <hr className="border-gray-200" />

          {/* SECTION 3: APARTMENTS */}
          <section>
            <div className="flex items-center gap-4 mb-6 pb-2 border-b border-gray-200">
              <span className="bg-primary-500 text-black p-2 rounded-lg">
                <Image
                  src="/svg/house-fill.svg"
                  width={24}
                  height={20}
                  alt="House"
                  className="w-6 h-5"
                />
              </span>
              <h2 className="text-3xl font-bold text-gray-900">
                STAYVERSE APARTMENTS — Policies & Guidelines
              </h2>
            </div>

            <div className="space-y-8">
              <div className="bg-blue-50 p-6 rounded-xl border border-blue-100">
                <h3 className="text-lg font-bold text-blue-900 mb-3">
                  Booking Process for Hosts
                </h3>
                <ul className="space-y-2 text-blue-800">
                  <li>1. Receive notification of customer booking choice.</li>
                  <li>2. Accept or decline based on availability.</li>
                  <li>3. Message customer to adjust details if needed.</li>
                  <li>4. After acceptance, customer pays via app.</li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-bold text-gray-900 mb-3">
                  Refund & Cancellation Policy (Apartments)
                </h3>
                <div className="overflow-x-auto">
                  <table className="w-full text-left border-collapse bg-white rounded-lg overflow-hidden shadow-sm">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Situation
                        </th>
                        <th className="p-4 font-bold text-gray-900 border-b">
                          Refund Policy
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel 7+ days before service
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel less than 7 days before service
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-yellow-600 bg-yellow-50">
                          50% refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Cancel under 24 hours / No-show
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-red-600 bg-red-50">
                          No refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Agent/Host fails to deliver
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-green-600 bg-green-50">
                          Full refund
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Apartment owner cancels booking
                        </td>
                        <td className="p-4 text-gray-700">
                          Full refund to Guest
                        </td>
                      </tr>
                      <tr>
                        <td className="p-4 text-gray-700">
                          Frequent cancellations (&gt;3 times)
                        </td>
                        <td className="p-4 text-gray-700 font-medium text-red-600 bg-red-50">
                          Temporary suspension
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </section>

          {/* Contact Info Footer */}
          <div className="bg-gray-900 text-white p-8 rounded-2xl text-center mt-12">
            <h3 className="text-xl font-bold mb-4">Official Contact</h3>
            <p className="mb-2">AHE 843, Aco Estate Abuja</p>
            <p className="mb-2 space-x-4">
              <a
                href="tel:+2347065185371"
                className="hover:text-primary-500 transition-colors"
              >
                +234-7065185371
              </a>
              <span>|</span>
              <a
                href="tel:+2348166132863"
                className="hover:text-primary-500 transition-colors"
              >
                +234-8166132863
              </a>
            </p>
            <p>
              <a
                href="https://www.stayversepro.com"
                className="hover:text-primary-500 hover:underline transition-colors"
              >
                www.stayversepro.com
              </a>
            </p>
          </div>
        </div>
      </main>

      <Footer />
    </div>
  );
}
