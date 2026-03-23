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
      className="w-full flex flex-col lg:flex-row lg:justify-between items-start gap-5 py-[70px] px-[22px] lg:py-[100px] lg:px-[100px] animate-fadeIn"
    >
      <div className="w-full lg:w-[40%] flex items-start gap-3 animate-slideInLeft">
        <h1 className="text-[50px] lg:text-[96px] leading-[64px] lg:leading-[115px] font-bold align-top flex gap-3">
          <div className="w-[23px] h-[23px] aspect-square bg-primary-500 animate-bounce"></div>
          <span className="-mt-[15px]">Reach out to us</span>
        </h1>
      </div>
      <div className="w-full lg:w-[55%] grid gap-[23px] animate-slideInRight">
        <form onSubmit={submitContactUs} className="w-full">
          <textarea
            rows={6}
            className="w-full bg-[#D9D9D93D] px-10 py-6 rounded-[9px] focus:outline-0 placeholder:text-[#3B3B3B] focus:ring-2 focus:ring-primary-500 transition-all duration-300"
            placeholder="Write message"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            disabled={loading}
            required
          ></textarea>

          <div className="w-full flex items-center max-lg:flex-wrap gap-x-[18px] gap-y-[30px]">
            <input
              type="email"
              className="w-full lg:w-[70%] bg-[#D9D9D93D] border-0 rounded-[48px] py-5 px-[31px] text-xs font-medium placeholder:text-[#3B3B3B] focus:ring-2 focus:ring-primary-500 transition-all duration-300"
              placeholder="Enter your email address"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              disabled={loading}
              required
            />
            <button
              type="submit"
              className="w-[40%] lg:w-[30%] bg-primary-500 rounded-[48px] py-5 px-5 text-xs font-medium text-[#2C2C2C] hover:bg-primary-600 transform hover:scale-105 transition-all duration-300 disabled:bg-gray-400 disabled:cursor-not-allowed"
              disabled={loading}
            >
              {loading ? "Sending..." : "Submit"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default ContactUs;
