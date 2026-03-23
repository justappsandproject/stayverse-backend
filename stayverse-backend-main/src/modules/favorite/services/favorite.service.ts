import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Favorite, FavoriteDocument } from '../schemas/favorite.schema';
import { CreateFavoriteDto, FavoriteQueryDto } from '../dto/favorite.dto';
import { FavoriteStatus, ServiceType } from 'src/common/constants/enum';
import { Apartment, ApartmentDocument } from 'src/modules/apartment/schemas/apartment.schema';
import { Chef, ChefDocument } from 'src/modules/chef/schemas/chef.schema';
import { Ride, RideDocument } from 'src/modules/rides/schemas/rides.schema';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { toObjectId } from 'src/common/utils/objectId.utils';
import { paginate, PaginateOptions } from 'src/common/utils/pagination.utils';
@Injectable()
export class FavoriteService {
  constructor(
    @InjectModel(Favorite.name) private readonly favoriteModel: Model<FavoriteDocument>,
    @InjectModel(Apartment.name) private readonly apartmentModel: Model<ApartmentDocument>,
    @InjectModel(Ride.name) private readonly rideModel: Model<RideDocument>,
    @InjectModel(Chef.name) private readonly chefModel: Model<ChefDocument>) { }

  private async findService(dto) {
    switch (dto.serviceType) {
      case ServiceType.APARTMENT:
        return this.apartmentModel
          .findById(dto.apartmentId)
          .orFail(() => new NotFoundException('Apartment not found'));
      case ServiceType.RIDE:
        return this.rideModel
          .findById(dto.rideId)
          .orFail(() => new NotFoundException('Ride not found'));
      case ServiceType.CHEF:
        return this.chefModel
          .findById(dto.chefId)
          .orFail(() => new NotFoundException('Chef not found'));
      default:
        throw new BadRequestException('Invalid service type');
    }
  }
  async addFavorite(userId: string, dto: CreateFavoriteDto): Promise<string> {
    const userObjId = new Types.ObjectId(userId);
    switch (dto.serviceType) {
      case ServiceType.APARTMENT:
        dto.rideId = null;
        dto.chefId = null;
        if (dto.apartmentId) dto.apartmentId = new Types.ObjectId(dto.apartmentId);
        break;
      case ServiceType.RIDE:
        dto.apartmentId = null;
        dto.chefId = null;
        if (dto.rideId) dto.rideId = new Types.ObjectId(dto.rideId);
        break;
      case ServiceType.CHEF:
        dto.apartmentId = null;
        dto.rideId = null;
        if (dto.chefId) dto.chefId = new Types.ObjectId(dto.chefId);
        break;
    }

    const service = await this.findService(dto);
    const match: any = { userId: userObjId, serviceType: dto.serviceType };
    if (dto.apartmentId) match.apartmentId = dto.apartmentId;
    if (dto.rideId) match.rideId = dto.rideId;
    if (dto.chefId) match.chefId = dto.chefId;

    const existing = await this.favoriteModel.findOne(match);

    if (existing) {
      const newStatus = existing.status === FavoriteStatus.ACTIVE
        ? FavoriteStatus.INACTIVE
        : FavoriteStatus.ACTIVE;
      await this.favoriteModel.updateOne({ _id: existing._id }, { status: newStatus });
      return newStatus === FavoriteStatus.ACTIVE
        ? 'Added to favorites'
        : 'Removed from favorites';
    }

    await this.favoriteModel.create({
      ...dto,
      status: FavoriteStatus.ACTIVE,
      userId: userObjId,
      agentId: service.agentId
    });
    return 'Added to favorites';
  }

  private async getFavorites(filter: any, query: PaginationQueryDto) {
    const options: PaginateOptions<any> = {
      model: this.favoriteModel,
      filter,
      params: query,
      sort: { createdAt: -1 },
      populate: [
        {
          path: 'user',
          select: '-passwordHash -__v -createdAt -updatedAt -socketId -role -otp -pinExpires',
        },
        {
          path: 'agent',
          select: '-__v -balance',
          populate: {
            path: 'user',
            model: 'User',
            select: '-_id -role -passwordHash -__v -createdAt -updatedAt',
          },
        },
        {
          path: 'apartment',
          select: '-__v',
        },
        {
          path: 'chef',
          select: '-__v',
        },
        {
          path: 'ride',
          select: '-__v',
        }
      ]
    };

    return paginate(options);
  }

  async getUserFavorites(userId: string, query: FavoriteQueryDto) {
    const filter = { userId: toObjectId(userId),serviceType:query.serviceType,status:FavoriteStatus.ACTIVE };
    return this.getFavorites(filter, query)
  }
  
  async getAgentFavorites(agentId: string, query: PaginationQueryDto) {
    const filter = { agentId: toObjectId(agentId),status:FavoriteStatus.ACTIVE };
    return this.getFavorites(filter, query)
  }
}
