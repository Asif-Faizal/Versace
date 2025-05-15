"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryService = void 0;
const Category_1 = require("../models/Category");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
class CategoryService {
    static async createCategory(categoryData) {
        const existingCategory = await Category_1.Category.findOne({ name: categoryData.name });
        if (existingCategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'Category with this name already exists');
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
    static async updateCategory(id, updateData) {
        if (updateData.name) {
            const existingCategory = await Category_1.Category.findOne({
                name: updateData.name,
                _id: { $ne: id }
            });
            if (existingCategory) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'Category with this name already exists');
            }
        }
        const category = await Category_1.Category.findByIdAndUpdate(id, { $set: updateData }, { new: true, runValidators: true });
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        return category;
    }
    static async deleteCategory(id) {
        const category = await Category_1.Category.findByIdAndDelete(id);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
    }
}
exports.CategoryService = CategoryService;
