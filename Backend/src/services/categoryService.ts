import { Category, ICategory } from '../models/Category';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

export class CategoryService {
  static async createCategory(categoryData: Partial<ICategory>): Promise<ICategory> {
    const existingCategory = await Category.findOne({ name: categoryData.name });
    if (existingCategory) {
      throw new AppError(StatusCodes.CONFLICT, 'Category with this name already exists');
    }

    const category = await Category.create(categoryData);
    return category;
  }

  static async getCategoryById(id: string): Promise<ICategory> {
    const category = await Category.findById(id);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }
    return category;
  }

  static async getAllCategories(): Promise<ICategory[]> {
    return Category.find().sort({ name: 1 });
  }

  static async updateCategory(id: string, updateData: Partial<ICategory>): Promise<ICategory> {
    if (updateData.name) {
      const existingCategory = await Category.findOne({ 
        name: updateData.name,
        _id: { $ne: id }
      });
      if (existingCategory) {
        throw new AppError(StatusCodes.CONFLICT, 'Category with this name already exists');
      }
    }

    const category = await Category.findByIdAndUpdate(
      id,
      { $set: updateData },
      { new: true, runValidators: true }
    );

    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }

    return category;
  }

  static async deleteCategory(id: string): Promise<void> {
    const category = await Category.findByIdAndDelete(id);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }
  }
}