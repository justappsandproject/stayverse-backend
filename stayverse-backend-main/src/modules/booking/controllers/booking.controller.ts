import { Controller, Post, Param, Body, Req, Patch, Get, UseGuards, BadRequestException, Query } from '@nestjs/common';
import { BookingService } from '../services/booking.service';
import { BookingStatus, Roles, ServiceType } from 'src/common/constants/enum';
import { BookingStatusDto, CreateBookingDto, SearchBookingDto, UpdateBookingDto } from '../dto/booking.dto';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { AuthGuard } from 'src/common/guards/auth.guard';
import { ApiBearerAuth, ApiOperation, ApiResponse, ApiBody, ApiQuery } from '@nestjs/swagger';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { GetAdminBookingsDto } from '../dto/get-admin-bookings.dto';

@UseGuards(AuthGuard, RolesGuard)
@Controller('booking')
export class BookingController {
    constructor(private readonly bookingService: BookingService) { }

    @Post('/')
    @UseGuards(AuthGuard)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Create a new booking request' })
    @ApiResponse({ status: 201, description: 'Booking request created' })
    async create(
        @Body() createBookingDto: CreateBookingDto,
        @Req() req
    ) {
        const userId = req.user.sub;
        return this.bookingService.createBooking(createBookingDto, userId);
    }

    @Patch('/:bookingId')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Update a pending booking request' })
    @ApiResponse({ status: 200, description: 'Booking updated successfully' })
    async update(
        @Param('bookingId') bookingId: string,
        @Body() updateBookingDto: UpdateBookingDto,
        @Req() req
    ) {
        const userId = req.user.sub;
        return this.bookingService.updateBooking(bookingId, updateBookingDto, userId);
    }
    @Get('unavailable-dates')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get unavailable booking dates for a specific service (apartment or ride)' })
    @ApiQuery({ name: 'serviceType', enum: ServiceType })
    @ApiQuery({ name: 'id', type: String, description: 'ID of the apartment or ride' })
    @ApiResponse({ status: 200, description: 'List of unavailable dates', type: [Date] })
    async getUnavailableDates(
        @Query('serviceType') serviceType: ServiceType,
        @Query('id') id: string
    ): Promise<Date[]> {
        if (!serviceType || !id) {
            throw new BadRequestException('Missing serviceType or id query parameter');
        }

        return this.bookingService.getUnavailableDates(serviceType, id);
    }

    @Patch(':id/status')
    @Role(Roles.ADMIN, Roles.AGENT)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Update booking status' })
    @ApiBody({
        description: 'Booking status payload',
        required: true,
        schema: {
            type: 'object',
            properties: {
                status: {
                    type: 'string',
                    enum: Object.values(BookingStatus),
                    example: 'accepted',
                    description: 'Booking status must be either "accepted" or "cancelled"',
                },
            },
            required: ['status'],
        },
    })
    async updateBookingStatus(
        @Param('id') id: string,
        @Body() status: { status: BookingStatus },
        @Req() req
    ) {
        const { status: bookingStatus } = status;
        const userId = req.user?.agent || req.user?.sub;

        if (!Object.values(BookingStatus).includes(bookingStatus)) {
            throw new BadRequestException('Invalid booking status');
        }

        return this.bookingService.agentBookingUpdate(id, userId, bookingStatus, `Booking ${bookingStatus}`);
    }

    @Get('/user')
    @ApiOperation({ summary: 'Booking of a particular user' })
    @ApiBearerAuth()
    async getUserBookings(
        @Req() req,
        @Query() query: BookingStatusDto
    ) {
        const userId = req.user.sub;
        return this.bookingService.getUserBookings(userId, query);
    }

    @Get('/agent')
    @Role(Roles.AGENT)
    @ApiOperation({ summary: 'Get all bookings for the authenticated agent' })
    @ApiBearerAuth()
    @ApiResponse({ status: 200, description: 'List of bookings for the agent' })
    getAuthenticatedAgentBookings(
        @Req() req,
        @Query() query: BookingStatusDto
    ) {
        const agentId = req.user.agent;
        return this.bookingService.getAgentBookings(agentId, query);
    }
    @Get('agent/:agentId')
    @Role(Roles.ADMIN)
    @ApiOperation({ summary: 'Get all bookings for a specific agent' })
    @ApiResponse({ status: 200, description: 'List of bookings for the agent' })
    @ApiBearerAuth()
    getAgentBookingsById(@Param('agentId') agentId: string, @Query() query: BookingStatusDto) {
        return this.bookingService.getAgentBookings(agentId, query);
    }
    @Get('admin')
    @Role(Roles.ADMIN)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Admin: get all bookings with filters & pagination' })
    @ApiResponse({ status: 200, description: 'Filtered list of all bookings' })
    async getAdminBookings(@Query() query: GetAdminBookingsDto) {
        return this.bookingService.getAdminBookings(query);
    }

    @Get('search')
    @Role(Roles.ADMIN)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Search bookings' })
    async searchBookings(@Query() query: SearchBookingDto) {
        return await this.bookingService.searchBookings(query.keyword, query);
    }

    @Get(':bookingId')
    @Role(Roles.ADMIN)
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Admin Get a particular booking' })
    async getABooking(
        @Param('bookingId') bookingId: string,
        @Query() query: PaginationQueryDto
    ) {
        return await this.bookingService.getBookingById(bookingId, query);
    }

    @Post(':id/cancel')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Cancel a booking (User Only)' })
    @ApiResponse({ status: 200, description: 'Booking cancelled successfully' })
    async cancelBooking(
        @Param('id') id: string,
        @Req() req
    ) {
        const userId = req.user.sub;
        return this.bookingService.cancelBooking(id, userId);
    }
}
