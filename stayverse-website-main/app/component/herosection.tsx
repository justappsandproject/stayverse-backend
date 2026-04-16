import Image from "next/image";
import Link from "next/link";

export function HeroSection() {
  const iosLink = "https://onelink.to/zvdpw6?utm_source=website&utm_medium=hero&utm_campaign=ios_download";
  const androidLink = "https://onelink.to/zvdpw6?utm_source=website&utm_medium=hero&utm_campaign=android_download";

  return (
    <div
      className="w-full min-h-dvh bg-center bg-cover bg-no-repeat relative flex items-center px-5 sm:px-8 lg:px-[100px] animate-fadeIn overflow-hidden"
      style={{
        background:
          "url('/images/large-hotel-palm-trees-beach-thailand 1.png')",
        backgroundSize: "cover",
        backgroundPosition: "center",
        backgroundRepeat: "no-repeat",
      }}
    >
      <header className="fixed top-0 left-0 w-full flex justify-between items-center gap-4 sm:gap-10 px-5 sm:px-8 lg:px-[100px] py-4 z-20 bg-black/55 backdrop-blur-md border-b border-white/10 animate-slideDown">
        <Image
          src={"/logo-white.png"}
          width={144}
          height={25}
          alt="stayverse logo"
          className="hover:scale-105 transition-transform duration-300"
        />
        <nav className="hidden lg:flex justify-center items-center gap-[40px] xl:gap-[60px]">
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
          href={androidLink}
          target="_blank"
          rel="noopener noreferrer"
          className="bg-primary-500 text-black font-medium px-4 sm:px-5 py-2.5 rounded-[50px] flex justify-center hover:bg-primary-600 transition-all duration-300 transform hover:scale-105"
        >
          Get App
        </Link>
      </header>

      <div className="absolute inset-0 w-full h-full bg-linear-to-r from-[#0D0D0D]/95 to-[#0000005C]"></div>
      <div className="absolute -top-24 -left-20 h-60 w-60 rounded-full bg-primary-500/20 blur-3xl pointer-events-none" />
      <div className="absolute -bottom-24 left-1/2 h-64 w-64 rounded-full bg-pink-400/20 blur-3xl pointer-events-none" />
      <div className="max-lg:hidden absolute bottom-0 right-0 max-h-[80%] overflow-hidden animate-slideUpSlow">
        <Image
          src="/images/cheff.png"
          width={400}
          height={700}
          className="w-[400px] aspect-auto"
          alt="chef image"
        />
      </div>
      <div className="max-lg:hidden absolute bottom-0 right-[250px] max-h-[70%] overflow-hidden animate-slideUp">
        <Image
          src="/images/mobile-app.png"
          width={350}
          height={700}
          className="w-[350px] aspect-auto hover:scale-105 transition-transform duration-300"
          alt="mobile app screenshot"
        />
      </div>

      <div className="w-full lg:max-w-[70%] z-10 mt-[120px] sm:mt-[140px] animate-fadeInLeft">
        <h1 className="mb-5 text-[34px] sm:text-[44px] lg:text-[60px] font-bold leading-[1.2] lg:leading-[1.25] text-white tracking-[-0.02em]">
          Find & Book Verified Apartments, Hire Private Chefs & Access Rental Cars <br className="max-lg:hidden" />
          <span className="text-primary-500 animate-pulse">
            All in One Place
          </span>
        </h1>
        <div className="w-full max-w-[680px] mb-8 sm:mb-11 py-3 pl-[18px] border-l-[3px] border-primary-500 bg-white/5 rounded-r-xl backdrop-blur-[2px] animate-slideInLeft">
          <p className="text-white text-[16px] sm:text-[18px] leading-relaxed">
           Whether you're looking for luxury apartments, a professional chef, or a reliable ride to explore cities,
           we've got you covered. We operate in Nigeria including Lagos, Abuja, Port Harcourt, and Benin City,
           with plans to expand across Africa.
          </p>
        </div>

        <div className="mb-6 flex flex-wrap gap-3 text-white text-xs sm:text-sm">
          <span className="rounded-full bg-white/10 border border-white/15 px-3 py-1.5">5 mins average booking</span>
          <span className="rounded-full bg-white/10 border border-white/15 px-3 py-1.5">Verified providers only</span>
          <span className="rounded-full bg-white/10 border border-white/15 px-3 py-1.5">Live in top Nigerian cities</span>
        </div>

        <div className="flex flex-col gap-[17px] mb-10 animate-slideUp">
          <div className="flex flex-wrap items-center gap-4 sm:gap-[24px]">
            <Link
              href={iosLink}
              target="_blank"
              rel="noopener noreferrer"
            >
              <Image
                src="/images/app-store.png"
                width={150}
                height={50}
                alt="app store"
                className="w-[136px] sm:w-[150px] h-auto hover:scale-110 transition-transform duration-300"
              />
            </Link>
            <Link
              href={androidLink}
              target="_blank"
              rel="noopener noreferrer"
            >
              <Image
                src="/images/google-play.png"
                width={150}
                height={50}
                alt="google play"
                className="w-[136px] sm:w-[150px] h-auto hover:scale-110 transition-transform duration-300"
              />
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
