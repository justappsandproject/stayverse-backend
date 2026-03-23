
/**This is the previous file incase you want to revert back to it **/

// function AccordionListItem({ id, question, answer }: { id: string, question: string, answer: string }) {

//     return (
//         <div className="pb-8 border-b border-b-[#E8E8E8] group ">
//             <input type="checkbox" id={id} className="peer" hidden />
//             <label htmlFor={id} className="w-full mb-4 text-lg leading-6 font-medium text-[#1A191E] cursor-pointer flex items-center justify-between gap-5 peer-checked:[&_img]:rotate-45 transition-transform">
//                 {question}
//                 <Image src={'/svg/plus-icon.svg'} width={14} height={14} alt="plus icon" />
//             </label>
//             <div className="max-h-0 peer-checked:max-h-[999px] transition-[max-height] ease-in-out overflow-hidden">
//                 <p>
//                     {answer}
//                 </p>
//             </div>
//         </div>
//     )
// }

// export default function Home() {

//     return (
//         <div>

//             {/* Hero section */}
//             <div className="w-full min-h-dvh bg-center bg-cover bg-no-repeat relative flex  items-center px-[22px] lg:px-[100px] " style={{
//                 background: "url('/images/large-hotel-palm-trees-beach-thailand 1.png')",
//                 backgroundSize: "cover",
//                 backgroundPosition: "center",
//                 backgroundRepeat: "no-repeat"
//             }} >
//                 {/* Header */}
//                 <header className="absolute top-0 left-0 w-full flex justify-between items-center gap-10 px-[22px] lg:px-[100px] py-[50px] z-10">
//                     <Image src={'/logo-white.png'} width={144} height={25} alt="stayverse logo" />
//                     <nav className="hidden lg:flex justify-center items-center gap-[60px]">
//                         <Link href={'/'} className="text-white text-base font-normal leading-8" >Home</Link>
//                         <Link href="/#about-us" className="text-white text-base font-normal leading-8" >About Us</Link>
//                         <Link href="/#contact-us"  className="text-white text-base font-normal leading-8" >Contact Us</Link>
//                         <Link href="/#faqs"  className="text-white text-base font-normal leading-8" >FAQs</Link>
//                     </nav>
//                     <button className="bg-primary-500 px-5 py-[10px] rounded-[50px] flex justify-center">Get App</button>
//                 </header>

//                 <div className="absolute inset-0 w-full h-full bg-linear-to-r from-[#0D0D0D] to-[#0000005C] "></div>
//                 <div className="max-lg:hidden absolute bottom-0 right-0 max-h-[80%] overflow-hidden">
//                     <Image src="/images/cheff.png" width={400} height={700} className="w-[400px] aspect-auto" alt="chef image" />
//                 </div>
//                 <div className="max-lg:hidden absolute bottom-0 right-[250px] max-h-[70%] overflow-hidden">
//                     <Image src="/images/mobile-app.png" width={350} height={700} className="w-[350px] aspect-auto" alt="mobile app screenshot" />
//                 </div>

//                 <div className="w-full md:max-w-[70%] z-10 mt-[140px] ">
//                     <h1 className="mb-5 text-[50px] lg:text-[60px] font-bold leading-[77px] md:leading-[80px] lg:leading-[115px] text-white ">
//                         Find the Perfect Stay, <br className="max-lg:hidden" />
//                         Chef & Ride - <span className="text-primary-500 ">All in One Place</span>
//                     </h1>
//                     <div className="w-full max-w-[624px] mb-[44px] py-3 pl-[18px] border-l-[3px] border-primary-500 ">
//                         <p className="text-white text-[18px]">
//                             Whether you need a cozy apartment, a personal chef, or a ride to explore the city, we’ve got you covered.
//                             Our platform brings everything together for a hassle-free and premium experience.
//                         </p>
//                     </div>
//                     <div className="w-full max-w-[656px] mb-[65px] flex items-center max-lg:flex-wrap gap-x-[11px] gap-y-[27px] ">
//                         <input type="text" className="w-full lg:w-[70%] bg-white border border-[#8D8D8D4F] rounded-[50px] py-[10px] px-[31px] text-base font-medium placeholder:text-[#DCDCDC] " placeholder="Enter Email to join waitlist" />
//                         <button className="w-[40%] lg:w-[30%] bg-primary-500 rounded-[50px] py-[10px] px-[10px] text-base font-medium text-[#2C2C2C]">Submit</button>
//                     </div>
//                     <div className="flex flex-col gap-[17px] mb-10">
//                         <span className="text-white text-sm font-medium">Coming Soon...</span>
//                         <div className="flex items-centet gap-[30px]">
//                             <Image src="/images/app-store.png" width={150} height={50} alt="app store" />
//                             <Image src="/images/google-play.png" width={150} height={50} alt="google play" />
//                         </div>
//                     </div>

