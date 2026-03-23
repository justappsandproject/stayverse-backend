import Image from "next/image";

export function AboutUs(){
    return (

          <div
                id="about-us"
                className="w-full min-h-[80dvh] bg-primary-500/10 grid grid-cols-1 lg:grid-cols-2 gap-5"
              >
                <div className="relative w-full animate-slideInLeft">
                  <Image
                    src="/images/about-us-image.png"
                    width={500}
                    height={500}
                    className="w-full lg:h-full lg:object-cover hover:scale-[1.02] transition-transform duration-500"
                    alt="about us"
                  />
                </div>
                <div className="flex items-center max-lg:pb-[100px] animate-slideInRight">
                  <div className="w-full px-[22px] lg:px-0 lg:w-[80%] max-w-[606px] flex flex-col gap-[27px]">
                    <h1 className="text-[60px] leading-[115px] font-bold">About Us</h1>
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
        

    );
}