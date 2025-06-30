"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryService = void 0;
const Category_1 = require("../models/Category");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
const fileUploadService_1 = __importDefault(require("./fileUploadService"));
const config_1 = __importDefault(require("../config/config"));
const fileUpload_1 = require("../middleware/fileUpload");
class CategoryService {
    static async createCategory(categoryData, imageFile) {
        const existingCategory = await Category_1.Category.findOne({ name: categoryData.name });
        if (existingCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'Category with this name already exists');
        }
        // Handle image upload if provided
        if (imageFile) {
            const fileName = (0, fileUpload_1.generateFileName)(imageFile, `category-${categoryData.name}`);
            const imageUrl = await fileUploadService_1.default.uploadImage(imageFile.buffer, config_1.default.supabase.buckets.categories, fileName);
            categoryData.image = imageUrl;
        }
        const category = await Category_1.Category.create(categoryData);
        return category;
    }
    static async getCategoryById(id) {
        const category = await Category_1.Category.findById(id);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        return category;
    }
    static async getAllCategories() {
        return Category_1.Category.find().sort({ name: 1 });
    }
    static async updateCategory(id, updateData, imageFile) {
        const category = await Category_1.Category.findById(id);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        if (updateData.name) {
            const existingCategory = await Category_1.Category.findOne({
                name: updateData.name,
                _id: { $ne: id }
            });
            if (existingCategory) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'Category with this name already exists');
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
                        await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.categories, oldFileName);
                    }
                }
                catch (error) {
                    console.error('Error deleting old image:', error);
                    // Continue with the update even if deleting old image fails
                }
            }
            // Upload new image
            const fileName = (0, fileUpload_1.generateFileName)(imageFile, `category-${updateData.name || category.name}`);
            const imageUrl = await fileUploadService_1.default.uploadImage(imageFile.buffer, config_1.default.supabase.buckets.categories, fileName);
            updateData.image = imageUrl;
        }
        const updatedCategory = await Category_1.Category.findByIdAndUpdate(id, { $set: updateData }, { new: true, runValidators: true });
        return updatedCategory;
    }
    static async deleteCategory(id) {
        const category = await Category_1.Category.findById(id);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        // Delete image if it exists
        if (category.image) {
            try {
                const fileName = category.image.split('/').pop();
                if (fileName) {
                    await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.categories, fileName);
                }
            }
            catch (error) {
                console.error('Error deleting image:', error);
                // Continue with deletion even if image delete fails
            }
        }
        await Category_1.Category.findByIdAndDelete(id);
    }
}
exports.CategoryService = CategoryService;
