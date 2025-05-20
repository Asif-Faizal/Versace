"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductImageController = void 0;
const productImageService_1 = require("../services/productImageService");
const statusCodes_1 = require("../utils/statusCodes");
const cache_1 = require("../middleware/cache");
class ProductImageController {
    /**
     * Upload images for a specific product variant combination
     */
    static async uploadVariantImages(req, res, next) {
        try {
            const { productId, variantId } = req.params;
            // Get uploaded files from multer
            const files = {
                main: req.files && Array.isArray(req.files) ?
                    req.files.find(file => file.fieldname === 'main') : undefined,
                thumbnail: req.files && Array.isArray(req.files) ?
                    req.files.find(file => file.fieldname === 'thumbnail') : undefined,
                detail1: req.files && Array.isArray(req.files) ?
                    req.files.find(file => file.fieldname === 'detail1') : undefined,
                detail2: req.files && Array.isArray(req.files) ?
                    req.files.find(file => file.fieldname === 'detail2') : undefined
            };
            // Convert from object of files to object expected by service
            const imageFiles = {
                main: files.main,
                thumbnail: files.thumbnail,
                detail1: files.detail1,
                detail2: files.detail2
            };
            const productImages = await productImageService_1.ProductImageService.uploadVariantImages(productId, variantId, imageFiles);
            // Clear product cache
            await (0, cache_1.clearCache)(`products:${productId}`);
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.OK).json(productImages);
        }
        catch (error) {
            next(error);
        }
    }
    /**
     * Delete all images for a specific product variant combination
     */
    static async deleteVariantImages(req, res, next) {
        try {
            const { productId, variantId } = req.params;
            await productImageService_1.ProductImageService.deleteVariantImages(productId, variantId);
            // Clear product cache
            await (0, cache_1.clearCache)(`products:${productId}`);
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
}
exports.ProductImageController = ProductImageController;
