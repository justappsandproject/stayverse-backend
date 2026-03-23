import { Test, TestingModule } from '@nestjs/testing';
import { AgentService } from './agent.service';
import { getModelToken } from '@nestjs/mongoose';
import { Agent } from '../schemas/agent.schema';
import { Booking } from '../../booking/schemas/booking.schema';
import { User } from '../../user/schemas/user.schema';
import { Apartment } from '../../apartment/schemas/apartment.schema';
import { Ride } from '../../rides/schemas/rides.schema';
import { Chef } from '../../chef/schemas/chef.schema';
import { Favorite } from '../../favorite/schemas/favorite.schema';
import { StreamChat } from 'stream-chat';
import { STREAM_CLIENT } from '../../../common/providers/stream.provider';
import { OtpService } from '../../../common/providers/otp.service';
import { JwtService } from '@nestjs/jwt';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BadRequestException } from '@nestjs/common';
import { BookingStatus } from '../../../common/constants/enum';

describe('AgentService Soft Delete', () => {
  let service: AgentService;
  let agentModel: any;
  let bookingModel: any;

  const mockAgent = {
    _id: 'agent123',
    userId: 'user123',
    save: jest.fn().mockResolvedValue(true),
    isDeleted: false,
  };

  const mockModels = {
    findOne: jest.fn(),
    findById: jest.fn(),
    countDocuments: jest.fn(),
  };

  const mockStreamClient = {
    createToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AgentService,
        { provide: getModelToken(Agent.name), useValue: { ...mockModels } },
        { provide: getModelToken(User.name), useValue: mockModels },
        { provide: getModelToken(Booking.name), useValue: { ...mockModels } },
        { provide: getModelToken(Apartment.name), useValue: mockModels },
        { provide: getModelToken(Ride.name), useValue: mockModels },
        { provide: getModelToken(Chef.name), useValue: mockModels },
        { provide: getModelToken(Favorite.name), useValue: mockModels },
        { provide: STREAM_CLIENT, useValue: mockStreamClient },
        { provide: OtpService, useValue: {} },
        { provide: JwtService, useValue: {} },
        { provide: EventEmitter2, useValue: {} },
      ],
    }).compile();

    service = module.get<AgentService>(AgentService);
    agentModel = module.get(getModelToken(Agent.name));
    bookingModel = module.get(getModelToken(Booking.name));

    jest.clearAllMocks();
  });

  describe('softDeleteAgent', () => {
    it('should soft delete agent if no active bookings', async () => {
      agentModel.findById.mockResolvedValue(mockAgent);
      bookingModel.countDocuments.mockResolvedValue(0);

      const result = await service.softDeleteAgent('user123');

      expect(agentModel.findById).toHaveBeenCalledWith('user123');
      expect(mockAgent.isDeleted).toBe(true);
      expect(mockAgent.save).toHaveBeenCalled();
      expect(result).toEqual({ message: 'Agent profile deleted successfully' });
    });

    it('should throw BadRequestException if agent has active bookings', async () => {
      agentModel.findById.mockResolvedValue(mockAgent);
      bookingModel.countDocuments.mockResolvedValue(1);

      await expect(service.softDeleteAgent('user123')).rejects.toThrow(
        new BadRequestException('Cannot delete agent profile. You have active service bookings pending completion.')
      );

      expect(mockAgent.save).not.toHaveBeenCalled();
    });
  });
});
