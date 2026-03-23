import { BadGatewayException, HttpException, Injectable, Logger, UnprocessableEntityException } from "@nestjs/common";
import { Client } from '@googlemaps/google-maps-services-js';
import { ConfigService } from "@nestjs/config";

@Injectable()
export class GoogleMapsService {
    private readonly logger = new Logger(GoogleMapsService.name);
    private client = new Client({});

    constructor(
        private readonly configService: ConfigService,
    ) { }
    async reverseGeocode(placeId: string) {
        try {
            if (!placeId) {
                throw new UnprocessableEntityException('Place ID is required!');
            }

            const response = await this.client.reverseGeocode({
                params: {
                    place_id: placeId,
                    key: this.configService.get<string>('googleMaps.apiKey'),
                },
            });

            const result = response.data.results[0];

            return {
                coordinates: result.geometry.location,
                formattedAddress: result.formatted_address,
                placeId: result.place_id,
            };
        } catch (error) {
            if (error instanceof HttpException) {
                throw error;
            } else {
                this.logger.error(`Geocoding API error for placeId=${placeId}: ${error.message}`, error.stack);
                throw new BadGatewayException('Error calling geocoding API');
            }
        }
    }
}
