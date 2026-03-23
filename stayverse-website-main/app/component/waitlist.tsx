"use client";

import { useState } from "react";
import { toast } from "react-toastify";
import SupabaseService from "../service/supa.base";
import Util from "../util/util";

function Waitlist() {
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);

  async function submitWaitlist(event: React.FormEvent) {
    event.preventDefault();
    try {
      if (!email || !Util.isValidEmail(email)) {
        toast.error("Please enter a valid email address.");
        return;
      }

      setLoading(true);
      const response = await SupabaseService.addToWaitlist(email);

      if (!response) {
        toast.error("No response from server. Please try again later.");
        return;
      }

      toast.success("Successfully joined the waitlist!");
      setEmail("");
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
    <form
      onSubmit={submitWaitlist}
      className="w-full max-w-[656px] mb-[65px] flex items-center max-lg:flex-wrap gap-x-[11px] gap-y-[27px] animate-fadeIn"
    >
      <input
        type="email"
        className="w-full lg:w-[70%] bg-white border border-[#8D8D8D4F] rounded-[50px] py-[10px] px-[31px] text-base font-medium placeholder:text-[#DCDCDC] focus:ring-2 focus:ring-primary-500 transition-all duration-300"
        placeholder="Enter Email to join waitlist"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        disabled={loading}
        required
      />
      <button
        type="submit"
        className="w-[40%] lg:w-[30%] bg-primary-500 rounded-[50px] py-[10px] px-[10px] text-base font-medium text-[#2C2C2C] hover:bg-primary-600 transform hover:scale-105 transition-all duration-300 disabled:bg-gray-400 disabled:cursor-not-allowed"
        disabled={loading}
      >
        {loading ? "Submitting..." : "Submit"}
      </button>
    </form>
  );
}

export default Waitlist;
