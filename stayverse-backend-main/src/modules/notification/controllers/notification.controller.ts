import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
  Req,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { Roles } from 'src/common/constants/enum';
import { AuthGuard } from 'src/common/guards/auth.guard';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { BroadcastMessageDto } from '../dto/broadcast-message.dto';
import { NotificationService } from '../services/notification.service';
import { ListCuratedMessagesDto } from '../dto/list-curated-messages.dto';
import { ReactCuratedMessageDto } from '../dto/interact-curated-message.dto';
import { FileUploadPipe } from 'src/common/pipes/file-upload.pipe';
import { DOUploadService } from 'src/common/providers/digiital-ocean.service';

@ApiTags('Notification')
@Controller('notification')
@UseGuards(AuthGuard, RolesGuard)
export class NotificationController {
  constructor(
    private readonly notificationService: NotificationService,
    private readonly uploadService: DOUploadService,
  ) {}

  @Post('broadcast')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Broadcast curated message to users/agents/all' })
  @ApiBody({ type: BroadcastMessageDto })
  async broadcastMessage(@Req() req, @Body() payload: BroadcastMessageDto) {
    const result = await this.notificationService.broadcastCuratedMessage(payload, req.user?.sub);

    return {
      message: 'Broadcast completed',
      data: result,
    };
  }

  @Get('curated')
  @Role(Roles.USER, Roles.AGENT)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List curated messages for current user/agent' })
  async listCuratedMessages(@Req() req, @Query() query: ListCuratedMessagesDto) {
    const role = req.user?.role as Roles;
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    return await this.notificationService.listCuratedMessagesForRole(
      role,
      page,
      limit,
      req.user?.sub,
    );
  }

  @Get('curated/admin')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List curated messages for admin with engagement stats' })
  async listCuratedMessagesForAdmin(@Query() query: ListCuratedMessagesDto) {
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    return await this.notificationService.listCuratedMessagesForAdmin(page, limit);
  }

  @Post('curated/:id/read')
  @Role(Roles.USER, Roles.AGENT)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Mark curated message as read' })
  async markCuratedMessageRead(@Req() req, @Param('id') id: string) {
    const role = req.user?.role as Roles;
    return await this.notificationService.markCuratedMessageRead(id, req.user?.sub, role);
  }

  @Post('curated/:id/react')
  @Role(Roles.USER, Roles.AGENT)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'React to a curated message' })
  async reactToCuratedMessage(
    @Req() req,
    @Param('id') id: string,
    @Body() body: ReactCuratedMessageDto,
  ) {
    const role = req.user?.role as Roles;
    return await this.notificationService.reactToCuratedMessage(
      id,
      req.user?.sub,
      role,
      body.reaction,
    );
  }

  @Post('curated/upload-image')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Upload curated message image' })
  @UseInterceptors(FileInterceptor('image'))
  async uploadCuratedImage(
    @UploadedFile(new FileUploadPipe()) image: Express.Multer.File,
  ) {
    if (!image) {
      throw new BadRequestException('Image file is required');
    }
    const imageUrl = await this.uploadService.uploadFile(image, 'curated-messages');
    return { imageUrl };
  }
}
