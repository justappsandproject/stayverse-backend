import { diskStorage } from 'multer';
import * as path from 'path';

export const multerConfig = {
  storage: diskStorage({
    destination: './uploads',
    filename: (req, file, cb) => {
      const fileExt = path.extname(file.originalname);
      const fileName = `${Date.now()}-${Math.random() * 1e6}${fileExt}`;
      cb(null, fileName);
    },
  }),
};