//                     <div className="md:hidden min-h-[60dvh] relative">
//                         <div className="w-full absolute bottom-0 left-[50%] -translate-x-[50%] max-h-[80%] overflow-hidden">
//                             <Image src="/images/mobile-app.png" width={350} height={700} className="w-full max-w-[350px] " alt="chef image" />
//                         </div>
//                     </div>
//                 </div>
//             </div>

//             {/* Why Choose Us section */}
//             <div className="w-full bg-white flex flex-col gap-[60px] px-[20px] lg:px-[100px] pt-[78px] pb-[90px]">
//                 <h1 className="text-[40px] lg:text-[60px] leading-[115px] font-bold text-center ">
//                     Why Choose Us?
//                 </h1>
//                 <div className="w-full flex max-md:flex-col max-md:justify-center justify-between items-center max-md:gap-10 gap-20 ">
//                     <div className="w-full md:w-[50%] flex flex-col gap-[55px] lg:gap-[60px] ">
//                         <div className="flex items-center gap-4">
//                             <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 ">
//                                 <Image src={'/svg/house-fill.svg'} width={22} height={20} alt="house fill icon" />
//                             </span>
//                             <p className="text-base leading-8">
//                                 <span className="font-medium">Handpicked Apartments</span><br />
//                                 <span className="font-normal">Stay in top-tier, fully furnished spaces that feel like home.</span>
//                             </p>
//                         </div>
//                         <div className="flex items-center gap-4">
//                             <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 ">
//                                 <Image src={'/svg/chef-hat-hold.svg'} width={20} height={20} alt="house fill icon" />
//                             </span>
//                             <p className="text-base leading-8">
//                                 <span className="font-medium">Personal Chefs On-Demand</span><br />
//                                 <span className="font-normal">Enjoy delicious, custom-made meals prepared by skilled chefs.</span>
//                             </p>
//                         </div>
//                         <div className="flex items-center gap-4">
//                             <span className="w-[45px] aspect-square bg-primary-500 rounded-full shrink-0 flex justify-center items-center gap-2 ">
//                                 <Image src={'/svg/car.svg'} width={18} height={16} alt="house fill icon" />
//                             </span>
//                             <p className="text-base leading-8">
//                                 <span className="font-medium">Reliable Rides</span><br />
//                                 <span className="font-normal">Get where you need to be with ease using our trusted vehicle rental service.</span>
//                             </p>
//                         </div>
//                     </div>
//                     <div className="w-full md:w-[50%] ">
//                         <div className="w-[90%] ms-auto relative ">
//                             <Image src="/images/Rectangle 32.png" width={482} height={95} className="absolute -top-[15px] -left-[13px] -z-[0] " alt="why choose us" />
//                             <Image src="/images/rental-apartment.png" width={500} height={500} className="relative " alt="why choose us" />
//                             <Image src="/images/male-chef-frying.png" width={200} height={200} className="absolute top-[100px] -left-[44px]" alt="why choose us" />
//                             <Image src="/images/rental-driver.png" width={200} height={200} className="absolute -bottom-[46px] left-[31px]" alt="why choose us" />
//                         </div>
//                     </div>
//                 </div>
//             </div>

//             {/* About Us */}

//             <div id="about-us" className="w-full min-h-[80dvh] bg-primary-500/10 grid grid-cols-1 lg:grid-cols-2 gap-5">
//                 <div className="relative w-full ">
//                     <Image src="/images/about-us-image.png" width={500} height={500} className="w-full lg:h-full lg:object-cover" alt="about us" />
//                 </div>
//                 <div className="flex items-center max-lg:pb-[100px">
//                     <div className="w-full px-[22px] lg:px-0 lg:w-[80%] max-w-[606px] flex flex-col gap-[27px] ">
//                         <h1 className="text-[60px] leading-[115px] font-bold ">About Us</h1>
//                         <p>
//     <strong>Stayverse</strong> is a revolutionary all-in-one platform for travelers, designed to provide seamless access to accommodations, catering services, and premium car rentals. Operating at the intersection of the travel and hospitality industries, Stayverse redefines convenience by integrating essential travel services into a single, user-friendly platform.
// </p>

