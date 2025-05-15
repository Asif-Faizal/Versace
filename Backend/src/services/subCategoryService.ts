import { SubCategory, ISubCategory } from '../models/SubCategory';
import { Category } from '../models/Category';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

export class SubCategoryService {
  static async createSubCategory(subCategoryData: Partial<ISubCategory>): Promise<ISubCategory> {
    // Verify category exists
    const category = await Category.findById(subCategoryData.category);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }

    // Check if subcategory with same name exists in the category
    const existingSubCategory = await SubCategory.findOne({
      name: subCategoryData.name,
      category: subCategoryData.category
    });
    if (existingSubCategory) {
      throw new AppError(StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
    }

    const subCategory = await SubCategory.create(subCategoryData);
    return subCategory;
  }

  static async getSubCategoryById(id: string): Promise<ISubCategory> {
    const subCategory = await SubCategory.findById(id).populate('category', 'name');
    if (!subCategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'SubCategory not found');
    }
    return subCategory;
  }

  static async getAllSubCategories(categoryId?: string): Promise<ISubCategory[]> {
    const query = categoryId ? { category: categoryId } : {};
    return SubCategory.find(query)
      .populate('category', 'name')
      .sort({ name: 1 });
  }

  static async updateSubCategory(id: string, updateData: Partial<ISubCategory>): Promise<ISubCategory> {
    // If category is being updated, verify it exists
    if (updateData.category) {
      const category = await Category.findById(updateData.category);
      if (!category) {
        throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
      }
    }

    // Check for name conflict if name is being updated
    if (updateData.name) {
      const existingSubCategory = await SubCategory.findOne({
        name: updateData.name,
        category: updateData.category,
        _id: { $ne: id }
      });
      if (existingSubCategory) {
        throw new AppError(StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
      }
    }

    const subCategory = await SubCategory.findByIdAndUpdate(
      id,
      { $set: updateData },
      { new: true, runValidators: true }
    ).populate('category', 'name');

    if (!subCategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'SubCategory not found');
    }

    return subCategory;
  }

  static async deleteSubCategory(id: string): Promise<void> {
    const subCategory = await SubCategory.findByIdAndDelete(id);
    if (!subCategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'SubCategory not found');
    }
  }
} 