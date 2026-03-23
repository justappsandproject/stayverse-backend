import { ILocation, RideType, ServiceStatus } from "."

export interface Ride {
    _id: string
    agentId: string
    rideName: string
    rideDescription: string
    address: string
    placeId?: string
    location?: ILocation
    rideType: RideType
    features: string[]
    pricePerDay?: number
    pricePerHour?: number
    security?: string
    airportPickup?: string
    cautionFee?: number
    rules: string
    maxPassengers: number
    rideImages: string[]
    plateNumber: string
    registrationNumber: string
    color: string
    vehicleVerificationNumber: string
    averageRating: number
    serviceType: string
    status: ServiceStatus
    bookedStatus: string
    createdAt: string
    updatedAt: string
    agent?: {
        _id: string
        userId: string
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