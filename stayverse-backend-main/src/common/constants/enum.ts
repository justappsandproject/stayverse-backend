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

export enum ProposalStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
}

export enum BookedStatus {
  BOOKED = 'booked',
  AVAILABLE = 'available',
}

export enum KycStatus {
  VERIFIED = 'verified',
  PENDING = 'pending',
  DECLINED = 'declined'
}

export const ChatEvents = {
  REGISTERED: 'registered',
  USER_ONLINE: 'userOnline',
  USER_OFFLINE: 'userOffline',
  RECEIVE_MESSAGE: 'receiveMessage',
  MESSAGE_DELIVERED: 'messageDelivered',
  TYPING: 'typing',
  MESSAGE_READ: 'messageRead',
};

export enum AttachmentType {
  IMAGE = 'image',
  VIDEO = 'video',
  AUDIO = 'audio',
  FILE = 'file',
  PROPOSAL = 'proposal',
}

export enum MessageStatus {
  SENT = 'sent',
  DELIVERED = 'delivered',
  SEEN = 'seen',
}

export enum BookingStatus {
  PENDING = 'pending',
  REJECTED = 'rejected',
  ACCEPTED = 'accepted',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}
export enum PaymentStatus {
  PENDING = 'pending',
  PAID = 'paid',
  FAILED = 'failed',
  REFUNDED = 'refunded'
}
export enum TransactionPaymentStatus {
  SUCCESSFUL = 'successful',
  PENDING = 'pending',
  PROCESSING = 'processing',
  FAILED = 'failed',
  REFUNDED = 'refunded',
  REVERSED = 'reversed'
}
export enum EscrowStatus {
  HOLD = 'hold',
  PARTIAL = 'partial',
  COMPLETED = 'completed',
}
export enum AdminEscrowStatus {
  HELD = 'held',
  RELEASED = 'released',
  AGENT_HOLD = 'agent_hold',
}


export enum PayoutType {
  WHOLE = 'whole',
  DAILY = 'daily',
}

export enum TransactionType {
  CREDIT = 'credit',
  DEBIT = 'debit'
}

// APARTMENT
export enum ApartmentStatus {
  ACTIVE = 'active',
  CLOSED = 'closed',
}
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
export enum EscrowType {
  APARTMENT = 'apartment',
  CHEF = 'chef',
  RIDE = 'ride',
  CAUTION_FEE = 'caution_fee'
}

export enum BooleanQuestion {
  YES = 'yes',
  NO = 'no'
}
export enum BiDirection {
  UP = 'up',
  DOWN = 'down'
}

export enum NotificationEvent {
  BOOKING_MADE_AGENT = 'booking.made.agent',
  BOOKING_STATUS_CHANGE_USER = 'booking.status.change.user',
  PROPOSAL_MADE_USER = 'proposal.made.user',
  PROPOSAL_STATUS_CHANGE_AGENT = 'proposal.status.change.agent',
  SERVICE_CREATED_ADMIN = 'service.created.admin',
  FUND_WALLET_USER = 'fund.wallet.user',
  TRANSFER_TO_AGENT = 'transfer.to.agent',
}

export const TIMEZONE = 'Africa/Lagos';

export const OTP_MINUTES = 2;
export const ONE_MINUTES = 1 * 60 * 1000;

export const APPLICATION_FEE_PERCENTAGE = 0.06;

export const CAUTION_FEE = 50000

export const ESCROW_RELEASE_DELAY_HOURS = 1;

export const RIDE_CANCELLATION_FEE_PERCENTAGE = 0.20;