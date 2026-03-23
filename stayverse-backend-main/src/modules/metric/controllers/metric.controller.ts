import { Controller, Get, UseGuards } from '@nestjs/common';
import { MetricService } from '../services/metric.service';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { Roles } from 'src/common/constants/enum';
import { ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from 'src/common/guards/auth.guard';

@Controller('metric')
@UseGuards(AuthGuard,RolesGuard)
export class MetricController {
  constructor(private readonly metricService: MetricService) {}

  @Get('dashboard')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  async getDashboardMetrics() {
    return this.metricService.getDashboardMetrics();
  }
}
