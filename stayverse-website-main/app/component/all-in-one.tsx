import Image from "next/image";

export function AllInOne() {
  return (
    <div
      id="all-in-one"
      className="w-full px-5 sm:px-8 lg:px-[100px] py-10 lg:py-12"
    >
      <div className="max-w-6xl mx-auto bg-[#FBC036]/10 border border-primary-200/40 rounded-3xl p-6 sm:p-8 lg:p-10">
      {/* Header */}
      <div className="max-w-5xl mx-auto mb-10">
        <h1 className="text-3xl md:text-4xl lg:text-5xl font-bold text-gray-900 text-center mb-4 leading-tight">
          Your All-in-One Travel & hospitality Companion
        </h1>
        <p className="text-base sm:text-lg text-gray-700 text-center max-w-3xl mx-auto">
          At Stayverse, we believe travel should be more than moving from place to place — it should be simple, stylish, and unforgettable
        </p>
      </div>

      {/* Service Cards Grid */}
      <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {/* Card 1: Verified Stays */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[320px] md:h-[350px]">
          <Image
            src="/images/book-stay.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Verified Stays Made Easy"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
            <h3 className="text-xl font-bold mb-2">Verified Stays Made Easy</h3>
            <p className="text-sm">
              Discover verified apartments and homes for any stay.
            </p>
          </div>
        </div>

        {/* Card 2: Personal Chefs */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[320px] md:h-[350px]">
          <Image
            src="/images/book-chef.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Personal Chefs at Your Service"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
            <h3 className="text-xl font-bold mb-2">Personal Chefs at Your Service</h3>
            <p className="text-sm">
              Enhance your journey with on-demand chefs and curated meals.
            </p>
          </div>
        </div>

        {/* Card 3: Premium Cars */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[320px] md:h-[350px]">
          <Image
            src="/images/book-ride.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Premium Cars, Effortless Rentals"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-6 text-white">
            <h3 className="text-xl font-bold mb-2">Premium Cars, Effortless Rentals</h3>
            <p className="text-sm">
              Experience effortless travel with luxury cars and trusted drivers.
            </p>
          </div>
        </div>
      </div>
      </div>
    </div>
  );
}