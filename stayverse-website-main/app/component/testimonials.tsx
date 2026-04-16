const testimonials = [
  {
    name: "Amaka E.",
    role: "Frequent traveler",
    city: "Lagos",
    rating: 5,
    quote:
      "Stayverse made my Lagos trip effortless. Apartment, ride, and chef booking all happened in minutes.",
  },
  {
    name: "David O.",
    role: "Business consultant",
    city: "Abuja",
    rating: 5,
    quote:
      "The apartments are exactly as advertised and the ride service is super reliable. Smooth experience end-to-end.",
  },
  {
    name: "Kemi A.",
    role: "Lifestyle creator",
    city: "Port Harcourt",
    rating: 5,
    quote:
      "I loved the private chef option. It gave my stay a premium feel without the stress of planning meals.",
  },
  {
    name: "Tunde M.",
    role: "Remote worker",
    city: "Benin City",
    rating: 5,
    quote:
      "Clean UI, fast support, and quality listings. Stayverse is now my default for short stays in new cities.",
  },
  {
    name: "Chioma N.",
    role: "Weekend explorer",
    city: "Lagos",
    rating: 5,
    quote:
      "Everything felt curated and safe. Booking a place and a ride in one app saved me so much time.",
  },
];

export function Testimonials() {
  const rowOne = testimonials;
  const rowTwo = [...testimonials].reverse();

  return (
    <section className="w-full px-5 sm:px-8 lg:px-[100px] py-10 lg:py-12">
      <div className="max-w-6xl mx-auto rounded-3xl border border-black/5 bg-white p-6 sm:p-8 lg:p-10 shadow-[0_10px_35px_rgba(0,0,0,0.05)]">
        <div className="mb-6 sm:mb-8">
          <h2 className="text-[30px] sm:text-[38px] lg:text-[48px] leading-tight font-bold text-[#1A191E]">
            Loved by Travelers Across Cities
          </h2>
          <p className="text-sm sm:text-base text-[#3b3b3b] mt-2">
            Real feedback from people who book stays, rides, and chefs with Stayverse.
          </p>
        </div>

        <div className="relative overflow-hidden [mask-image:linear-gradient(to_right,transparent,black_10%,black_90%,transparent)] space-y-4">
          <div className="flex w-max gap-4 animate-testimonial-marquee hover:[animation-play-state:paused]">
            {[...rowOne, ...rowOne].map((item, index) => (
              <TestimonialCard key={`${item.name}-one-${index}`} item={item} />
            ))}
          </div>
          <div className="flex w-max gap-4 animate-testimonial-marquee-reverse hover:[animation-play-state:paused]">
            {[...rowTwo, ...rowTwo].map((item, index) => (
              <TestimonialCard key={`${item.name}-two-${index}`} item={item} />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

function TestimonialCard({
  item,
}: {
  item: (typeof testimonials)[number];
}) {
  return (
    <article className="w-[290px] sm:w-[330px] rounded-2xl border border-primary-200/60 bg-[#fffaf0] p-5">
      <div className="mb-2 text-primary-600 text-sm tracking-[0.2em]">
        {"★".repeat(item.rating)}
      </div>
      <p className="text-sm sm:text-base leading-7 text-[#2C2C2C]">
        "{item.quote}"
      </p>
      <div className="mt-4 flex items-center gap-3">
        <div className="h-10 w-10 rounded-full bg-gradient-to-br from-primary-400 to-primary-600 text-[#2C2C2C] font-bold text-sm flex items-center justify-center border border-primary-700/20">
          {item.name.charAt(0)}
        </div>
        <div>
          <p className="text-sm font-semibold text-[#1A191E]">{item.name}</p>
          <p className="text-xs text-[#5f5f5f]">
            {item.role} • {item.city}
          </p>
          <p className="text-[11px] text-emerald-700 font-medium">Verified stay</p>
        </div>
      </div>
    </article>
  );
}
