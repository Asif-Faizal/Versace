"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductController = void 0;
const productService_1 = require("../services/productService");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
class ProductController {
    static async createProduct(req, res, next) {
        try {
            const product = await productService_1.ProductService.createProduct(req.body);
            res.status(statusCodes_1.StatusCodes.CREATED).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async getProduct(req, res, next) {
        try {
            const product = await productService_1.ProductService.getProductById(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async getAllProducts(req, res, next) {
        try {
            const products = await productService_1.ProductService.getAllProducts();
            res.status(statusCodes_1.StatusCodes.OK).json(products);
        }
        catch (error) {
            next(error);
        }
    }
    static async getProductsByCategory(req, res, next) {
        try {
            const products = await productService_1.ProductService.getProductsByCategory(req.params.categoryId);
            res.status(statusCodes_1.StatusCodes.OK).json(products);
        }
        catch (error) {
            next(error);
        }
    }
    static async getProductsBySubCategory(req, res, next) {
        try {
            const products = await productService_1.ProductService.getProductsBySubCategory(req.params.subCategoryId);
            res.status(statusCodes_1.StatusCodes.OK).json(products);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateProduct(req, res, next) {
        try {
            const product = await productService_1.ProductService.updateProduct(req.params.id, req.body);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteProduct(req, res, next) {
        try {
            await productService_1.ProductService.deleteProduct(req.params.id);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
    static async addVariant(req, res, next) {
        try {
            const product = await productService_1.ProductService.addVariant(req.params.id, req.body);
            res.status(statusCodes_1.StatusCodes.CREATED).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateVariant(req, res, next) {
        try {
            const product = await productService_1.ProductService.updateVariant(req.params.id, req.params.variantId, req.body);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteVariant(req, res, next) {
        try {
            const product = await productService_1.ProductService.deleteVariant(req.params.id, req.params.variantId);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addToWishlist(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const product = await productService_1.ProductService.addToWishlist(req.params.id, req.user._id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async removeFromWishlist(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const product = await productService_1.ProductService.removeFromWishlist(req.params.id, req.user._id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addToCart(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const product = await productService_1.ProductService.addToCart(req.params.id, req.user._id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async removeFromCart(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const product = await productService_1.ProductService.removeFromCart(req.params.id, req.user._id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async toggleWishlist(req, res, next) {
        try {
            const product = await productService_1.ProductService.toggleWishlist(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async toggleCart(req, res, next) {
        try {
            const product = await productService_1.ProductService.toggleCart(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateRating(req, res, next) {
        try {
            const { rating } = req.body;
            if (typeof rating !== 'number') {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Rating must be a number');
            }
            const product = await productService_1.ProductService.updateRating(req.params.id, rating);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async getNewProducts(req, res, next) {
        try {
            const limit = parseInt(req.query.limit) || 10;
            const products = await productService_1.ProductService.getNewProducts(limit);
            res.status(statusCodes_1.StatusCodes.OK).json(products);
        }
        catch (error) {
            next(error);
        }
    }
    static async getTrendingProducts(req, res, next) {
        try {
            const limit = parseInt(req.query.limit) || 10;
            const products = await productService_1.ProductService.getTrendingProducts(limit);
            res.status(statusCodes_1.StatusCodes.OK).json(products);
        }
        catch (error) {
            next(error);
        }
    }
}
exports.ProductController = ProductController;
