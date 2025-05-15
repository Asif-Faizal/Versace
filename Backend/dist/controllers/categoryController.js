"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CategoryController = void 0;
const categoryService_1 = require("../services/categoryService");
const statusCodes_1 = require("../utils/statusCodes");
const cache_1 = require("../middleware/cache");
class CategoryController {
    static async createCategory(req, res, next) {
        try {
            const category = await categoryService_1.CategoryService.createCategory(req.body);
            // Clear categories cache after creation
            await (0, cache_1.clearCache)('categories:*');
            // Also clear products cache as they may display category information
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.CREATED).json(category);
        }
        catch (error) {
            next(error);
        }
    }
    static async getCategory(req, res, next) {
        try {
            const category = await categoryService_1.CategoryService.getCategoryById(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(category);
        }
        catch (error) {
            next(error);
        }
    }
    static async getAllCategories(req, res, next) {
        try {
            const categories = await categoryService_1.CategoryService.getAllCategories();
            res.status(statusCodes_1.StatusCodes.OK).json(categories);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateCategory(req, res, next) {
        try {
            const category = await categoryService_1.CategoryService.updateCategory(req.params.id, req.body);
            // Clear categories cache after update
            await (0, cache_1.clearCache)('categories:*');
            // Also clear products cache as they may display category information
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.OK).json(category);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteCategory(req, res, next) {
        try {
            await categoryService_1.CategoryService.deleteCategory(req.params.id);
            // Clear categories cache after deletion
            await (0, cache_1.clearCache)('categories:*');
            // Also clear products cache as they may display category information
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
}
exports.CategoryController = CategoryController;
