import { Category, ICategory } from '../models/Category';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import fileUploadService from './fileUploadService';
import config from '../config/config';
import { generateFileName } from '../middleware/fileUpload';

export class CategoryService {
  static async createCategory(categoryData: Partial<ICategory>, imageFile?: Express.Multer.File): Promise<ICategory> {
    const existingCategory = await Category.findOne({ name: categoryData.name });
    if (existingCategory) {
      throw new AppError(StatusCodes.CONFLICT, 'Category with this name already exists');
    }

    // Handle image upload if provided
    if (imageFile) {
      const fileName = generateFileName(imageFile, `category-${categoryData.name}`);
      const imageUrl = await fileUploadService.uploadImage(
        imageFile.buffer,
        config.supabase.buckets.categories,
        fileName
      );
      categoryData.image = imageUrl;
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

  static async updateCategory(
    id: string, 
    updateData: Partial<ICategory>, 
    imageFile?: Express.Multer.File
  ): Promise<ICategory> {
    const category = await Category.findById(id);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }

    if (updateData.name) {
      const existingCategory = await Category.findOne({ 
        name: updateData.name,
        _id: { $ne: id }
      });
      if (existingCategory) {
        throw new AppError(StatusCodes.CONFLICT, 'Category with this name already exists');
      }
    }

    // Handle image upload if provided
    if (imageFile) {
      // Delete old image if it exists
      if (category.image) {
        try {
          // Extract the file name from the URL
          const oldFileName = category.image.split('/').pop();
          if (oldFileName) {
            await fileUploadService.deleteImage(
              config.supabase.buckets.categories,
              oldFileName
            );
          }
        } catch (error) {
          console.error('Error deleting old image:', error);
          // Continue with the update even if deleting old image fails
        }
      }

      // Upload new image
      const fileName = generateFileName(imageFile, `category-${updateData.name || category.name}`);
      const imageUrl = await fileUploadService.uploadImage(
        imageFile.buffer,
        config.supabase.buckets.categories,
        fileName
      );
      updateData.image = imageUrl;
    }

    const updatedCategory = await Category.findByIdAndUpdate(
      id,
      { $set: updateData },
      { new: true, runValidators: true }
    );

    return updatedCategory!;
  }

  static async deleteCategory(id: string): Promise<void> {
    const category = await Category.findById(id);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }

    // Delete image if it exists
    if (category.image) {
      try {
        const fileName = category.image.split('/').pop();
        if (fileName) {
          await fileUploadService.deleteImage(
            config.supabase.buckets.categories,
            fileName
          );
        }
      } catch (error) {
        console.error('Error deleting image:', error);
        // Continue with deletion even if image delete fails
      }
    }

    await Category.findByIdAndDelete(id);
  }
}