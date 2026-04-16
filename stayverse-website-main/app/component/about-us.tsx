import Image from "next/image";

export function AboutUs(){
    return (

          <div
                id="about-us"
                className="w-full px-5 sm:px-8 lg:px-[100px] py-10 lg:py-12"
              >
                <div className="max-w-6xl mx-auto w-full bg-primary-500/10 rounded-3xl border border-primary-200/40 p-6 sm:p-8 lg:p-10 grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-10">
                <div className="relative w-full animate-slideInLeft min-h-[300px] sm:min-h-[380px] lg:min-h-[460px] rounded-2xl overflow-hidden shadow-[0_12px_34px_rgba(0,0,0,0.16)]">
                  <Image
                    src="/images/rental-apartment.png"
                    fill
                    className="object-cover hover:scale-[1.03] transition-transform duration-500"
                    alt="Beautiful Stayverse apartment"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/45 via-black/5 to-transparent" />
                  <div className="absolute bottom-4 left-4 rounded-full bg-white/90 px-3 py-1.5 text-xs font-semibold text-[#2C2C2C]">
                    Verified stays, chefs & rides
                  </div>
                </div>
                <div className="flex items-center animate-slideInRight">
                  <div className="w-full lg:w-[80%] max-w-[606px] flex flex-col gap-[20px]">
                    <h1 className="text-[34px] sm:text-[42px] lg:text-[50px] leading-tight font-bold">About Us</h1>
                    <p>
                      <strong>Stayverse</strong> is a revolutionary all-in-one platform
                      for travelers, designed to provide seamless access to
                      accommodations, catering services, and premium car rentals.
                      Operating at the intersection of the travel and hospitality
                      industries, Stayverse redefines convenience by integrating
                      essential travel services into a single, user-friendly platform.
                    </p>
        
                    <p>Stayverse simplifies travel by offering:</p>
        
                    <ul>
                      <li>
                        <strong>Effortless Accommodation Listings:</strong> Verified
                        properties for short and long stays with user-friendly booking.
                      </li>
                      <li>
                        <strong>On-Demand Catering Services:</strong> Personal chefs and
                        curated meal services tailored to travelers&apos; needs.
                      </li>
                      <li>
                        <strong>Luxury Car Rentals:</strong> Premium vehicles for a
                        seamless, stylish transportation experience.
                      </li>
                    </ul>
                    <div className="flex items-center gap-[30px] animate-slideUp">
                      <Image
                        src="/images/app-store.png"
                        width={150}
                        height={50}
                        alt="app store"
                        className="hover:scale-110 transition-transform duration-300"
                      />
                      <Image
                        src="/images/google-play.png"
                        width={150}
                        height={50}
                        alt="google play"
                        className="hover:scale-110 transition-transform duration-300"
                      />
                    </div>
                  </div>
                </div>
                </div>
              </div>
        

    );
}