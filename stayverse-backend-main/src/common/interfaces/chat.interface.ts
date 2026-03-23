export interface ChatMessage {
  toUserId: string;
  fromUserId: string;
  message: string;
  messageId: string;
}

export interface TypingPayload {
  toUserId: string;
  fromUserId: string;
  isTyping: boolean;
}

export interface ReadReceiptPayload {
  messageId: string;
  fromUserId: string;
  toUserId: string;
  readAt: string;
}