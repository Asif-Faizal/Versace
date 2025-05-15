"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SubCategoryService = void 0;
const SubCategory_1 = require("../models/SubCategory");
const Category_1 = require("../models/Category");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
class SubCategoryService {
    static async createSubCategory(subCategoryData) {
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
    static async updateSubCategory(id, updateData) {
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
                category: updateData.category,
                _id: { $ne: id }
            });
            if (existingSubCategory) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'SubCategory with this name already exists in this category');
            }
        }
        const subCategory = await SubCategory_1.SubCategory.findByIdAndUpdate(id, { $set: updateData }, { new: true, runValidators: true }).populate('category', 'name');
        if (!subCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'SubCategory not found');
        }
        return subCategory;
    }
    static async deleteSubCategory(id) {
        const subCategory = await SubCategory_1.SubCategory.findByIdAndDelete(id);
        if (!subCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'SubCategory not found');
        }
    }
}
exports.SubCategoryService = SubCategoryService;
