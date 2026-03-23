import type { Config } from "tailwindcss";

export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "var(--background)",
        foreground: "var(--foreground)",
        primary: {
          100: "#fef2d7",
          200: "#fde6af",
          300: "#fdd986",
          400: "#fccd5e",
          500: "#fbc036",
          600: "#c99a2b",
          700: "#977320",
          800: "#644d16",
          900: "#32260b"
        },
        peach: {
          100: "#ffe5e3",
          200: "#ffccc7",
          300: "#feb2ac",
          400: "#fe9990",
          500: "#fe7f74",
          600: "#cb665d",
          700: "#984c46",
          800: "#66332e",
          900: "#331917"
        },
        pink: {
          100: "#ffeef4",
          200: "#ffdde9",
          300: "#ffccdf",
          400: "#ffbbd4",
          500: "#ffaac9",
          600: "#cc88a1",
          700: "#996679",
          800: "#664450",
          900: "#332228"
        },
        lightblue: {
          100: "#f4fcfe",
          200: "#eaf9fc",
          300: "#dff6fb",
          400: "#d5f3f9",
          500: "#caf0f8",
          600: "#a2c0c6",
          700: "#799095",
          800: "#516063",
          900: "#283032"
        },
      },
    },
  },
  plugins: [],
} satisfies Config;
