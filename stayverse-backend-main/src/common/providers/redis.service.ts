// import { Injectable, OnModuleDestroy, OnModuleInit, Logger } from '@nestjs/common';
// import { ConfigService } from '@nestjs/config';
// import Redis from 'ioredis';

// @Injectable()
// export class RedisService implements OnModuleInit, OnModuleDestroy {
//   private client: Redis;
//   private readonly logger = new Logger(RedisService.name);

//   constructor(private readonly configService: ConfigService) {}

//   onModuleInit() {
//     const redisCred = {
//       host: this.configService.get<string>('redis.host'),
//       port: this.configService.get<number>('redis.port'),
//       username: this.configService.get<string>('redis.username'),
//       password: this.configService.get<string>('redis.password'),
//     };

//     this.client = new Redis(redisCred);

//     this.client.on('connect', () => {
//       this.logger.log(`Connected to Redis at ${redisCred.host}:${redisCred.port}`);
//     });

//     this.client.on('error', (err) => {
//       this.logger.error('Redis error', err);
//     });
//   }

//   async onModuleDestroy() {
//     this.logger.log('Disconnecting from Redis');
//     await this.client.quit();
//   }

//   async setSocketId(userId: string, socketId: string): Promise<'OK' | null> {
//     return this.client.set(`socket:${userId}`, socketId);
//   }

//   async getSocketId(userId: string): Promise<string | null> {
//     return this.client.get(`socket:${userId}`);
//   }

//   async clearSocketId(userId: string): Promise<number> {
//     return this.client.del(`socket:${userId}`);
//   }

//   async set(key: string, value: string, expiryInSec?: number): Promise<'OK' | null> {
//     if (expiryInSec) {
//       return this.client.set(key, value, 'EX', expiryInSec);
//     }
//     return this.client.set(key, value);
//   }

//   async get(key: string): Promise<string | null> {
//     return this.client.get(key);
//   }

//   async del(...keys: string[]): Promise<number> {
//     return this.client.del(...keys);
//   }

//   async exists(key: string): Promise<boolean> {
//     return (await this.client.exists(key)) === 1;
//   }

//   async sadd(key: string, value: string): Promise<number> {
//     return this.client.sadd(key, value);
//   }

//   async srem(key: string, value: string): Promise<number> {
//     return this.client.srem(key, value);
//   }

//   async smembers(key: string): Promise<string[]> {
//     return this.client.smembers(key);
//   }

//   async scard(key: string): Promise<number> {
//     return this.client.scard(key);
//   }

//   get clientInstance(): Redis {
//     return this.client;
//   }
// }
