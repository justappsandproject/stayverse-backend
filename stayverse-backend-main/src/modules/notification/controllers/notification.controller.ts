import { Body, Controller, Get, Post, Query, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiBody, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Roles } from 'src/common/constants/enum';
import { AuthGuard } from 'src/common/guards/auth.guard';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { BroadcastMessageDto } from '../dto/broadcast-message.dto';
import { NotificationService } from '../services/notification.service';
import { ListCuratedMessagesDto } from '../dto/list-curated-messages.dto';

@ApiTags('Notification')
@Controller('notification')
@UseGuards(AuthGuard, RolesGuard)
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

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
    return await this.notificationService.listCuratedMessagesForRole(role, page, limit);
  }
}
