import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Testimonial, TestimonialDocument } from '../schemas/testimonial.schema';
import { CreateTestimonialDto } from '../dto/create-testimonial.dto';
import { UpdateTestimonialDto } from '../dto/update-testimonial.dto';

@Injectable()
export class TestimonialService {
  constructor(
    @InjectModel(Testimonial.name)
    private readonly testimonialModel: Model<TestimonialDocument>,
  ) {}

  async listPublic() {
    return this.testimonialModel
      .find({ isActive: true })
      .sort({ sortOrder: 1, createdAt: -1 })
      .lean();
  }

  async listAll() {
    return this.testimonialModel
      .find({})
      .sort({ sortOrder: 1, createdAt: -1 })
      .lean();
  }

  async create(payload: CreateTestimonialDto) {
    return this.testimonialModel.create({
      ...payload,
      isActive: payload.isActive ?? true,
      sortOrder: payload.sortOrder ?? 0,
    });
  }

  async update(id: string, payload: UpdateTestimonialDto) {
    const updated = await this.testimonialModel
      .findByIdAndUpdate(id, { $set: payload }, { new: true })
      .lean();
    if (!updated) throw new NotFoundException('Testimonial not found');
    return updated;
  }

  async remove(id: string) {
    const deleted = await this.testimonialModel.findByIdAndDelete(id).lean();
    if (!deleted) throw new NotFoundException('Testimonial not found');
    return deleted;
  }
}
