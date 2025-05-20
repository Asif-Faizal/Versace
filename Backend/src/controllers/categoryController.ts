import { Request, Response, NextFunction } from 'express';
import { CategoryService } from '../services/categoryService';
import { StatusCodes } from '../utils/statusCodes';
import { clearCache } from '../middleware/cache';

export class CategoryController {
  static async createCategory(req: Request, res: Response, next: NextFunction) {
    try {
      // Use the file from multer middleware if it exists
      const imageFile = req.file;
      const categoryData = req.body;
      
      const category = await CategoryService.createCategory(categoryData, imageFile);
      
      // Clear categories cache after creation
      await clearCache('categories:*');
      // Also clear products cache as they may display category information
      await clearCache('products:*');
      
      res.status(StatusCodes.CREATED).json(category);
    } catch (error) {
      next(error);
    }
  }

  static async getCategory(req: Request, res: Response, next: NextFunction) {
    try {
      const category = await CategoryService.getCategoryById(req.params.id);
      res.status(StatusCodes.OK).json(category);
    } catch (error) {
      next(error);
    }
  }

  static async getAllCategories(req: Request, res: Response, next: NextFunction) {
    try {
      const categories = await CategoryService.getAllCategories();
      res.status(StatusCodes.OK).json(categories);
    } catch (error) {
      next(error);
    }
  }

  static async updateCategory(req: Request, res: Response, next: NextFunction) {
    try {
      // Use the file from multer middleware if it exists
      const imageFile = req.file;
      const categoryData = req.body;
      
      const category = await CategoryService.updateCategory(req.params.id, categoryData, imageFile);
      
      // Clear categories cache after update
      await clearCache('categories:*');
      // Also clear products cache as they may display category information
      await clearCache('products:*');
      
      res.status(StatusCodes.OK).json(category);
    } catch (error) {
      next(error);
    }
  }

  static async deleteCategory(req: Request, res: Response, next: NextFunction) {
    try {
      await CategoryService.deleteCategory(req.params.id);
      // Clear categories cache after deletion
      await clearCache('categories:*');
      // Also clear products cache as they may display category information
      await clearCache('products:*');
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }
}