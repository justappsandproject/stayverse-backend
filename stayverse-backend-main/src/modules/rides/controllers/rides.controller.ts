import {
    Controller,
    Get,
    Post,
    Put,
    Param,
    Body,
    UseGuards,
    Request,
    UseInterceptors,
    UploadedFiles,
    Logger,
    Patch,
    BadRequestException,
    Query,
    InternalServerErrorException,
    Delete
} from '@nestjs/common';
import {
    ApiTags,
    ApiOperation,
    ApiParam,
    ApiBearerAuth,
    ApiConsumes,
    ApiResponse,
    ApiQuery,
} from '@nestjs/swagger';
import { FileFieldsInterceptor } from '@nestjs/platform-express';

import { RidesService } from '../services/rides.service';
import {
    CreateRideDto,
    CreateRideRatingDto,
    SearchRidesDto,
    UpdateRideDto,
    UpdateRideStatusDto,
} from '../dto/rides.dto';

import { AuthGuard, Public } from '../../../common/guards/auth.guard';
import { RolesGuard, Role, ServiceTypeGuard } from '../../../common/guards/roles.guard';
import { Roles, ServiceStatus, ServiceType } from '../../../common/constants/enum';
import { FileUploadPipe } from 'src/common/pipes/file-upload.pipe';
import { AuthenticatedRequest } from 'src/common/types/app.interface';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { ServiceQueryDto } from 'src/common/dtos/service-query.dto';
import { DOUploadService } from 'src/common/providers/digiital-ocean.service';

@ApiTags('Rides')
@Controller('ride')
@ApiBearerAuth()
@UseGuards(AuthGuard, RolesGuard)
export class RidesController {
    private readonly logger = new Logger(RidesController.name);

    constructor(
        private readonly ridesService: RidesService,
        private readonly uploadService: DOUploadService,
    ) { }

