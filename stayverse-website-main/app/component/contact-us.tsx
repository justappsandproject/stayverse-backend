"use client";

import { useState } from "react";
import { toast } from "react-toastify";
import Util from "../util/util";
import SupabaseService from "../service/supa.base";

function ContactUs() {
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  async function submitContactUs(event: React.FormEvent) {
    event.preventDefault();
    try {
      if (!email || !Util.isValidEmail(email)) {
        toast.error("Please enter a valid email address.");
        return;
      }
      if (!message.trim()) {
        toast.error("Please enter a message.");
        return;
      }

      setLoading(true);
      const response = await SupabaseService.sendContactMessage(email, message);

      if (!response) {
        toast.error("No response from server. Please try again later.");
        return;
      }

      toast.success("Message sent successfully!");
      setEmail("");
      setMessage("");
    } catch (e: unknown) {
      if (e instanceof Error) {
        console.log(e.message);
        toast.error(e.message);
      } else {
        console.log("An unexpected error occurred.");
        toast.error("An unexpected error occurred. Please try again later.");
      }
    } finally {
      setLoading(false);
    }
  }

  return (
    <div
      id="contact-us"
      className="w-full px-5 sm:px-8 lg:px-[100px] py-10 lg:py-12 animate-fadeIn"
    >
      <div className="max-w-6xl mx-auto w-full bg-white rounded-3xl border border-black/5 shadow-[0_10px_35px_rgba(0,0,0,0.05)] p-6 sm:p-8 lg:p-10 flex flex-col lg:flex-row lg:justify-between items-start gap-8">
      <div className="w-full lg:w-[40%] flex items-start gap-3 animate-slideInLeft">
        <h1 className="text-[36px] sm:text-[48px] lg:text-[72px] leading-[1.05] font-bold align-top flex gap-3">
          <div className="w-[23px] h-[23px] aspect-square bg-primary-500 animate-bounce"></div>
          <span className="-mt-[8px]">Reach out to us</span>
        </h1>
      </div>
      <div className="w-full lg:w-[55%] grid gap-5 animate-slideInRight">
        <form onSubmit={submitContactUs} className="w-full">
          <label className="text-sm font-medium text-[#2C2C2C] mb-2 block">
            Message
          </label>
          <textarea
            rows={6}
            className="w-full bg-[#f4f4f4] px-6 py-5 rounded-xl border border-[#d7d7d7] focus:outline-0 placeholder:text-[#3B3B3B] focus:ring-2 focus:ring-primary-500 transition-all duration-300"
            placeholder="Write message"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            disabled={loading}
            required
          ></textarea>

          <div className="w-full flex items-center max-lg:flex-wrap gap-x-3 gap-y-4">
            <label className="text-sm font-medium text-[#2C2C2C] w-full">
              Email address
            </label>
            <input
              type="email"
              className="w-full lg:w-[70%] bg-[#f4f4f4] border border-[#d7d7d7] rounded-[48px] py-4 px-6 text-sm font-medium placeholder:text-[#3B3B3B] focus:ring-2 focus:ring-primary-500 transition-all duration-300"
              placeholder="Enter your email address"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              disabled={loading}
              required
            />
            <button
              type="submit"
              className="w-[40%] min-w-[140px] lg:w-[30%] bg-primary-500 rounded-[48px] py-4 px-5 text-sm font-medium text-[#2C2C2C] hover:bg-primary-600 transform hover:scale-105 transition-all duration-300 disabled:bg-gray-400 disabled:cursor-not-allowed"
              disabled={loading}
            >
              {loading ? "Sending..." : "Submit"}
            </button>
          </div>
          <p className="text-xs text-[#5f5f5f] mt-3">
            Prefer direct contact? Email <a href="mailto:support@stayverse.com" className="underline">support@stayverse.com</a> or call <a href="tel:+2347000000000" className="underline">+234 700 000 0000</a>.
          </p>
        </form>
      </div>
      </div>
    </div>
  );
}

export default ContactUs;
