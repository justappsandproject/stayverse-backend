import { Injectable, PipeTransform, BadRequestException, HttpStatus } from '@nestjs/common';
import { ParseFilePipeBuilder } from '@nestjs/common/pipes';
import { Express } from 'express';

@Injectable()
export class FileUploadPipe implements PipeTransform {
  private readonly pipe;

  constructor() {
    this.pipe = new ParseFilePipeBuilder()
      .addFileTypeValidator({
        fileType: /^image\/(jpeg|jpg|png|webp)$/,
      })
      .addMaxSizeValidator({
        maxSize: 5 * 1024 * 1024, // 5MB
      })
      .build({
        errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
      });
  }

  async transform(value: any) {
    if (!value) throw new BadRequestException('No file(s) uploaded');

    // CASE 1: Single file upload (FileInterceptor)
    if (value.fieldname) {
      try {
        await this.pipe.transform(value);
        return value;
      } catch (error) {
        throw new BadRequestException(
          `File "${value.originalname}" is invalid: ${error.message}`,
        );
      }
    }

    // CASE 2: Multiple files under named fields (FileFieldsInterceptor)
    if (typeof value === 'object') {
      const validatedFiles: Record<string, Express.Multer.File[]> = {};

      for (const field of Object.keys(value)) {
        const files = value[field];
        if (!Array.isArray(files) || files.length === 0) {
          throw new BadRequestException(`Field "${field}" has no files`);
        }

        await Promise.all(
          files.map(async (file) => {
            try {
              await this.pipe.transform(file);
            } catch (error) {
              throw new BadRequestException(
                `File "${file.originalname}" in field "${field}" is invalid: ${error.message}`,
              );
            }
          }),
        );

        validatedFiles[field] = files;
      }

      return validatedFiles;
    }

    throw new BadRequestException('Invalid file upload format');
  }
}
