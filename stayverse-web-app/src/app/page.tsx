import { LoginForm } from "@/components/auth/login-form";

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-[#fffaf0] via-white to-[#f8ece5] px-4 py-8">
      <LoginForm />
    </div>
  );
}
