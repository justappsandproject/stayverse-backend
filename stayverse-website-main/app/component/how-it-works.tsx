
import Image from "next/image";
import Link from "next/link";
export function HowItWork(){
    return (
        <div
        id="how-it-works"
        className="w-full flex py-10 lg:py-12 px-5 sm:px-8 lg:px-[100px] animate-fadeIn"
      >
        <div className="w-full max-w-6xl mx-auto flex max-lg:flex-col gap-4 bg-[#2C2C2C] rounded-3xl border border-white/10 shadow-[0_12px_40px_rgba(0,0,0,0.22)]">
          <div className="w-full lg:w-[50%] flex flex-col gap-6 text-white px-6 sm:px-8 lg:px-12 py-8 sm:py-10">
            <h1 className="text-[32px] sm:text-[40px] lg:text-[48px] leading-tight font-bold animate-slideDown">
              How it works
            </h1>
            <div className="w-full ml-4 border-l border-l-primary-500 pl-4 space-y-5">
              <div className="relative animate-slideInLeft animation-delay-200">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-7">
                  <span className="font-medium">1. Pick your service in under 1 minute</span>
                  <br />
                  <span className="font-normal">
                    Choose apartment stays, private chef bookings, or a ride based on your schedule.
                  </span>
                </p>
              </div>
              <div className="relative animate-slideInLeft animation-delay-400">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-7">
                  <span className="font-medium">2. Compare verified options in 2-3 minutes</span>
                  <br />
                  <span className="font-normal">
                    Review ratings, pricing, and availability from trusted providers.
                  </span>
                </p>
              </div>
              <div className="relative animate-slideInLeft animation-delay-600">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-7">
                  <span className="font-medium">3. Confirm and you're set in under 5 minutes</span>
                  <br />
                  <span className="font-normal">
                    Book securely and get instant confirmation details for your trip.
                  </span>
                </p>
              </div>
            </div>
            <Link
              href="https://onelink.to/zvdpw6?utm_source=website&utm_medium=how_it_works&utm_campaign=download"
              target="_blank"
              rel="noopener noreferrer"
              className="w-[164px] text-center bg-primary-500 rounded-[50px] py-[10px] px-[10px] text-base font-medium text-[#2C2C2C] hover:bg-primary-600 transform hover:scale-105 transition-all duration-300 animate-fadeIn"
            >
              Book Now
            </Link>
          </div>

          <div className="w-full lg:w-[50%] h-full max-lg:min-h-[60dvh] relative animate-fadeInRight">
            <Image
              src="/images/mobile-app.png"
              width={360}
              height={700}
              className="block lg:hidden absolute left-[50%] -translate-x-[50%] bottom-0 w-full max-w-[360px] animate-slideUp"
              alt="mobile app image"
              priority
            />

            <div className="hidden lg:block absolute left-0 top-0 rotate-180 max-h-[80%] overflow-hidden animate-slideInLeft">
              <Image
                src="/images/mobile-app.png"
                width={350}
                height={700}
                className="w-[288px]"
                alt="chef image"
              />
            </div>
            <div className="hidden lg:block absolute right-[40px] bottom-0 max-h-[80%] overflow-hidden animate-slideInRight">
              <Image
                src="/images/mobile-app.png"
                width={350}
                height={700}
                className="w-[288px]"
                alt="chef image"
              />
            </div>
          </div>
        </div>
      </div>
    );
}