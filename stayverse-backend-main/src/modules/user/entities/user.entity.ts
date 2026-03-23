import { User } from "../schemas/user.schema";


export interface UserProfile extends Pick<User, 'firstname' | 'lastname' | 'email' | 'phoneNumber' | 'isEmailVerified'  > {}