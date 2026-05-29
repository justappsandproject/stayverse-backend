import { Injectable } from '@nestjs/common';
import { ApartmentService } from '../../apartment/services/apartment.service';
import { ChefService } from '../../chef/services/chef.service';
import { BookingService } from '../../booking/services/booking.service';
import { RidesService } from 'src/modules/rides/services/rides.service';
import { UserService } from 'src/modules/user/services/user.service';

@Injectable()
export class MetricService {
  private dashboardCache: { data: Record<string, number>; expiresAt: number } | null =
    null;
  private readonly cacheTtlMs = 60_000;

  constructor(
    private readonly apartmentService: ApartmentService,
    private readonly rideService: RidesService,
    private readonly chefService: ChefService,
    private readonly bookingService: BookingService,
    private readonly userService: UserService
  ) {}

  async getDashboardMetrics() {
    if (this.dashboardCache && Date.now() < this.dashboardCache.expiresAt) {
      return this.dashboardCache.data;
    }

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

    const data = {
      totalApartments,
      totalRides,
      totalChefs,
      totalBookings,
      totalEarnings
    };

    this.dashboardCache = {
      data,
      expiresAt: Date.now() + this.cacheTtlMs,
    };

    return data;
  }
}
