import type React from "react"

import { useState } from "react"
import { Eye, EyeOff } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Checkbox } from "@/components/ui/checkbox"
import bedroomImage from "@/assets/images/bedroom-image.png"
import chefImage from "@/assets/images/chef-salting-image.png"
import driverImage from "@/assets/images/uver-driver-image.png"
import useAuthStore from "@/stores/auth.store"


export default function SigninPage() {
    const { login } = useAuthStore();
    const [showPassword, setShowPassword] = useState(false)
    const [email, setEmail] = useState("")
    const [password, setPassword] = useState("")
    const [rememberInfo, setRememberInfo] = useState(false)
    const [isLoading, setIsLoading] = useState(false)

    const togglePasswordVisibility = () => {
        setShowPassword(!showPassword)
    }

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        if (isLoading) return;
        
        setIsLoading(true)
        try {
            await login(email, password)
        } catch (error) {
            console.error("Login failed:", error)
        } finally {
            setIsLoading(false)
        }
    }

    return (
        <div className="w-full h-screen flex flex-col md:flex-row">
            {/* Form Section */}
            <div className="w-full md:w-1/2 p-6 md:p-12 flex justify-center items-center ">
                <div className="w-full max-w-md mx-auto md:mx-0 animate-fade-in">
                    <h1 className="text-3xl md:text-4xl font-bold mb-2">Create Account</h1>
                    <p className="text-muted-foreground mb-8">Enter your credentials to create your account.</p>

                    <form onSubmit={handleSubmit} className="space-y-6">
                        <div className="space-y-2">
                            <label htmlFor="email" className="block font-medium">
                                Email address
                            </label>
                            <Input
                                id="email"
                                type="email"
                                placeholder="company@gmail.com"
                                value={email}
                                onChange={(e) => setEmail(e.target.value)}
                                className="h-12"
                                required
                            />
                        </div>

                        <div className="space-y-2">
                            <label htmlFor="password" className="block font-medium">
                                Choose password
                            </label>
                            <div className="relative">
                                <Input
                                    id="password"
                                    type={showPassword ? "text" : "password"}
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                    className="h-12 pr-10"
                                    required
                                />
                                <button
                                    type="button"
                                    onClick={togglePasswordVisibility}
                                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                                    aria-label={showPassword ? "Hide password" : "Show password"}
                                >
                                    {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                                </button>
                            </div>
                        </div>

                        <div className="flex items-center space-x-2">
                            <Checkbox
                                id="remember"
                                checked={rememberInfo}
                                onCheckedChange={(checked) => setRememberInfo(checked as boolean)}
                                className="border-[#FBC036] data-[state=checked]:bg-[#FBC036] data-[state=checked]:text-white"
                            />
                            <label
                                htmlFor="remember"
                                className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                            >
                                Remember Information
                            </label>
                        </div>

                        <Button 
                            type="submit" 
                            className="w-full h-12 bg-[#FBC036] hover:bg-[#e9b12f] text-black font-medium"
                            disabled={isLoading}
                        >
                            {isLoading ? (
                                <div className="flex items-center justify-center space-x-2">
                                    <svg className="animate-spin h-5 w-5 text-black" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    <span>Signing in...</span>
                                </div>
                            ) : 'Sign In'}
                        </Button>
                    </form>
                </div>
            </div>

            {/* Images Section */}
            <div className="hidden md:block w-1/2 relative overflow-hidden">
                {/* Yellow pattern background */}
                <div className="absolute inset-y-0 right-0 bg-[#FBC036]/10">
                    <img
                        src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/yellow-pattern-background-xQCgHTWnq3sHMYZKzqMK4dn8YqftMu.png"
                        alt="Background pattern"
                        className="w-full h-full object-cover"
                    />
                </div>

                {/* Bedroom image (largest, background) */}
                <div className="absolute inset-y-0 right-0 w-[80%] h-[70%] my-auto rounded-l-lg shadow-lg">
                    <div className="w-full h-full rounded-l-lg overflow-hidden">
                        <img
                            src={bedroomImage}
                            alt="Comfortable hotel room"
                            className="w-full h-full object-cover"
                        />
                    </div>

                    <div className="absolute inset-0 -left-10 my-auto w-[40%] h-[33%] rounded-lg overflow-hidden shadow-lg">
                        <img
                            src={chefImage}
                            alt="Chef preparing food"
                            className="w-full h-full object-cover"
                        />
                    </div>

                    <div className="absolute inset-x-10 -bottom-14 w-[51%] h-[40%] rounded-lg overflow-hidden shadow-lg">
                        <img
                            src={driverImage}
                            alt="Professional driver"
                            className="w-full h-full object-cover"
                        />
                    </div>
                </div>
            </div>
        </div>
    )
}
