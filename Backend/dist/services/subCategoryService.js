"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SubCategoryService = void 0;
const SubCategory_1 = require("../models/SubCategory");
const Category_1 = require("../models/Category");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
const fileUploadService_1 = __importDefault(require("./fileUploadService"));
const config_1 = __importDefault(require("../config/config"));
const fileUpload_1 = require("../middleware/fileUpload");
class SubCategoryService {
    static async createSubCategory(subCategoryData, imageFile) {
        // Verify category exists
        const category = await Category_1.Category.findById(subCategoryData.category);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        // Check if subcategory with same name exists in the category
        const existingSubCategory = await SubCategory_1.SubCategory.findOne({
            name: subCategoryData.name,
            category: subCategoryData.category
        });
        if (existingSubCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
        }
        // Handle image upload if provided
        if (imageFile) {
            const fileName = (0, fileUpload_1.generateFileName)(imageFile, `subcategory-${subCategoryData.name}`);
            const imageUrl = await fileUploadService_1.default.uploadImage(imageFile.buffer, config_1.default.supabase.buckets.subcategories, fileName);
            subCategoryData.image = imageUrl;
        }
        const subCategory = await SubCategory_1.SubCategory.create(subCategoryData);
        return subCategory;
    }
    static async getSubCategoryById(id) {
        const subCategory = await SubCategory_1.SubCategory.findById(id).populate('category', 'name');
        if (!subCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'SubCategory not found');
        }
        return subCategory;
    }
    static async getAllSubCategories(categoryId) {
        const query = categoryId ? { category: categoryId } : {};
        return SubCategory_1.SubCategory.find(query)
            .populate('category', 'name')
            .sort({ name: 1 });
    }
    static async updateSubCategory(id, updateData, imageFile) {
        const subCategory = await SubCategory_1.SubCategory.findById(id);
        if (!subCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'SubCategory not found');
        }
        // If category is being updated, verify it exists
        if (updateData.category) {
            const category = await Category_1.Category.findById(updateData.category);
            if (!category) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
            }
        }
        // Check for name conflict if name is being updated
        if (updateData.name) {
            const existingSubCategory = await SubCategory_1.SubCategory.findOne({
                name: updateData.name,
                category: updateData.category || subCategory.category,
                _id: { $ne: id }
            });
            if (existingSubCategory) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
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
                        await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.subcategories, oldFileName);
                    }
                }
                catch (error) {
                    console.error('Error deleting old image:', error);
                    // Continue with the update even if deleting old image fails
                }
            }
            // Upload new image
            const fileName = (0, fileUpload_1.generateFileName)(imageFile, `subcategory-${updateData.name || subCategory.name}`);
            const imageUrl = await fileUploadService_1.default.uploadImage(imageFile.buffer, config_1.default.supabase.buckets.subcategories, fileName);
            updateData.image = imageUrl;
        }
        const updatedSubCategory = await SubCategory_1.SubCategory.findByIdAndUpdate(id, { $set: updateData }, { new: true, runValidators: true }).populate('category', 'name');
        return updatedSubCategory;
    }
    static async deleteSubCategory(id) {
        const subCategory = await SubCategory_1.SubCategory.findById(id);
        if (!subCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'SubCategory not found');
        }
        // Delete image if it exists
        if (subCategory.image) {
            try {
                const fileName = subCategory.image.split('/').pop();
                if (fileName) {
                    await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.subcategories, fileName);
                }
            }
            catch (error) {
                console.error('Error deleting image:', error);
                // Continue with deletion even if image delete fails
            }
        }
        await SubCategory_1.SubCategory.findByIdAndDelete(id);
    }
}
exports.SubCategoryService = SubCategoryService;
