import { NestApplication, NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { join } from 'path';
import { BadRequestException, Logger, ValidationPipe } from '@nestjs/common';
import { WinstonLoggerService } from './common/utils/winston.logger';
async function bootstrap() {
  const app = await NestFactory.create<NestApplication>(AppModule);
  app.useLogger(app.get(WinstonLoggerService));
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    allowedHeaders: 'Content-Type,Accept,Authorization',
    credentials: true,
  });
  // const customIoAdapter = new CustomIoAdapter(app);
  // await customIoAdapter.initializeRedisAdapter();
  // app.useWebSocketAdapter(customIoAdapter);
  app.useStaticAssets(join(__dirname, '..', 'public'));
  if (process.env.NODE_ENV !== 'production') {
    const config = new DocumentBuilder()
      .setTitle('Stay-Verse API')
      .setDescription('API documentation for Stay-Verse')
      .setVersion('1.0')
      .addBearerAuth()
      .build();

    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api/docs', app, document);
  }

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      exceptionFactory: (errors) => {
        const firstError = errors[0];
        const firstConstraint = firstError?.constraints
          ? Object.values(firstError.constraints)[0]
          : 'Validation failed';
        return new BadRequestException(firstConstraint);
      },
    }),
  );

  const port = process.env.PORT ?? 2000;
  await app.listen(port);

  const logger = new Logger('Bootstrap');
  logger.log(`Application running on port ${port}`);
}

const UNCAUGHT_EXCEPTION = 'UncaughtException';
const UNHANDLED_REJECTION = 'UnhandledRejection';

process.on('uncaughtException', (error) => {
  new Logger(UNCAUGHT_EXCEPTION).error(error.message, error.stack);
  process.exit(1);
});

process.on('unhandledRejection', (reason: any) => {
  new Logger(UNHANDLED_REJECTION).error(reason?.message || reason, reason?.stack);
});

bootstrap();
