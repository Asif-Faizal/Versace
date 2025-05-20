import { SubCategory, ISubCategory } from '../models/SubCategory';
import { Category } from '../models/Category';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import fileUploadService from './fileUploadService';
import config from '../config/config';
import { generateFileName } from '../middleware/fileUpload';

export class SubCategoryService {
  static async createSubCategory(
    subCategoryData: Partial<ISubCategory>,
    imageFile?: Express.Multer.File
  ): Promise<ISubCategory> {
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

    // Handle image upload if provided
    if (imageFile) {
      const fileName = generateFileName(imageFile, `subcategory-${subCategoryData.name}`);
      const imageUrl = await fileUploadService.uploadImage(
        imageFile.buffer,
        config.supabase.buckets.subcategories,
        fileName
      );
      subCategoryData.image = imageUrl;
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

  static async updateSubCategory(
    id: string, 
    updateData: Partial<ISubCategory>,
    imageFile?: Express.Multer.File
  ): Promise<ISubCategory> {
    const subCategory = await SubCategory.findById(id);
    if (!subCategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'SubCategory not found');
    }

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
        category: updateData.category || subCategory.category,
        _id: { $ne: id }
      });
      if (existingSubCategory) {
        throw new AppError(StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
      }
    }

    // Handle image upload if provided
    if (imageFile) {
      // Delete old image if it exists
      if (subCategory.image) {
        try {
          // Extract the file name from the URL
          const oldFileName = subCategory.image.split('/').pop();
          if (oldFileName) {
            await fileUploadService.deleteImage(
              config.supabase.buckets.subcategories,
              oldFileName
            );
          }
        } catch (error) {
          console.error('Error deleting old image:', error);
          // Continue with the update even if deleting old image fails
        }
      }

      // Upload new image
      const fileName = generateFileName(imageFile, `subcategory-${updateData.name || subCategory.name}`);
      const imageUrl = await fileUploadService.uploadImage(
        imageFile.buffer,
        config.supabase.buckets.subcategories,
        fileName
      );
      updateData.image = imageUrl;
    }

    const updatedSubCategory = await SubCategory.findByIdAndUpdate(
      id,
      { $set: updateData },
      { new: true, runValidators: true }
    ).populate('category', 'name');

    return updatedSubCategory!;
  }

  static async deleteSubCategory(id: string): Promise<void> {
    const subCategory = await SubCategory.findById(id);
    if (!subCategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'SubCategory not found');
    }

    // Delete image if it exists
    if (subCategory.image) {
      try {
        const fileName = subCategory.image.split('/').pop();
        if (fileName) {
          await fileUploadService.deleteImage(
            config.supabase.buckets.subcategories,
            fileName
          );
        }
      } catch (error) {
        console.error('Error deleting image:', error);
        // Continue with deletion even if image delete fails
      }
    }

    await SubCategory.findByIdAndDelete(id);
  }
} 