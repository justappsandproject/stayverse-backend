import { Body, Controller, Delete, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard, Public } from 'src/common/guards/auth.guard';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { Roles } from 'src/common/constants/enum';
import { TestimonialService } from '../services/testimonial.service';
import { CreateTestimonialDto } from '../dto/create-testimonial.dto';
import { UpdateTestimonialDto } from '../dto/update-testimonial.dto';

@ApiTags('Testimonials')
@Controller('testimonials')
@UseGuards(AuthGuard, RolesGuard)
export class TestimonialController {
  constructor(private readonly testimonialService: TestimonialService) {}

  @Get('public')
  @Public()
  @ApiOperation({ summary: 'List active testimonials for website' })
  async listPublic() {
    return this.testimonialService.listPublic();
  }

  @Get()
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'List all testimonials (admin)' })
  async listAll() {
    return this.testimonialService.listAll();
  }

  @Post()
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create testimonial (admin)' })
  async create(@Body() payload: CreateTestimonialDto) {
    return this.testimonialService.create(payload);
  }

  @Patch(':id')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update testimonial (admin)' })
  async update(@Param('id') id: string, @Body() payload: UpdateTestimonialDto) {
    return this.testimonialService.update(id, payload);
  }

  @Delete(':id')
  @Role(Roles.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete testimonial (admin)' })
  async remove(@Param('id') id: string) {
    return this.testimonialService.remove(id);
  }
}
