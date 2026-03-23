import AccordionListItem from "./accordion-list-item";

export function Faqs() {
  return (
    <div
      id="faqs"
      className="w-full flex flex-col gap-5 py-[70px] px-[22px] lg:py-[100px] lg:px-[100px] bg-gray-50 animate-fadeIn"
    >
      <h1 className="text-[40px] lg:text-[58px] leading-[114px] font-bold animate-slideDown">
        Frequently Asked Questions
      </h1>
      <div className="w-full grid gap-8">
        <AccordionListItem
          id="accordion-item-1"
          question="How do I make a booking on Stayverse?"
          answer="Booking on Stayverse is simple! Browse through our curated listings, select your preferred accommodation, catering service, or vehicle, and click 'Book Now.' Follow the prompts to enter your details and complete the payment. You’ll receive a confirmation email with your booking details shortly after."
        />
        <AccordionListItem
          id="accordion-item-2"
          question="Can I modify or cancel my booking?"
          answer="Yes, you can modify or cancel your booking through your Stayverse account. Navigate to 'My Bookings,' choose the reservation you want to change, and select either 'Modify' or 'Cancel.' Please note that cancellation policies may vary depending on the service provider, so be sure to review the terms before confirming changes."
        />
        <AccordionListItem
          id="accordion-item-3"
          question="Are the accommodations verified?"
          answer="Absolutely! Every accommodation listed on Stayverse goes through a rigorous verification process to ensure quality and safety. We carefully vet properties, checking for amenities, cleanliness, and customer reviews, so you can book with confidence."
        />
        <AccordionListItem
          id="accordion-item-4"
          question="What payment methods are accepted on Stayverse?"
          answer="Stayverse accepts all major credit cards, debit cards, and digital wallets. We use secure encryption technology to keep your payment details safe. You'll see available payment options during checkout, making it easy to choose the method that works best for you."
        />
      </div>
    </div>
  );
}
