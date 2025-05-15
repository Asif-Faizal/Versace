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
            const { page, limit, minPrice, maxPrice, isNewProduct, isTrending, category, subcategory, search, sortBy, sortOrder } = req.query;
            const result = await productService_1.ProductService.getAllProducts({
                page,
                limit,
                minPrice,
                maxPrice,
                isNewProduct,
                isTrending,
                category,
                subcategory,
                search,
                sortBy,
                sortOrder
            });
            res.status(statusCodes_1.StatusCodes.OK).json(result);
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
    // Product attribute management methods
    static async addProductVariant(req, res, next) {
        try {
            const { variant } = req.body;
            if (!variant) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Variant name is required');
            }
            const product = await productService_1.ProductService.addProductVariant(req.params.id, variant);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async removeProductVariant(req, res, next) {
        try {
            const product = await productService_1.ProductService.removeProductVariant(req.params.id, req.params.variantName);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addProductColor(req, res, next) {
        try {
            const { color } = req.body;
            if (!color) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Color name is required');
            }
            const product = await productService_1.ProductService.addProductColor(req.params.id, color);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async removeProductColor(req, res, next) {
        try {
            const product = await productService_1.ProductService.removeProductColor(req.params.id, req.params.colorName);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addProductSize(req, res, next) {
        try {
            const { size } = req.body;
            if (!size) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Size name is required');
            }
            const product = await productService_1.ProductService.addProductSize(req.params.id, size);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async removeProductSize(req, res, next) {
        try {
            const product = await productService_1.ProductService.removeProductSize(req.params.id, req.params.sizeName);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    // Variant combination methods
    static async addVariantCombination(req, res, next) {
        try {
            const combination = req.body;
            const product = await productService_1.ProductService.addVariantCombination(req.params.id, combination);
            res.status(statusCodes_1.StatusCodes.CREATED).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async updateVariantCombination(req, res, next) {
        try {
            const combination = req.body;
            const product = await productService_1.ProductService.updateVariantCombination(req.params.id, req.params.combinationId, combination);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteVariantCombination(req, res, next) {
        try {
            const product = await productService_1.ProductService.deleteVariantCombination(req.params.id, req.params.combinationId);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteMultipleVariantCombinations(req, res, next) {
        try {
            const { combinationIds } = req.body;
            if (!Array.isArray(combinationIds) || combinationIds.length === 0) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Valid combinationIds array is required');
            }
            const product = await productService_1.ProductService.deleteMultipleVariantCombinations(req.params.id, combinationIds);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async getVariantCombinations(req, res, next) {
        try {
            const product = await productService_1.ProductService.getProductById(req.params.id);
            res.status(statusCodes_1.StatusCodes.OK).json(product.variantCombinations);
        }
        catch (error) {
            next(error);
        }
    }
    // Bulk operations for product attributes
    static async addMultipleProductVariants(req, res, next) {
        try {
            const { variants } = req.body;
            if (!Array.isArray(variants) || variants.length === 0) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Variants array is required');
            }
            const product = await productService_1.ProductService.addMultipleProductVariants(req.params.id, variants);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addMultipleProductColors(req, res, next) {
        try {
            const { colors } = req.body;
            if (!Array.isArray(colors) || colors.length === 0) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Colors array is required');
            }
            const product = await productService_1.ProductService.addMultipleProductColors(req.params.id, colors);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addMultipleProductSizes(req, res, next) {
        try {
            const { sizes } = req.body;
            if (!Array.isArray(sizes) || sizes.length === 0) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Sizes array is required');
            }
            const product = await productService_1.ProductService.addMultipleProductSizes(req.params.id, sizes);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async addMultipleVariantCombinations(req, res, next) {
        try {
            const { combinations } = req.body;
            if (!Array.isArray(combinations) || combinations.length === 0) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Valid combinations array is required');
            }
            const product = await productService_1.ProductService.addMultipleVariantCombinations(req.params.id, combinations);
            res.status(statusCodes_1.StatusCodes.CREATED).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteVariant(req, res, next) {
        try {
            const { id } = req.params;
            const { variant } = req.body;
            if (!variant) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Variant name is required');
            }
            const product = await productService_1.ProductService.deleteVariant(id, variant);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteColor(req, res, next) {
        try {
            const { id } = req.params;
            const { color } = req.body;
            if (!color) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Color name is required');
            }
            const product = await productService_1.ProductService.deleteColor(id, color);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteSize(req, res, next) {
        try {
            const { id } = req.params;
            const { size } = req.body;
            if (!size) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Size name is required');
            }
            const product = await productService_1.ProductService.deleteSize(id, size);
            res.status(statusCodes_1.StatusCodes.OK).json(product);
        }
        catch (error) {
            next(error);
        }
    }
}
exports.ProductController = ProductController;
