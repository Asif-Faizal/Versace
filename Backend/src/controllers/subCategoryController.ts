import { Request, Response, NextFunction } from 'express';
import { SubCategoryService } from '../services/subCategoryService';
import { StatusCodes } from '../utils/statusCodes';
import { clearCache } from '../middleware/cache';

export class SubCategoryController {
  static async createSubCategory(req: Request, res: Response, next: NextFunction) {
    try {
      // Use the file from multer middleware if it exists
      const imageFile = req.file;
      const subCategoryData = req.body;
      
      const subCategory = await SubCategoryService.createSubCategory(subCategoryData, imageFile);
      
      // Clear caches
      await clearCache('subcategories:*');
      await clearCache('products:*');
      
      res.status(StatusCodes.CREATED).json(subCategory);
    } catch (error) {
      next(error);
    }
  }

  static async getSubCategory(req: Request, res: Response, next: NextFunction) {
    try {
      const subCategory = await SubCategoryService.getSubCategoryById(req.params.id);
      res.status(StatusCodes.OK).json(subCategory);
    } catch (error) {
      next(error);
    }
  }

  static async getAllSubCategories(req: Request, res: Response, next: NextFunction) {
    try {
      const categoryId = req.query.categoryId as string;
      const subCategories = await SubCategoryService.getAllSubCategories(categoryId);
      res.status(StatusCodes.OK).json(subCategories);
    } catch (error) {
      next(error);
    }
  }

  static async updateSubCategory(req: Request, res: Response, next: NextFunction) {
    try {
      // Use the file from multer middleware if it exists
      const imageFile = req.file;
      const subCategoryData = req.body;
      
      const subCategory = await SubCategoryService.updateSubCategory(req.params.id, subCategoryData, imageFile);
      
      // Clear caches
      await clearCache('subcategories:*');
      await clearCache('products:*');
      
      res.status(StatusCodes.OK).json(subCategory);
    } catch (error) {
      next(error);
    }
  }

  static async deleteSubCategory(req: Request, res: Response, next: NextFunction) {
    try {
      await SubCategoryService.deleteSubCategory(req.params.id);
      
      // Clear caches
      await clearCache('subcategories:*');
      await clearCache('products:*');
      
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }
} 