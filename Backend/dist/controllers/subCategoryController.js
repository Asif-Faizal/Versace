"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SubCategoryController = void 0;
const subCategoryService_1 = require("../services/subCategoryService");
const statusCodes_1 = require("../utils/statusCodes");
class SubCategoryController {
    static async createSubCategory(req, res, next) {
        try {
            const subCategory = await subCategoryService_1.SubCategoryService.createSubCategory(req.body);
            res.status(statusCodes_1.StatusCodes.CREATED).json(subCategory);
        }
        catch (error) {
            next(error);
        }
    }
    static async getSubCategory(req, res, next) {
        try {
            const subCategory = await subCategoryService_1.SubCategoryService.getSubCategoryById(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(subCategory);
        }
        catch (error) {
            next(error);
        }
    }
    static async getAllSubCategories(req, res, next) {
        try {
            const categoryId = req.query.categoryId;
            const subCategories = await subCategoryService_1.SubCategoryService.getAllSubCategories(categoryId);
            res.status(statusCodes_1.StatusCodes.OK).json(subCategories);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateSubCategory(req, res, next) {
        try {
            const subCategory = await subCategoryService_1.SubCategoryService.updateSubCategory(req.params.id, req.body);
            res.status(statusCodes_1.StatusCodes.OK).json(subCategory);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteSubCategory(req, res, next) {
        try {
            await subCategoryService_1.SubCategoryService.deleteSubCategory(req.params.id);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
}
exports.SubCategoryController = SubCategoryController;
