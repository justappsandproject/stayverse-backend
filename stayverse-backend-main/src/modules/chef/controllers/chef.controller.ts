import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Param,
  Body,
  UseGuards,
  Request,
  Query,
  BadRequestException,
  UseInterceptors,
  UploadedFiles,
  Logger,
  Delete,
  Req,
  UploadedFile
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiConsumes,
  ApiParam,
  ApiQuery,
  ApiResponse,
  ApiBody
} from '@nestjs/swagger';
import { FileFieldsInterceptor, FileInterceptor } from '@nestjs/platform-express';

import { ChefService } from '../services/chef.service';
import {
  CreateChefDto,
  UpdateChefDto,
  SearchChefDto,
  UpdateChefStatusDto,
  ObjectIdParamDto,
  CreateChefRatingDto
} from '../dto/chef.dto';
import { CreateExperienceDto } from '../dto/experience.dto';
import { CreateCertificationDtoo } from '../dto/certification.dto';
import { AuthGuard, Public } from '../../../common/guards/auth.guard';
import { RolesGuard, Role } from '../../../common/guards/roles.guard';
import { ProposalStatus, Roles } from '../../../common/constants/enum';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { FileUploadPipe } from 'src/common/pipes/file-upload.pipe';
import { CreateFeatureDto } from '../dto/feature.dto';
import { GetAllChefsDto } from '../dto/get-all-chefs.dto';
import { CreateChefProposalDto, GetProposalsQueryDto, RespondChefProposalDto } from '../dto/chef-proposal.dto';
import { AuthenticatedRequest } from 'src/common/types/app.interface';
import { DOUploadService } from 'src/common/providers/digiital-ocean.service';

@ApiTags('Chefs')
@Controller('chef')
@UseGuards(AuthGuard, RolesGuard)
@ApiBearerAuth()
export class ChefController {
  private readonly logger = new Logger(ChefController.name);

  constructor(
    private readonly chefService: ChefService,
    private readonly uploadService: DOUploadService
  ) { }

