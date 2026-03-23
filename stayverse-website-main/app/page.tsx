
import ContactUs from "./component/contact-us";
import AppToastification from "./component/app-toast";
import { HeroSection } from "./component/herosection";
import { WhyChooseUs } from "./component/why-choose-us";
import { HowItWork } from "./component/how-it-works";
import { Faqs } from "./component/faqs";
import { Footer } from "./component/footer";
import { AllInOne } from "./component/all-in-one";

export default function Home() {
  return (
    <div>
      <AppToastification/>
      <HeroSection />
      <WhyChooseUs />
      <AllInOne />
      <HowItWork />
      <ContactUs />
      <Faqs />
      <Footer />
    </div>
  );
}
