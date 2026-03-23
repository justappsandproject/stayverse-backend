import Image from "next/image";
import Link from "next/link";

export function HeroSection() {
  return (
    <div
      className="w-full min-h-dvh bg-center bg-cover bg-no-repeat relative flex items-center px-[22px] lg:px-[100px] animate-fadeIn"
      style={{
        background:
          "url('/images/large-hotel-palm-trees-beach-thailand 1.png')",
        backgroundSize: "cover",
        backgroundPosition: "center",
        backgroundRepeat: "no-repeat",
      }}
    >
      <header className="absolute top-0 left-0 w-full flex justify-between items-center gap-10 px-[22px] lg:px-[100px] py-[50px] z-10 animate-slideDown">
        <Image
          src={"/logo-white.png"}
          width={144}
          height={25}
          alt="stayverse logo"
          className="hover:scale-105 transition-transform duration-300"
        />
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
          className="bg-primary-500 px-5 py-[10px] rounded-[50px] flex justify-center hover:bg-primary-600 transition-all duration-300 transform hover:scale-105"
        >
          Get App
        </Link>
      </header>

      <div className="absolute inset-0 w-full h-full bg-linear-to-r from-[#0D0D0D] to-[#0000005C]"></div>
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

      <div className="w-full md:max-w-[70%] z-10 mt-[140px] animate-fadeInLeft">
        <h1 className="mb-5 text-[50px] lg:text-[60px] font-bold leading-[77px] md:leading-[80px] lg:leading-[115px] text-white">
          Find & Book Verified Apartments, Hire Private Chefs & Access Rental Cars <br className="max-lg:hidden" />
          <span className="text-primary-500 animate-pulse">
            All in One Place
          </span>
        </h1>
        <div className="w-full max-w-[624px] mb-[44px] py-3 pl-[18px] border-l-[3px] border-primary-500 animate-slideInLeft">
          <p className="text-white text-[18px]">
           Whether you're looking for luxury apartments, a professonal chef, or a reliable ride to explore cities,
           we've got you covered. We operate in Nigeria including Lagos, Abuja,  Port Harcourt, Benin City, and 
           beyound and extends to Africa.
          </p>
        </div>

        <div className="flex flex-col gap-[17px] mb-10 animate-slideUp">
          <div className="flex items-center gap-[30px]">
            <Link
              href="https://onelink.to/zvdpw6"
              target="_blank"
              rel="noopener noreferrer"
            >
              <Image
                src="/images/app-store.png"
                width={150}
                height={50}
                alt="app store"
                className="hover:scale-110 transition-transform duration-300"
              />
            </Link>
            <Link
              href="https://onelink.to/zvdpw6"
              target="_blank"
              rel="noopener noreferrer"
            >
              <Image
                src="/images/google-play.png"
                width={150}
                height={50}
                alt="google play"
                className="hover:scale-110 transition-transform duration-300"
              />
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
