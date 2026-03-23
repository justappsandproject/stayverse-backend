

export interface User {
    _id: string
    firstname: string
    lastname: string
    email: string
    phoneNumber: string
    kycStatus: string
    isEmailVerified: boolean
    role: string
    lastSeenAt: string | null
    notificationsEnabled: boolean
    createdAt: string
    profilePicture?: string
}


// {
//     "_id": "690c6113036fa0e1b01af796",
//     "firstname": "precious",
//     "lastname": "Ifeanyi",
//     "email": "precious@venbrinodevs.com",
//     "phoneNumber": "+2349066269235",
//     "kycStatus": "pending",
//     "isEmailVerified": true,
//     "role": "user",
//     "socketId": null,
//     "lastSeenAt": null,
//     "notificationsEnabled": true,
//     "createdAt": "2025-11-06T08:49:23.300Z",
//     "profilePicture": "https://storage.googleapis.com/zylag_bucket/stayVerse/users/d3d7a98c-dd12-4ed9-bc64-c6ef7d1601ef-photo_1762419078347.jpg"
// }