// <p>Stayverse simplifies travel by offering:</p>

// <ul>
//     <li>
//         <strong>Effortless Accommodation Listings:</strong> Verified properties for short and long stays with user-friendly booking.
//     </li>
//     <li>
//         <strong>On-Demand Catering Services:</strong> Personal chefs and curated meal services tailored to travelers' needs.
//     </li>
//     <li>
//         <strong>Luxury Car Rentals:</strong> Premium vehicles for a seamless, stylish transportation experience.
//     </li>
// </ul>

//                         <div className="flex items-center gap-[30px]">
//                             <Image src="/images/app-store.png" width={150} height={50} alt="app store" />
//                             <Image src="/images/google-play.png" width={150} height={50} alt="google play" />
//                         </div>
//                     </div>
//                 </div>
//             </div>

//             {/* How it works */}
//             <div id ='how-it-works' className="w-full min-h-[80dvh] flex py-[70px] lg:py-[100px] lg:px-[100px] gap-[100px]">
//                 <div className="w-full flex max-lg:flex-col gap-5 bg-[#2C2C2C]  lg:rounded-[26px] ">
//                     <div className="w-full lg:w-[50%] flex flex-col gap-8 text-white px-[20px] lg:px-[80px] py-[55px] ">
//                         <h1 className="text-[40px] lg:text-[60px] leading-[115px] font-bold ">How it works</h1>
//                         <div className="w-full ml-4 border-l border-l-primary-500 pl-4 space-y-4">
//                             <div className="relative">
//                                 <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px]"></div>
//                                 <p className="text-base leading-8 ">
//                                     <span className="font-medium">Book an Apartments</span><br />
//                                     <span className="font-normal">Browse and reserve your perfect stay.</span>
//                                 </p>
//                             </div>

//                             <div className="relative">
//                                 <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px]"></div>
//                                 <p className="text-base leading-8">
//                                     <span className="font-medium">Hire a Chef</span><br />
//                                     <span className="font-normal">Choose a chef to cook meals tailored to your taste.</span>
//                                 </p>
//                             </div>

//                             <div className="relative">
//                                 <div className="w-4 h-4 rounded-full bg-primary-500 absolute -left-[24px]"></div>
//                                 <p className="text-base leading-8">
//                                     <span className="font-medium">Rent a Ride</span><br />
//                                     <span className="font-normal">Get a car with a driver, whenever your need.</span>
//                                 </p>
//                             </div>
//                         </div>
//                         <button className="w-[164px] bg-primary-500 rounded-[50px] py-[10px] px-[10px] text-base font-medium text-[#2C2C2C]">
//                             Book Now
//                         </button>
//                     </div>

//                     <div className="w-full lg:w-[50%] h-full max-lg:min-h-[60dvh] relative ">
//                         <div className="hidden lg:block absolute left-0 top-0 rotate-180 max-h-[80%] overflow-hidden">
//                             <Image src="/images/mobile-app.png" width={350} height={700} className="w-[288px]  " alt="chef image" />
//                         </div>

//                         <div className="hidden lg:block absolute right-[40px] bottom-0  max-h-[80%] overflow-hidden">
//                             <Image src="/images/mobile-app.png" width={350} height={700} className="w-[288px]  " alt="chef image" />
//                         </div>

//                         <Image src="/images/mobile-app.png" width={360} height={700} className="block lg:hidden absolute left-[50%] -translate-x-[50%] bottom-0 w-full max-w-[360px] " alt="chef image" />

//                         {/* <div className="block lg:hidden absolute left-[50%] -translate-x-[50%] bottom-0 max-h-[80%] overflow-hidden">
//                             <Image src="/images/mobile-app.png" width={360} height={700} className="absolute left-[50%] -translate-x-[50%] w-full max-w-[360px] " alt="chef image" />
//                         </div> */}
//                     </div>
//                 </div>

//             </div>

