
import Image from "next/image";
export function HowItWork(){
    return (
        <div
        id="how-it-works"
        className="w-full min-h-[80dvh] flex py-[70px] lg:py-[100px] lg:px-[100px] gap-[100px] animate-fadeIn"
      >
        <div className="w-full flex max-lg:flex-col gap-5 bg-[#2C2C2C] lg:rounded-[26px]">
          <div className="w-full lg:w-[50%] flex flex-col gap-8 text-white px-[20px] lg:px-[80px] py-[55px]">
            <h1 className="text-[40px] lg:text-[60px] leading-[115px] font-bold animate-slideDown">
              How it works
            </h1>
            <div className="w-full ml-4 border-l border-l-primary-500 pl-4 space-y-4">
              <div className="relative animate-slideInLeft animation-delay-200">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-8">
                  <span className="font-medium">Book an Apartment</span>
                  <br />
                  <span className="font-normal">
                    Browse and reserve your perfect stay.
                  </span>
                </p>
              </div>
              <div className="relative animate-slideInLeft animation-delay-400">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-8">
                  <span className="font-medium">Hire a Chef</span>
                  <br />
                  <span className="font-normal">
                    Choose a chef to cook meals tailored to your taste.
                  </span>
                </p>
              </div>
              <div className="relative animate-slideInLeft animation-delay-600">
                <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px] animate-pulse"></div>
                <p className="text-base leading-8">
                  <span className="font-medium">Rent a Ride</span>
                  <br />
                  <span className="font-normal">
                    Get a car with a driver, whenever you need.
                  </span>
                </p>
              </div>
            </div>
            <button className="w-[164px] bg-primary-500 rounded-[50px] py-[10px] px-[10px] text-base font-medium text-[#2C2C2C] hover:bg-primary-600 transform hover:scale-105 transition-all duration-300 animate-fadeIn">
              Book Now
            </button>
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