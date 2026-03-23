import { Agent } from "./agent"
import { Apartment } from "./apartment"
import { Chef } from "./chef"
import { Ride } from "./ride"


export enum BookingStatus {
    PENDING = 'pending',
    REJECTED = 'rejected',
    ACCEPTED = 'accepted',
    COMPLETED = 'completed'
}

export interface BookingTableData {
    serviceType: string
    serviceName: string
    customerName: string
    agentName: string
    orderId: string
    status: BookingStatus
    fee: number
    startDate: string
    endDate: string
}

export interface Booking {
    _id: string
    serviceType: 'apartment' | 'ride' | 'chef'
    userId: string
    agentId: string
    apartmentId: string
    rideId: string
    chefId: string
    user: Omit<Agent['user'], 'socketId'>
    agent: Omit<Agent, 'totalBookings' | 'completedBookings' | 'totalEarnings'>
    apartment: Apartment | null
    ride: Ride | null
    chef: Chef | null
    startDate: string
    endDate: string
    totalPrice: number
    status: BookingStatus
    createdAt: string
    updatedAt: string
    __v: number
}
