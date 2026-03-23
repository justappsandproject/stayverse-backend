import { ILocation, ServiceStatus } from "."
import { User } from "./user"



// APARTMENT
export enum ApartmentType {
    STUDIO = 'studio',
    ONE_BEDROOM = 'one-bedroom',
    TWO_BEDROOM = 'two-bedroom',
}

export interface Apartment {
    _id: string
    agentId: string | User
    apartmentName: string
    details: string
    address: string
    placeId?: string
    location?: ILocation
    apartmentType: ApartmentType
    numberOfBedrooms: number
    amenities: string[]
    pricePerDay: number
    houseRules: string,
    maxGuests: number,
    checkIn: string,
    checkOut: string,
    apartmentImages: string[]
    bookedStatus: string
    status: ServiceStatus
    averageRating?: number
    agent?: {
        _id: string
        // userId: string
        balance: number
        serviceType: string
        createdAt: string
        updatedAt: string
        user: {
            _id: string
            firstname: string
            lastname: string
            email: string
            phoneNumber: string
            profilePicture?: string
        }
    }
}
