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
      
      // Get uploaded files from multer
      const files: { [key: string]: Express.Multer.File | undefined } = {
        main: req.files && Array.isArray(req.files) ? 
          req.files.find(file => file.fieldname === 'main') : undefined,
        thumbnail: req.files && Array.isArray(req.files) ? 
          req.files.find(file => file.fieldname === 'thumbnail') : undefined,
        detail1: req.files && Array.isArray(req.files) ? 
          req.files.find(file => file.fieldname === 'detail1') : undefined,
        detail2: req.files && Array.isArray(req.files) ? 
          req.files.find(file => file.fieldname === 'detail2') : undefined
      };
      
      // Convert from object of files to object expected by service
      const imageFiles = {
        main: files.main,
        thumbnail: files.thumbnail,
        detail1: files.detail1,
        detail2: files.detail2
      };
      
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