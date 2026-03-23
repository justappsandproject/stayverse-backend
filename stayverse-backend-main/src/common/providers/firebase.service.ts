import { Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService {
    private readonly logger = new Logger(FirebaseService.name);
    private firebaseApp: admin.app.App;

    constructor(private readonly configService: ConfigService) {
        try {
            const serviceAccountString = this.configService.get<string>('FIREBASE_KEY_FILE');
            const serviceAccount = JSON.parse(serviceAccountString);

            // Convert escaped newlines to real ones
            serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');

            this.firebaseApp = admin.initializeApp({
                credential: admin.credential.cert(serviceAccount as admin.ServiceAccount),
            });

            this.logger.log('✅ Firebase initialized successfully');
        } catch (error) {
            this.logger.error('❌ Firebase initialization failed');
            this.logger.error(error);
            throw new InternalServerErrorException('Firebase initialization failed');
        }
    }

    getApp(): admin.app.App {
        return this.firebaseApp;
    }

    getMessaging(): admin.messaging.Messaging {
        return this.firebaseApp.messaging();
    }
}
