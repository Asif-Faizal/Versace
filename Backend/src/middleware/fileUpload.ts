import multer from 'multer';
import { Request, Response, NextFunction } from 'express';
import path from 'path';

// Set up in-memory storage
const storage = multer.memoryStorage();

// File filter to accept only images
const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
  // Accept only image files
  if (file.mimetype.startsWith('image/')) {
    cb(null, true);
  } else {
    cb(new Error('Only image files are allowed'));
  }
};

// Create multer upload instance
export const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
  },
});

// Middleware to handle file upload errors
export const handleUploadErrors = (err: any, req: Request, res: Response, next: NextFunction) => {
  if (err instanceof multer.MulterError) {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        success: false,
        message: 'File too large. Maximum size is 5MB',
      });
    }
    return res.status(400).json({
      success: false,
      message: `Upload error: ${err.message}`,
    });
  }
  
  if (err) {
    return res.status(400).json({
      success: false,
      message: err.message,
    });
  }
  
  next();
};

// Generate a unique filename for uploaded files
export const generateFileName = (file: Express.Multer.File, prefix: string): string => {
  const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
  const fileExt = path.extname(file.originalname).toLowerCase();
  return `${prefix}-${uniqueSuffix}${fileExt}`;
};

export default {
  upload,
  handleUploadErrors,
  generateFileName,
}; 