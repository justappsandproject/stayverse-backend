import { ServiceStatus } from "."

export interface SampleChef {
    _id: string
    fullName: string
    profilePicture: string
    orders: number
    rating: number
    phoneNumber: string
    isActive: boolean
}

export interface Chef {
    _id: string
    agentId: string
    fullName: string
    address: string
    placeId: string
    location: {
        type: string
        coordinates: number[]
    }
    bio: string
    about: string
    culinarySpecialties: string[]
    pricingPerHour: number
    profilePicture: string
    status: ServiceStatus
    coverPhoto: string
    hasExperience: boolean
    hasCertifications: boolean
    createdAt: string
    updatedAt: string
    agent?: {
        _id: string
        userId: string
        createdAt: string
        updatedAt: string
        firstname: string
        lastname: string
        email: string
        phoneNumber: string
    }
    user?: {
        _id: string
        userId: string
        createdAt: string
        updatedAt: string
        firstname: string
        lastname: string
        email: string
        phoneNumber: string
    }
    experiences: Experience[]
    certifications: Certification[]
    features: any[]
    totalBookings: number
    completedBookings: number
    totalEarnings: number
    withdrawalCount: number
    averageRating: number
}

interface Experience {
    _id: string
    chefId: string
    title: string
    company: string
    description: string
    startDate: string
    endDate: string
    stillWorking: boolean
    placeId: string
    address: string
    stayVerseJob: boolean
    createdAt: string
    updatedAt: string
}

export interface Certification {
    _id: string
    chefId: string
    title: string
    organization: string
    issuedDate: string
    certificateUrl: string
    createdAt: string
    updatedAt: string
}