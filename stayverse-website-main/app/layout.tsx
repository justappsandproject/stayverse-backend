import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Stayverse | Book Apartments, Rides & Private Chefs Easily",
  description:
    "Discover your perfect stay, book reliable rides, and hire top-rated chefs — all in one platform. Stayverse connects you to seamless hospitality services with the best experiences.",
  keywords:
    "apartment booking, ride-hailing, private chefs, travel services, Stayverse, vacation rentals, local transportation, dining experiences",
  openGraph: {
    title: "Stayverse | Book Apartments, Rides & Private Chefs Easily",
    description:
      "Explore Stayverse for hassle-free apartment bookings, convenient rides, and professional chef services. Your all-in-one hospitality solution.",
    url: "https://www.stayverse.com",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    site: "@stayverse",
    title: "Stayverse | Book Apartments, Rides & Private Chefs Easily",
    description:
      "Stayverse makes booking apartments, rides, and chefs a breeze. Experience seamless hospitality services in one app.",
  },
  icons: {
    icon: "/icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
