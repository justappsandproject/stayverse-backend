
// supabaseService.js
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';


const supabase = createClient(supabaseUrl, supabaseKey);


interface WaitlistEntry {
    email?: string;
}

interface ContactEntry {
    email?: string;
    message?: string;
}

class SupabaseService {
    static async addToWaitlist(email: string): Promise<WaitlistEntry> {
        if (!email) throw new Error('Email is required');
        const sanitizedEmail = email.trim();

        try {
            const {  error } = await supabase
                .from('waitlist')
                .insert([{ email: sanitizedEmail }]);

            if (error) {
                console.error('Error adding to waitlist:', error);
                throw new Error(`Failed to add to waitlist: ${error.message}`);
            }


            return { email }
        } catch (err) {
            console.error('Unexpected error in addToWaitlist:', err);
            throw err;
        }
    }

    static async sendContactMessage(email: string, message: string): Promise<ContactEntry> {
        if (!email || !message) throw new Error('Email and message is required');

        const sanitizedEmail = email.trim();

        try {
            const { error } = await supabase
                .from('contact')
                .insert([{ email: sanitizedEmail, message: message }]);

            if (error) {
                console.error('Error adding to waitlist:', error);
                throw new Error(`Failed to add to waitlist: ${error.message}`);
            }


            return { email, message }
        } catch (err) {
            console.error('Unexpected error in addToWaitlist:', err);
            throw err;
        }
    }
}



export default SupabaseService;