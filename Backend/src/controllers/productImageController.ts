import { Request, Response, NextFunction } from 'express';
import { ProductImageService } from '../services/productImageService';
import { StatusCodes } from '../utils/statusCodes';
import { clearCache } from '../middleware/cache';

export class ProductImageController {
  /**
   * Upload images for a specific product variant combination
   */
  static async uploadVariantImages(req: Request, res: Response, next: NextFunction) {
    try {
      const { productId, variantId } = req.params;
      
      // Check for files in the request
      if (!req.files || typeof req.files !== 'object') {
        console.error('No files were uploaded or files is not an object:', req.files);
        return res.status(StatusCodes.BAD_REQUEST).json({ 
          error: 'No files were uploaded or invalid file format' 
        });
      }
      
      // With multer's upload.fields(), files are organized by field name
      const filesObj = req.files as { [fieldname: string]: Express.Multer.File[] };

      // Extract the files from the object
      const imageFiles = {
        main: filesObj.main && filesObj.main.length > 0 ? filesObj.main[0] : undefined,
        thumbnail: filesObj.thumbnail && filesObj.thumbnail.length > 0 ? filesObj.thumbnail[0] : undefined,
        detail1: filesObj.detail1 && filesObj.detail1.length > 0 ? filesObj.detail1[0] : undefined,
        detail2: filesObj.detail2 && filesObj.detail2.length > 0 ? filesObj.detail2[0] : undefined
      };
      
      // Log what we found for debugging
      console.log('Files received for upload:', Object.keys(filesObj));
      console.log('Files to process:', Object.keys(imageFiles).filter(key => !!imageFiles[key as keyof typeof imageFiles]));
      
      const productImages = await ProductImageService.uploadVariantImages(
        productId,
        variantId,
        imageFiles
      );
      
      // Clear product cache
      await clearCache(`products:${productId}`);
      await clearCache('products:*');
      
      res.status(StatusCodes.OK).json(productImages);
    } catch (error) {
      console.error('Error uploading product images:', error);
      next(error);
    }
  }
  
  /**
   * Delete all images for a specific product variant combination
   */
  static async deleteVariantImages(req: Request, res: Response, next: NextFunction) {
    try {
      const { productId, variantId } = req.params;
      
      await ProductImageService.deleteVariantImages(productId, variantId);
      
      // Clear product cache
      await clearCache(`products:${productId}`);
      await clearCache('products:*');
      
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }
} 