    @Post()
    @ServiceTypeGuard(ServiceType.RIDE)
    @UseInterceptors(FileFieldsInterceptor([{ name: 'rideImages', maxCount: 12 }]))
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Create a new ride listing',
        description: 'Allows agent to create a new ride listing.',
    })
    @ApiConsumes('multipart/form-data')
    async create(
        @Body() createRideDto: CreateRideDto,
        @Request() req,
        @UploadedFiles(new FileUploadPipe()) files: Record<string, Express.Multer.File[]>,
    ) {
        const agentId = req.user.agent;
        const rideImages = files?.rideImages || []
        if (rideImages.length < 2 || rideImages.length > 12) {
            throw new BadRequestException(
                'Ride Images must be between 2 and 12 files.',
            );
        }

        let uploadedUrls: string[] = [];
        try {
            uploadedUrls = await this.uploadService.uploadFiles(files.rideImages, 'rides');
        } catch (error) {
            throw new InternalServerErrorException('File upload failed');
        }

        return await this.ridesService.create(createRideDto, agentId, uploadedUrls);
    }
    @Public()
    @Get()
    @ApiOperation({
        summary: 'Get all rides',
        description: 'Retrieves a list of all rides.',
    })
    async findAll(@Query() query: PaginationQueryDto) {
        return this.ridesService.findAll(query);
    }

    @Get('admin/all')
    @Role(Roles.ADMIN)
    @ApiOperation({
        summary: 'Get all rides (Admin only)',
        description: 'Allows an admin to retrieve a list of all rides with status filtering.',
    })
    async findAllAdmin(@Query() query: ServiceQueryDto) {
        return this.ridesService.findAllAdmin(query);
    }
    @Public()
    @Get('newest')
    @ApiOperation({
        summary: 'Get recently posted rides',
        description: 'Returns the rides posted within the last 24 hours .',
    })
    async findNewestRide(@Query() query: PaginationQueryDto) {
        return this.ridesService.findNewestRides(query);
    }
    @Public()
    @Get('recommended')
    @ApiOperation({
        summary: 'Get nearby rides',
        description: 'Returns rides within a 10 km radius of the specified coordinates.',
    })
    async getNearbyRides(
        @Query('lng') lng: string,
        @Query('lat') lat: string,
        @Query() query: PaginationQueryDto
    ) {
        if (!lng || !lat) {
            throw new BadRequestException('Longitude and latitude are required.');
        }

        const longitude = parseFloat(lng);
        const latitude = parseFloat(lat);

        if (isNaN(longitude) || isNaN(latitude)) {
            throw new BadRequestException('Invalid coordinates.');
        }
        const rides = await this.ridesService.getNearbyRides(longitude, latitude, query);
        return rides;
    }

    @Get('admin/count')
    @ApiOperation({
        summary: 'Get the total number of rides',
        description: 'Returns the total count of rides in the database.',
    })
    async countRides() {
        return this.ridesService.countRides();
    }

    @Public()
    @Get('search')
    @ApiOperation({ summary: 'Search for available rides with filters' })
    async searchRides(@Query() query: SearchRidesDto) {
        return this.ridesService.searchRidesWithFilters(query);
    }

    @Get('owner')
    @Role(Roles.AGENT, Roles.ADMIN)
    @ServiceTypeGuard(ServiceType.RIDE)
    @ApiOperation({
        summary: 'Get all rides posted by an agent (admin must provide agentId)',
        description: 'Admins can specify an agentId; others will use their own ID.',
    })

    @ApiQuery({
        name: 'agentId',
        required: false,
        type: String,
        description: 'Agent ID (required for admins)',
        example: '6836a8ad6addf634650112a6',
    })

    @ApiQuery({
        name: 'status',
        required: true,
        type: String,
        description: '[approved, cancelled, pending]',
        example: 'approved',
    })
    async findAllMyRides(
        @Request() req: AuthenticatedRequest,
        @Query() query: PaginationQueryDto & { agentId?: string; status: ServiceStatus }
    ) {
        const user = req.user;

        let ownerId: string;

        if (user.role === Roles.ADMIN) {
            if (!query.agentId) {
                throw new BadRequestException('agentId is required for admin users');
            }
            ownerId = query.agentId;
        } else {
            ownerId = user.agent;
        }

        return this.ridesService.findAllByOwner(ownerId, query, query.status);
    }

    @Get('agents/:agentId')
    @ApiOperation({
        summary: 'users get all rides posted by a specific agent',
        description: 'Retrieves a list of all rides posted by a specific agent.',
    })
    @ApiParam({ name: 'agentId', required: true, description: 'ID of the agent whose rides to retrieve.' })
    async findAllByAgent(
        @Param('agentId') agentId: string,
        @Query() query: PaginationQueryDto
    ) {
        return this.ridesService.findAllByAgent(agentId, query);
    }

    @Patch(':id/status')
    @Role(Roles.ADMIN)
    @ApiOperation({
        summary: 'Change the status of an ride',
        description: 'Allows an admin to change the status of an ride listing.',
    })
    async changeStatus(
        @Param('id') id: string,
        @Body() dto: UpdateRideStatusDto,
    ) {
        return this.ridesService.updateRideStatus(id, dto.status);
    }

    @Delete(':id')
    @Role(Roles.ADMIN, Roles.AGENT)
    @ApiOperation({
        summary: 'Delete a ride',
        description: 'Allows an admin or agent to delete a ride. Agent can only delete their own ride.',
    })
    async delete(@Param('id') id: string, @Request() req) {
        return this.ridesService.delete(id, req.user.agent, req.user.role);
    }

    @Post(':id/rating')
    @Role(Roles.USER)
    @ApiOperation({
        summary: 'Add or update ride rating',
        description: 'Allows a logged-in user to rate a ride (1–5) and add a review.',
    })
    async addOrUpdateRideRating(
        @Param('id') rideId: string,
        @Body() dto: CreateRideRatingDto,
        @Request() req,
    ) {
        const userId = req.user.id;
        return this.ridesService.rateRides(rideId, userId, dto);
    }

    @Public()
    @Get(':id/ratings')
    @ApiOperation({
        summary: 'Get all ratings for a ride',
        description: 'Fetches paginated ratings and reviews for a specific ride.',
    })
    @ApiQuery({ name: 'page', required: false, example: 1 })
    @ApiQuery({ name: 'limit', required: false, example: 10 })
    async getRideRatings(@Param('id') rideId: string, @Query() query: PaginationQueryDto) {
        return this.ridesService.getRideRatings(rideId, query);
    }

    @Public()
    @Get(':id')
    @ApiOperation({
        summary: 'Get a single ride by ID',
        description: 'Retrieves details of a specific ride.',
    })
    @ApiParam({ name: 'id', required: true, description: 'ID of the ride to retrieve.' })
    async findOne(@Param('id') id: string) {
        return this.ridesService.findOne(id);
    }

    @Put(':id')
    @ServiceTypeGuard(ServiceType.RIDE)
    @Role(Roles.AGENT)
    @UseInterceptors(FileFieldsInterceptor([{ name: 'rideImages', maxCount: 12 }]))
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Update a ride listing',
        description: 'Allows an admin or agent to update an existing ride listing. Images are optional.',
    })
    @ApiConsumes('multipart/form-data')
    @ApiParam({ name: 'id', required: true, description: 'ID of the ride to update.' })
    async update(
        @Param('id') id: string,
        @Body() updateRideDto: UpdateRideDto,
        @Request() req,
        @UploadedFiles() files: Record<string, Express.Multer.File[]>,
    ) {
        const agentId = req.user.agent;
        const rideImages = files?.rideImages || [];
        if (rideImages.length > 0 && (rideImages.length < 2 || rideImages.length > 12)) {
            throw new BadRequestException(
                'Ride Images must be between 2 and 12 files if provided.'
            );
        }
        let uploadedUrls: string[] = [];
        if (rideImages.length > 0) {
            try {
                uploadedUrls = await this.uploadService.uploadFiles(rideImages, 'rides');
            } catch (error) {
                throw new InternalServerErrorException('File upload failed');
            }
        }
        return this.ridesService.update(id, updateRideDto, uploadedUrls, agentId);
    }


}