  @Post()
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN, Roles.AGENT)
  @UseInterceptors(
    FileFieldsInterceptor([
      { name: 'profilePicture', maxCount: 1 },
      { name: 'coverPhoto', maxCount: 1 }
    ])
  )
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Create a new chef' })
  async create(
    @Body() createChefDto: CreateChefDto,
    @Request() req,
    @UploadedFiles(new FileUploadPipe()) files: {
      profilePicture?: Express.Multer.File[];
      coverPhoto?: Express.Multer.File[];
    }
  ) {
    const agentId = req.user.agent;
    const uploadTasks = [];

    if (files.profilePicture?.length === 1) {
      uploadTasks.push(
        this.uploadService.uploadFile(
          files.profilePicture[0],
          'chefs'
        )
      );
    } else {
      throw new BadRequestException('Profile picture is required');
    }

    if (!files.coverPhoto || files.coverPhoto.length !== 1) {
      throw new BadRequestException('Cover photo is required and must be exactly one file.');
    }
    uploadTasks.push(
      this.uploadService.uploadFile(files.coverPhoto[0], 'chefs')
    );
    const [profilePicture, coverPhoto] =
      await Promise.all(uploadTasks);

    return this.chefService.create(
      { ...createChefDto, profilePicture, coverPhoto },
      agentId
    );
  }

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all chefs' })
  async getAll(@Query() query: PaginationQueryDto) {
    return this.chefService.getAll(query);
  }
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN)
  @Get('all')
  @ApiOperation({ summary: 'Admin: Get all chefs' })
  async findAllChefs(@Query() query: GetAllChefsDto) {
    return this.chefService.findAllChefs(query);
  }
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.AGENT)
  @Get('/has-details')
  @ApiOperation({ summary: 'Check if chef has experience and certifications' })
  async checkExperienceAndCertifications(
    @Req() req
  ) {
    return this.chefService.hasExpCertProfile(req.user.agent);
  }

  @Role(Roles.ADMIN)
  @Patch(':id/status')
  @ApiOperation({ summary: 'Admin: update chef approval status' })
  @ApiParam({ name: 'id', description: 'Chef ID' })
  async changeStatus(
    @Param('id') id: string,
    @Body() dto: UpdateChefStatusDto,
  ) {
    return this.chefService.updateChefStatus(id, dto.status);
  }

  @Post(':id/rating')
  @ApiBearerAuth()
  @Role(Roles.USER)
  @ApiOperation({
    summary: 'Add or update chef rating',
    description: 'Allows a logged-in user to rate a chef (1–5) and add a review.',
  })
  async addOrUpdateChefRating(
    @Param('id') chefId: string,
    @Body() dto: CreateChefRatingDto,
    @Request() req,
  ) {
    const userId = req.user.id;
    return this.chefService.rateChef(userId, chefId, dto);
  }

  @Public()
  @Get(':id/ratings')
  @ApiOperation({
    summary: 'Get all ratings for a chef',
    description: 'Fetches paginated ratings and reviews for a specific chef.',
  })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'limit', required: false, example: 10 })
  async getChefRatings(@Param('id') chefId: string, @Query() query: PaginationQueryDto) {
    return this.chefService.getChefRatings(chefId, query);
  }


  @Public()
  @Get('newest')
  @ApiOperation({ summary: 'Get chefs added in the last week' })
  async findNewest(@Query() query: PaginationQueryDto) {
    return this.chefService.findNewestChef(query);
  }

  @Public()
  @Get('recommended')
  @ApiOperation({ summary: 'Get nearby chefs' })
  @ApiQuery({ name: 'lng', required: true, type: Number })
  @ApiQuery({ name: 'lat', required: true, type: Number })
  async getNearby(
    @Query('lng') lng: string,
    @Query('lat') lat: string,
    @Query() query: PaginationQueryDto
  ) {
    const longitude = parseFloat(lng);
    const latitude = parseFloat(lat);
    if (isNaN(longitude) || isNaN(latitude)) {
      throw new BadRequestException('Invalid coordinates');
    }
    return this.chefService.getNearbyChefs(
      longitude,
      latitude,
      query
    );
  }

  @Public()
  @Get('search')
  @ApiOperation({ summary: 'Search chefs with filters' })
  async search(@Query() query: SearchChefDto) {
    return this.chefService.searchChefWithFilters(query);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get a single chef by ID' })
  @ApiParam({ name: 'id', description: 'Chef ID' })
  async findOne(@Param('id') id: string) {
    return this.chefService.findOne(id);
  }

  @Get('profile/:chefId')
  @ApiOperation({ summary: 'Get full chef profile' })
  async getChefProfile(
    @Param('chefId') chefId: string
  ) {
    return this.chefService.getChefProfile(chefId);
  }
  @Put('')
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.AGENT)
  @UseInterceptors(
    FileFieldsInterceptor([
      { name: 'profilePicture', maxCount: 1 },
      { name: 'coverPhoto', maxCount: 1 },
    ])
  )
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Update chef information' })
  async update(
    @Body() dto: UpdateChefDto,
    @Req() req,
    @UploadedFiles() files?: {
      profilePicture?: Express.Multer.File[];
      coverPhoto?: Express.Multer.File[];
    }
  ) {
    const uploadTasks = [];

    if (files.profilePicture?.length === 1) {
      uploadTasks.push(
        this.uploadService.uploadFile(files.profilePicture[0], 'chefs')
      );
    } else {
      uploadTasks.push(Promise.resolve(null));
    }

    if (files.coverPhoto?.length === 1) {
      uploadTasks.push(
        this.uploadService.uploadFile(files.coverPhoto[0], 'chefs')
      );
    } else {
      uploadTasks.push(Promise.resolve(null));
    }

    const [profilePicture, coverPhoto] = await Promise.all(uploadTasks);

    const updatedData: Partial<UpdateChefDto> = {
      ...dto,
      ...(profilePicture && { profilePicture }),
      ...(coverPhoto && { coverPhoto }),
    };

    return this.chefService.update(req.user.agent, updatedData);
  }
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN, Roles.AGENT)
  @Post('/experience')
  @ApiOperation({ summary: 'Add experience to a chef' })
  async addExperience(
    @Req() req,
    @Body() dto: CreateExperienceDto
  ) {
    return this.chefService.addExperience(req.user.agent, dto);
  }

  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN, Roles.AGENT)
  @Delete('experience/:experienceId')
  @ApiOperation({ summary: 'Delete a chef experience' })
  async deleteExperience(
    @Req() req,
    @Param('experienceId') experienceId: string
  ) {
    return this.chefService.deleteExperience(req.user.agent, experienceId);
  }

  @Post('/feature')
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.AGENT)
  @UseInterceptors(FileInterceptor('featuredImage'))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Add single chef feature image with description' })
  @ApiBody({ type: CreateFeatureDto })
  async addFeature(
    @Req() req,
    @UploadedFile() file: Express.Multer.File,
    @Body() body: CreateFeatureDto,
  ) {
    if (!file) {
      throw new BadRequestException('Image must be uploaded.');
    }

    const imageUrl = await this.uploadService.uploadFile(file, 'chefs');

    const featuredImageObject = {
      imageUrl,
      description: body.imageDescription,
    };

    return this.chefService.addFeature(req.user.agent, featuredImageObject);
  }
  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.AGENT)
  @Delete('feature/:featureId')
  @ApiOperation({ summary: 'Delete a chef feature' })
  async deleteFeature(
    @Req() req,
    @Param('featureId') featureId: string
  ) {
    return this.chefService.deleteFeature(req.user.agent, featureId);
  }


  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN, Roles.AGENT)
  @Post('certification')
  @ApiOperation({ summary: 'Add certification to a chef' })
  async addCertification(
    @Req() req,
    @Body() dto: CreateCertificationDtoo
  ) {
    return this.chefService.addCertification(req.user.agent, dto);
  }

  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN, Roles.AGENT)
  @Delete('certification/:certificationId')
  @ApiOperation({ summary: 'Delete a chef certification' })
  async deleteCertification(
    @Req() req,
    @Param('certificationId') certificationId: string
  ) {
    return this.chefService.deleteCertification(req.user.agent, certificationId);
  }

  @Post(':userId/proposal')
  @Role(Roles.AGENT)
  @ApiOperation({
    summary: 'Send a proposal to a user',
    description: 'Allows a chef to send a proposal with price and description to a user.'
  })
  async createProposal(
    @Param('userId') userId: string,
    @Body() dto: CreateChefProposalDto,
    @Req() req,
  ) {
    const chefId = req.user.agent;
    return this.chefService.createProposal(chefId, userId, dto);
  }

  @Patch('proposal/:proposalId/status')
  @Role(Roles.USER)
  @ApiOperation({
    summary: 'Respond to a proposal (accept or reject)',
    description: 'Allows a user to update a proposal’s status after receiving it from a chef.'
  })
  async respondToProposal(
    @Param('proposalId') proposalId: string,
    @Body() dto: RespondChefProposalDto,
    @Req() req: AuthenticatedRequest,
  ) {
    const userId = req.user.sub;
    return this.chefService.respondToProposal(proposalId, userId, dto);
  }

  @Get('proposal/user')
  @Role(Roles.USER)
  @ApiOperation({
    summary: 'Get all proposals sent to a user',
    description: 'Fetches paginated proposals for a logged-in user, optionally filtered by status.',
  })
  async getUserProposals(
    @Req() req,
    @Query() query: GetProposalsQueryDto, // includes page, limit, status
  ) {
    const userId = req.user.sub;
    return this.chefService.getUserProposals(userId, query);
  }


  @Get('proposal/chef')
  @Role(Roles.AGENT)
  @ApiOperation({
    summary: 'Get all proposals sent by a chef',
    description: 'Fetches paginated proposals for a logged-in chef, optionally filtered by status.'
  })
  @ApiQuery({ name: 'status', required: false, enum: ProposalStatus })
  @ApiQuery({ name: 'page', required: false, example: 1 })
  @ApiQuery({ name: 'limit', required: false, example: 10 })
  async getChefProposals(
    @Req() req,
    @Query() query: PaginationQueryDto,
  ) {
    const chefId = req.user.agent;
    return this.chefService.getChefProposals(chefId, query);
  }

  @UseGuards(AuthGuard, RolesGuard)
  @Role(Roles.ADMIN)
  @Get('admin/count')
  @ApiOperation({ summary: 'Count total chefs' })
  async countChefs() {
    return this.chefService.countChefs();
  }
}
