import { BadRequestException, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { S3 } from 'aws-sdk';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class DOUploadService {
  private s3: S3;
  private bucketName: string;
  private region: string;
  private cdnUrl: string;

  constructor(private readonly configService: ConfigService) {
    this.region = this.configService.get<string>('do.region');
    this.bucketName = this.configService.get<string>('do.bucket');
    this.cdnUrl = this.configService.get<string>('do.cdnUrl');

    this.s3 = new S3({
      endpoint: `https://${this.region}.digitaloceanspaces.com`,
      region: this.region,
      accessKeyId: this.configService.get<string>('do.accessKey'),
      secretAccessKey: this.configService.get<string>('do.secretKey'),
      signatureVersion: 'v4',
    });
  }

  async uploadFiles(files: Express.Multer.File[], folder: string): Promise<string[]> {
    if (!files || files.length === 0) return [];

    const uploads = files.map((file) => this.uploadToDO(file, folder));
    return Promise.all(uploads);
  }

  async uploadFile(file: Express.Multer.File, folder: string): Promise<string> {
    if (!file) throw new Error('No file provided');
    return this.uploadToDO(file, folder);
  }

  private async uploadToDO(file: Express.Multer.File, folder: string): Promise<string> {
    const fileName = `stayVerse/${folder}/${uuidv4()}-${file.originalname}`;

    await this.s3
      .upload({
        Bucket: this.bucketName,
        Key: fileName,
        Body: file.buffer,
        ACL: 'public-read',
        ContentType: file.mimetype,
      })
      .promise();

    return `${this.cdnUrl}/${fileName}`;
  }

  async generateResumableUploadUrls(requests: { fileName: string; contentType: string }[]) {
    if (!Array.isArray(requests) || requests.length === 0) {
      throw new BadRequestException('At least one fileName and contentType pair is required');
    }

    return Promise.all(
      requests.map(async ({ fileName, contentType }) => {
        if (!fileName || !contentType) {
          throw new BadRequestException('fileName and contentType are required');
        }

        const key = `attachments/${fileName}`;

        const uploadUrl = await this.s3.getSignedUrlPromise('putObject', {
          Bucket: this.bucketName,
          Key: key,
          ContentType: contentType,
          ACL: 'public-read',
          Expires: 3600, // 1 hour
        });

        return uploadUrl;
      }),
    );
  }
}
