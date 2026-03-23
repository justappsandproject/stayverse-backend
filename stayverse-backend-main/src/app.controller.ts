import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { Public } from './common/guards/auth.guard';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) { }

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Public()
  @Get('test-log')
  getTestLog(): string {
    return this.appService.getTestLog();
  }
}
