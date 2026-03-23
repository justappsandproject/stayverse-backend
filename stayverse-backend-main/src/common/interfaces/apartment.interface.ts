export interface PublicApartment {
    id:unknown,
    apartmentName: string;
    price: number;
    address: string;
    location: {
        type: 'Point';
        coordinates: [number, number]; 
      };
    firstImage: string | null;
    amenities:string[];
}
