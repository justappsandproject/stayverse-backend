
import ContactUs from "./component/contact-us";
import AppToastification from "./component/app-toast";
import { HeroSection } from "./component/herosection";
import { WhyChooseUs } from "./component/why-choose-us";
import { HowItWork } from "./component/how-it-works";
import { Faqs } from "./component/faqs";
import { Footer } from "./component/footer";
import { AllInOne } from "./component/all-in-one";
import { Testimonials } from "./component/testimonials";
import { AboutUs } from "./component/about-us";

export default function Home() {
  const structuredData = {
    "@context": "https://schema.org",
    "@type": "LocalBusiness",
    name: "Stayverse",
    url: "https://stayverse-website-main.vercel.app",
    description:
      "Stayverse helps travelers book verified apartments, private chefs, and rental rides in one place.",
    areaServed: ["Lagos", "Abuja", "Port Harcourt", "Benin City", "Nigeria"],
    sameAs: [
      "https://x.com/stayversepro",
      "https://www.instagram.com/stayversepro",
      "https://www.facebook.com/stayversepro",
      "https://www.linkedin.com/company/stayverse",
    ],
  };

  return (
    <div className="bg-[radial-gradient(circle_at_top_right,_#fff7e2_0%,_#ffffff_40%,_#f5fbff_100%)]">
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
      />
      <AppToastification/>
      <HeroSection />
      <AboutUs />
      <WhyChooseUs />
      <AllInOne />
      <HowItWork />
      <Testimonials />
      <ContactUs />
      <Faqs />
      <Footer />
    </div>
  );
}
