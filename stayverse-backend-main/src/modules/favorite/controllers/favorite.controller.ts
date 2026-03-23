import {
    Controller,
    Post,
    Body,
    Delete,
    Get,
    Param,
    UseGuards,
    Req,
    Query
} from '@nestjs/common';
import { FavoriteService } from '../services/favorite.service';
import { CreateFavoriteDto, FavoriteQueryDto } from '../dto/favorite.dto';
import { Favorite } from '../schemas/favorite.schema';
import {
    ApiTags,
    ApiOperation,
    ApiResponse,
    ApiBearerAuth,
    ApiBody
} from '@nestjs/swagger';
import { AuthGuard } from 'src/common/guards/auth.guard';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';

@ApiTags('Favorites')
@ApiBearerAuth()
@Controller('favorites')
@UseGuards(AuthGuard)
export class FavoriteController {
    constructor(private readonly favoriteService: FavoriteService) { }

    @Post()
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Add a favorite service' })
    @ApiResponse({ status: 201, description: 'Favorite added successfully', type: Favorite })
    @ApiResponse({ status: 400, description: 'Invalid input' })
    @ApiBody({ type: CreateFavoriteDto })
    async addFavorite(@Req() req, @Body() createFavoriteDto: CreateFavoriteDto): Promise<string> {
        const userId: string = req.user.sub;
        return this.favoriteService.addFavorite(userId, createFavoriteDto);
    }
    @Get('/user')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get all active favorites for the logged-in user' })
    @ApiResponse({ status: 200, description: 'List of favorites', type: [Favorite] })
    async getUserFavorites(@Req() req, @Query() query: FavoriteQueryDto
    ) {
        return this.favoriteService.getUserFavorites(req.user.sub, query);
    }
    @Get('/agent')
    @ApiBearerAuth()
    @ApiOperation({ summary: 'Get all active favorites for the logged-in Agent' })
    @ApiResponse({ status: 200, description: 'List of favorites', type: [Favorite] })
    async getAgentFavorites(@Req() req, @Query() query: PaginationQueryDto
    ) {
        return this.favoriteService.getAgentFavorites(req.user.agent, query);
    }
}
