import { Request, Response, NextFunction } from 'express';
import { Category } from '../models/Category';
import { SubCategory } from '../models/SubCategory';
import { Product } from '../models/Product';
import { StatusCodes } from '../utils/statusCodes';

export class ListController {
  /**
   * @desc    Get all categories, subcategories, and products with just name and id in a single list
   * @route   GET /api/list
   * @access  Private
   */
  static async getAllLists(req: Request, res: Response, next: NextFunction) {
    try {
      const { name } = req.query;
      const nameFilter = name ? { name: { $regex: name, $options: 'i' } } : {};

      // Get categories with just name and _id
      const categories = await Category.find(nameFilter, 'name _id').lean();
      
      // Get subcategories with just name, _id, and category
      const subcategories = await SubCategory.find(nameFilter, 'name _id category').lean();
      
      // Get products with just name, _id, category, and subcategory
      const products = await Product.find(nameFilter, 'name _id category subcategory').lean();
      
      // Combine all items into a single array
      const allItems = [
        ...categories,
        ...subcategories,
        ...products
      ];
      
      res.status(StatusCodes.OK).json({
        success: true,
        data: {
          categories: allItems
        }
      });
    } catch (error) {
      next(error);
    }
  }
} 