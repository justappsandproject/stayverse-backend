export interface VerifyNinWithSelfieResponse {
    entity: {
        first_name: string,
        last_name: string,
        middle_name: string,
        gender: string, // M or F
        image: string,
        phone_number: string,
        date_of_birth: string,  // e.g. 1993-05-06
        nin: string,
        selfie_verification: {
            confidence_value: number,
            match: boolean
        }
    }
}