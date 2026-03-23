import { ConfigService } from '@nestjs/config';
import { StreamChat } from 'stream-chat';

export const STREAM_CLIENT = 'STREAM_CLIENT';

export const StreamProvider = {
  provide: STREAM_CLIENT,
  useFactory: (configService: ConfigService): StreamChat => {
    return StreamChat.getInstance(
      configService.get<string>('stream.apiKey'),
      configService.get<string>('stream.apiSecret'),
    );
  },
  inject: [ConfigService],
};
