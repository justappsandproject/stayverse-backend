import { Injectable } from '@nestjs/common';
import { ApartmentService } from '../../apartment/services/apartment.service';
import { ChefService } from '../../chef/services/chef.service';
import { BookingService } from '../../booking/services/booking.service';
import { RidesService } from 'src/modules/rides/services/rides.service';
import { UserService } from 'src/modules/user/services/user.service';

@Injectable()
export class MetricService {
  constructor(
    private readonly apartmentService: ApartmentService,
    private readonly rideService: RidesService,
    private readonly chefService: ChefService,
    private readonly bookingService: BookingService,
    private readonly userService: UserService
  ) {}

  async getDashboardMetrics() {
    const [
      totalApartments,
      totalRides,
      totalChefs,
      totalBookings,
      totalEarnings
    ] = await Promise.all([
      this.apartmentService.countApartments(),
      this.rideService.countRides(),
      this.chefService.countChefs(),
      this.bookingService.getTotalBookings(),
      this.userService.getAdminEarnings(),
    ]);

    return {
      totalApartments,
      totalRides,
      totalChefs,
      totalBookings,
      totalEarnings
    };
  }
}
