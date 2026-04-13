import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService {
    private readonly logger = new Logger(FirebaseService.name);
    private firebaseApp: admin.app.App | null = null;

    constructor(private readonly configService: ConfigService) {
        // Note: we intentionally do NOT crash the backend on missing/invalid Firebase config.
        // Firebase-dependent features should fail gracefully when they are called.
        const serviceAccountString =
            this.configService.get<string>('FIREBASE_KEY_FILE') ??
            this.configService.get<string>('GCP_KEY_FILE');

        if (!serviceAccountString) {
            this.logger.warn('⚠️ Firebase not configured, skipping initialization');
            return;
        }

        let serviceAccount: unknown;
        try {
            serviceAccount = JSON.parse(serviceAccountString);
        } catch (error) {
            this.logger.warn('⚠️ Firebase config is invalid JSON, skipping initialization');
            this.logger.warn(error instanceof Error ? error.message : String(error));
            return;
        }

        // Convert escaped newlines to real ones (common in env var JSON strings)
        const accountObj = serviceAccount as { private_key?: unknown };
        if (typeof accountObj?.private_key === 'string') {
            accountObj.private_key = accountObj.private_key.replace(/\\n/g, '\n');
        } else {
            this.logger.warn('⚠️ Firebase config missing `private_key`, skipping initialization');
            return;
        }

        try {
            // Avoid duplicate initializeApp calls if the service is constructed more than once.
            if (admin.apps.length === 0) {
                this.firebaseApp = admin.initializeApp({
                    credential: admin.credential.cert(accountObj as admin.ServiceAccount),
                });
            } else {
                this.firebaseApp = admin.apps[0];
            }

            this.logger.log('✅ Firebase initialized successfully');
        } catch (error) {
            this.logger.warn('⚠️ Firebase initialization failed, skipping initialization');
            this.logger.warn(error instanceof Error ? error.message : String(error));
        }
    }

    getApp(): admin.app.App {
        if (!this.firebaseApp) {
            throw new Error('Firebase not configured');
        }
        return this.firebaseApp;
    }

    getMessaging(): admin.messaging.Messaging {
        if (!this.firebaseApp) {
            throw new Error('Firebase not configured');
        }
        return this.firebaseApp.messaging();
    }
}
