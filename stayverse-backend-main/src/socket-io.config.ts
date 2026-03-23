import { IoAdapter } from '@nestjs/platform-socket.io';
import { Logger } from '@nestjs/common';
import { ServerOptions } from 'socket.io';
import { createAdapter } from '@socket.io/redis-adapter';
import { createClient } from 'redis';
import * as dotenv from 'dotenv';

dotenv.config();

export class CustomIoAdapter extends IoAdapter {
    private readonly logger = new Logger(CustomIoAdapter.name);
    private adapterConstructor: ReturnType<typeof createAdapter>;

    constructor(app: any) {
        super(app);
    }

    async initializeRedisAdapter() {

        const pubClient = createClient({
            username: process.env.REDIS_USERNAME,
            password: process.env.REDIS_PASSWORD,
            socket: {
                host: process.env.REDIS_HOST,
                port: Number(process.env.REDIS_PORT),
            },
        });;
        const subClient = pubClient.duplicate();

        pubClient.on('error', (err) => this.logger.error('Redis Pub Client Error', err.stack));
        subClient.on('error', (err) => this.logger.error('Redis Sub Client Error', err.stack));

        await pubClient.connect();
        await subClient.connect();

        this.adapterConstructor = createAdapter(pubClient, subClient);
        this.logger.log('Redis adapter initialized');
    }

    createIOServer(port: number, options?: ServerOptions) {
        if (!this.adapterConstructor) {
            throw new Error('Redis adapter is not initialized');
        }

        const server = super.createIOServer(port, {
            ...options,
            adapter: this.adapterConstructor,
        });

        this.logger.log('Socket.IO server created with Redis adapter');
        return server;
    }
}
