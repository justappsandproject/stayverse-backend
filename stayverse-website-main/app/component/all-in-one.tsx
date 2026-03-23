import Image from "next/image";

export function AllInOne() {
  return (
    <div
      id="all-in-one"
      className="w-full bg-[#FBC036]/10 px-6 md:px-12 lg:px-24 py-24"
    >
      {/* Header */}
      <div className="max-w-7xl mx-auto mb-12">
        <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold text-gray-900 text-center mb-6">
          Your All-in-One Travel & hospitality Companion
        </h1>
        <p className="text-lg text-gray-700 text-center max-w-3xl mx-auto">
          At Stayverse, we believe travel should be more than moving from place to place — it should be simple, stylish, and unforgettable
        </p>
      </div>

      {/* Service Cards Grid */}
      <div className="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {/* Card 1: Verified Stays */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[400px]">
          <Image
            src="/images/book-stay.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Verified Stays Made Easy"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
            <h3 className="text-xl font-bold mb-2">Verified Stays Made Easy</h3>
            <p className="text-sm">
              Discover verified apartments and homes for any stay.
            </p>
          </div>
        </div>

        {/* Card 2: Personal Chefs */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[400px]">
          <Image
            src="/images/book-chef.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Personal Chefs at Your Service"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
            <h3 className="text-xl font-bold mb-2">Personal Chefs at Your Service</h3>
            <p className="text-sm">
              Enhance your journey with on-demand chefs and curated meals.
            </p>
          </div>
        </div>

        {/* Card 3: Premium Cars */}
        <div className="relative rounded-3xl overflow-hidden group cursor-pointer h-[400px]">
          <Image
            src="/images/book-ride.png"
            width={500}
            height={400}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
            alt="Premium Cars, Effortless Rentals"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/30 to-transparent"></div>
          <div className="absolute bottom-0 left-0 right-0 p-8 text-white">
            <h3 className="text-xl font-bold mb-2">Premium Cars, Effortless Rentals</h3>
            <p className="text-sm">
              Experience effortless travel with luxury cars and trusted drivers.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}