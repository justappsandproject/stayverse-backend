export interface NotificationExtras {
  [key: string]: string; 
}

export interface UserNotification {
  token: string;              
  title: string;             
  body: string; 
  extras?: NotificationExtras; 
}
