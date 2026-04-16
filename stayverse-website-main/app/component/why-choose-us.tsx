import Image from "next/image";


export function WhyChooseUs() {
  return (
    <section className="w-full px-5 sm:px-8 lg:px-[100px] py-12 lg:py-14">
      <div className="max-w-6xl mx-auto bg-white rounded-3xl border border-black/5 shadow-[0_10px_35px_rgba(0,0,0,0.05)] p-6 sm:p-8 lg:p-10 flex flex-col gap-10">
      <h1 className="text-[30px] sm:text-[38px] lg:text-[48px] leading-tight font-bold text-center animate-fadeIn">
        Why Choose Us?
      </h1>
      <div className="w-full flex max-md:flex-col max-md:justify-center justify-between items-center max-md:gap-10 gap-10 lg:gap-14">
        <div className="w-full md:w-[50%] flex flex-col gap-[55px] lg:gap-[60px]">
          <div className="flex items-center gap-4 animate-slideInLeft animation-delay-200">
            <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 transform hover:rotate-12 transition-transform duration-300">
              <Image
                src={"/svg/house-fill.svg"}
                width={22}
                height={20}
                alt="house fill icon"
              />
            </span>
            <p className="text-base leading-7">
              <span className="font-medium">Handpicked Apartments</span>
              <br />
              <span className="font-normal">
                Stay in top-tier, fully furnished spaces that feel like home.
              </span>
            </p>
          </div>
          <div className="flex items-center gap-4 animate-slideInLeft animation-delay-400">
            <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 transform hover:rotate-12 transition-transform duration-300">
              <Image
                src={"/svg/chef-hat-hold.svg"}
                width={20}
                height={20}
                alt="chef hat icon"
              />
            </span>
            <p className="text-base leading-7">
              <span className="font-medium">Personal Chefs On-Demand</span>
              <br />
              <span className="font-normal">
                Enjoy delicious, custom-made meals prepared by skilled chefs.
              </span>
            </p>
          </div>
          <div className="flex items-center gap-4 animate-slideInLeft animation-delay-600">
            <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 transform hover:rotate-12 transition-transform duration-300">
              <Image
                src={"/svg/car.svg"}
                width={18}
                height={16}
                alt="car icon"
              />
            </span>
            <p className="text-base leading-7">
              <span className="font-medium">Reliable Rides</span>
              <br />
              <span className="font-normal">
                Get where you need to be with ease using our trusted vehicle
                rental service.
              </span>
            </p>
          </div>
        </div>
        <div className="w-full md:w-[50%] animate-fadeInRight">
          <div className="w-[90%] ms-auto relative">
            <Image
              src="/images/Rectangle 32.png"
              width={482}
              height={95}
              className="absolute -top-[15px] -left-[13px] -z-[0] animate-pulse"
              alt="why choose us"
            />
            <Image
              src="/images/rental-apartment.png"
              width={500}
              height={500}
              className="relative hover:scale-105 transition-transform duration-300"
              alt="why choose us"
            />
            <Image
              src="/images/male-chef-frying.png"
              width={200}
              height={200}
              className="absolute top-[100px] -left-[44px] animate-bounceSlow"
              alt="why choose us"
            />
            <Image
              src="/images/rental-driver.png"
              width={200}
              height={200}
              className="absolute -bottom-[46px] left-[31px] animate-bounceSlow animation-delay-300"
              alt="why choose us"
            />
          </div>
        </div>
      </div>
      </div>
    </section>
  );
}
