

export interface DocTimestamp {
    _id: string;

    createdAt: string // iso date string

    updatedAt: string // iso date string
}

export interface PaginationProps {
    pageIndex: number;
    pageSize: number;
    totalPages?: number; // Optional, useful for manual pagination
    isManual?: boolean; // Controls whether data is fetched externally
    onChange?: (pagination: { pageIndex: number; pageSize: number }) => void;
}

export interface ILocation {
    type: 'Point',
    coordinates: [number, number]
}

export enum ServiceType {
    CHEF = 'chef',
    APARTMENT = 'apartment',
    RIDE = 'ride',
}
export enum ServiceStatus {
    APPROVED = 'approved',
    PENDING = 'pending',
    CANCELLED = 'cancelled',
}
export enum AdminEscrowStatus {
    HELD = 'held',
    RELEASED = 'released',
    AGENT_HOLD = 'agent_hold',
}
export enum RideType {
    CAR = 'car',
    BIKE = 'bike',
    TRUCK = 'truck',
    BUS = 'bus'
}

// export enum BookingStatus {
//     ACTIVE = 'active',
//     COMPLETED = 'completed',
// }

export enum FavoriteStatus {
    ACTIVE = 'active',
    INACTIVE = 'inactive',
}

export enum ChatStatus {
    VIEWED = 'viewed',
    NOT_VIEWED = 'notViewed',
}
export enum Roles {
    ADMIN = 'admin',
    USER = 'user',
    AGENT = 'agent'
}
export enum EmailType {
    WELCOME = 'welcome',
    FORGOT_PASSWORD = 'forgot_password',
    RESET_PASSWORD = 'reset_password',
    EMAIL_VERIFICATION = 'email_verification'
}

export enum BooleanQuestion {
    YES = 'yes',
    NO = 'no'
}
export const TIMEZONE = 'Africa/Lagos';

export const OTP_MINUTES = 2;