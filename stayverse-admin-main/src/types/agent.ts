import { ServiceType } from "."


export interface Agent {
    _id: string
    // balance: number
    serviceType: `${ServiceType}`
    userId: string
    user: {
        // _id: string
        firstname: string
        lastname: string
        email: string
        phoneNumber: string
        kycStatus: string
        isEmailVerified: boolean
        // role: string
        socketId: string | null
        lastSeenAt: string | null
        notificationsEnabled: boolean
        profilePicture?: string
        createdAt?: string
        updatedAt?: string
        // __v: number
    }
    totalBookings: number
    completedBookings: number
    totalEarnings: number
    createdAt: string
    updatedAt: string
}



// {
//     "_id": "68e4f3105ec3282b15414e13",
//     "serviceType": "apartment",
//     "userId": "68e4f3105ec3282b15414e11",
//     "createdAt": "2025-10-07T11:01:36.478Z",
//     "updatedAt": "2025-10-07T11:01:36.478Z",
//     "user": {
//         "firstname": "Agalaba",
//         "lastname": "Ifeanyi",
//         "email": "ifeanyiagalaba6@gmail.com",
//         "phoneNumber": "+2349066269233",
//         "kycStatus": "pending",
//         "isEmailVerified": true,
//         "socketId": null,
//         "lastSeenAt": null,
//         "profilePicture": "https://storage.googleapis.com/zylag_bucket/stayVerse/agents/49793c23-b9d3-48fa-b9aa-4e05b347cad8-photo_1761310606021.jpg",
//         "notificationsEnabled": true
//     }
// }