//             {/* Reach out */}
//             <div id ='contact-us'  className="w-full flex flex-col lg:flex-row lg:justify-between items-start gap-5 py-[70px] px-[22px] lg:py-[100px] lg:px-[100px]">
//                 <div className="w-full lg:w-[40%] flex items-start gap-3">
//                     <h1 className="text-[50px] lg:text-[96px] leading-[64px] lg:leading-[115px] font-bold align-top flex gap-3">
//                         <div className="w-[23px] h-[23px] aspect-square bg-primary-500 align-top "></div>
//                         <span className="-mt-[15px]">Reach out to us</span>
//                     </h1>
//                 </div>
//                 <div className="w-full lg:w-[55%] grid gap-[23px]">
//                     <textarea rows={6} className="bg-[#D9D9D93D] px-10 py-6 rounded-[9px] focus:outline-0 placeholder:text-[#3B3B3B] " placeholder="Write message"></textarea>
//                     <div className="w-full flex items-center max-lg:flex-wrap gap-x-[18px] gap-y-[30px] ">
//                         <input type="text" className="w-full lg:w-[70%] bg-[#D9D9D93D] border-0 rounded-[48px] py-5 px-[31px] text-xs font-medium placeholder:text-[#3B3B3B] " placeholder="Enter Email to join waitlist" />
//                         <button className="w-[40%] lg:w-[30%] bg-primary-500 rounded-[48px] py-5 px-5 text-xs font-medium text-[#2C2C2C] focus:outline-0">Submit</button>
//                     </div>
//                 </div>
//             </div>

//             {/* Frequently Asked Questions */}
//             <div id = 'faqs' className="w-full flex flex-col gap-5 py-[70px] px-[22px] lg:py-[100px] lg:px-[100px] bg-gray-50">
//                 <h1 className="text-[40px] lg:text-[58px] leading-[114px] font-bold ">Frequently Asked Questions</h1>
//                 <div className="w-full grid gap-8">

//                 <AccordionListItem
//     id="accordion-item-1"
//     question="How do I make a booking on Stayverse?"
//     answer="Booking on Stayverse is simple! Browse through our curated listings, select your preferred accommodation, catering service, or vehicle, and click 'Book Now.' Follow the prompts to enter your details and complete the payment. You’ll receive a confirmation email with your booking details shortly after."
// />
// <AccordionListItem
//     id="accordion-item-2"
//     question="Can I modify or cancel my booking?"
//     answer="Yes, you can modify or cancel your booking through your Stayverse account. Navigate to 'My Bookings,' choose the reservation you want to change, and select either 'Modify' or 'Cancel.' Please note that cancellation policies may vary depending on the service provider, so be sure to review the terms before confirming changes."
// />
// <AccordionListItem
//     id="accordion-item-3"
//     question="Are the accommodations verified?"
//     answer="Absolutely! Every accommodation listed on Stayverse goes through a rigorous verification process to ensure quality and safety. We carefully vet properties, checking for amenities, cleanliness, and customer reviews, so you can book with confidence."
// />
// <AccordionListItem
//     id="accordion-item-4"
//     question="What payment methods are accepted on Stayverse?"
//     answer="Stayverse accepts all major credit cards, debit cards, and digital wallets. We use secure encryption technology to keep your payment details safe. You'll see available payment options during checkout, making it easy to choose the method that works best for you."
// />

//                 </div>
//             </div>

//              {/* Footer */}
// <footer className="w-full flex flex-col gap-5 py-[70px] px-[22px] lg:py-[100px] lg:px-[100px] ">
//     <div className="flex justify-between items-center flex-wrap gap-5">
//         <div className="flex items-center gap-[25px] ">
//             <a href="https://x.com/stayversepro?s=21" target="_blank" rel="noopener noreferrer">
//                 <Image src={'/images/facebook-logo.png'} width={24} height={24} alt="facebook logo" />
//             </a>
//             <a href="https://x.com/stayversepro?s=21" target="_blank" rel="noopener noreferrer">
//                 <Image src={'/images/twitter-logo.png'} width={24} height={24} alt="twitter logo" />
//             </a>
//             <a href="https://www.instagram.com/stayversepro?igsh=bHh5ZnI4emlxaWpv&utm_source=qr" target="_blank" rel="noopener noreferrer">
//                 <Image src={'/images/instagram-logo.png'} width={24} height={24} alt="instagram logo" />
//             </a>
//             <a href="https://x.com/stayversepro?s=21" target="_blank" rel="noopener noreferrer">
//                 <Image src={'/images/linkedin-logo.png'} width={24} height={24} alt="linkedin logo" />
//             </a>
//         </div>
//         <span className="text-base text-black">All Rights Reserved 2025 | Stayverse. Ltd</span>
//     </div>
// </footer>

//         </div>
//     )
// }
