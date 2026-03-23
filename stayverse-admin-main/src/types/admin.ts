import { DocTimestamp } from ".";


export enum AdminRoles {
    admin = 'admin',
    superadmin = 'superadmin'
}

export enum AdminStatuses {
    pending = 'pending',
    active = 'active',
    declined = 'declined',
    suspended = 'suspended'
}

export interface Admin extends DocTimestamp {
    _id: string
    firstname: string
    lastname: string
    email: string
    phoneNumber: string
    isEmailVerified: boolean
    role: string
    createdAt: string
    updatedAt: string
    __v: number

    // status: `${AdminStatuses}`;
}