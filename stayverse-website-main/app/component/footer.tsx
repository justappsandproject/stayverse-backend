import Image from "next/image";

export function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="w-full flex flex-col gap-6 py-14 px-5 sm:px-8 lg:py-20 lg:px-[100px] animate-fadeIn bg-white/70 backdrop-blur-sm border-t border-black/5">
      <div className="flex justify-between items-center flex-wrap gap-6">
        <div className="flex items-center gap-5 sm:gap-[25px]">
          <a
            href="https://www.facebook.com/stayversepro"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              src={"/images/facebook-logo.png"}
              width={24}
              height={24}
              alt="facebook logo"
              className="hover:scale-125 transition-transform duration-300"
            />
          </a>
          <a
            href="https://x.com/stayversepro?s=21"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              src={"/images/twitter-logo.png"}
              width={24}
              height={24}
              alt="twitter logo"
              className="hover:scale-125 transition-transform duration-300"
            />
          </a>
          <a
            href="https://www.instagram.com/stayversepro?igsh=bHh5ZnI4emlxaWpv&utm_source=qr"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              src={"/images/instagram-logo.png"}
              width={24}
              height={24}
              alt="instagram logo"
              className="hover:scale-125 transition-transform duration-300"
            />
          </a>
          <a
            href="https://www.linkedin.com/company/stayverse"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              src={"/images/linkedin-logo.png"}
              width={24}
              height={24}
              alt="linkedin logo"
              className="hover:scale-125 transition-transform duration-300"
            />
          </a>
        </div>
        <div className="flex flex-col lg:flex-row lg:items-center gap-4">
          <span className="text-sm sm:text-base text-black text-center lg:text-left">
            All Rights Reserved {currentYear} | Stayverse Ltd
          </span>

          <div className="flex items-center justify-center lg:justify-start flex-wrap gap-3 sm:gap-4 text-sm text-gray-600">
            <a
              href="/terms"
              className="hover:text-primary-500 hover:underline transition-colors"
            >
              Terms & Conditions
            </a>
            <span className="w-1 h-1 bg-gray-400 rounded-full"></span>
            <a
              href="/privacy"
              className="hover:text-primary-500 hover:underline transition-colors"
            >
              Privacy Policy
            </a>
            <span className="w-1 h-1 bg-gray-400 rounded-full"></span>
            <a
              href="/platform-policy"
              className="hover:text-primary-500 hover:underline transition-colors"
            >
              Platform Policy
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
