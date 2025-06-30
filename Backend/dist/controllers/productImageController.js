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
            // Check for files in the request
            if (!req.files || typeof req.files !== 'object') {
                console.error('No files were uploaded or files is not an object:', req.files);
                return res.status(statusCodes_1.StatusCodes.BAD_REQUEST).json({
                    error: 'No files were uploaded or invalid file format'
                });
            }
            // With multer's upload.fields(), files are organized by field name
            const filesObj = req.files;
            // Extract the files from the object
            const imageFiles = {
                main: filesObj.main && filesObj.main.length > 0 ? filesObj.main[0] : undefined,
                thumbnail: filesObj.thumbnail && filesObj.thumbnail.length > 0 ? filesObj.thumbnail[0] : undefined,
                detail1: filesObj.detail1 && filesObj.detail1.length > 0 ? filesObj.detail1[0] : undefined,
                detail2: filesObj.detail2 && filesObj.detail2.length > 0 ? filesObj.detail2[0] : undefined
            };
            // Log what we found for debugging
            console.log('Files received for upload:', Object.keys(filesObj));
            console.log('Files to process:', Object.keys(imageFiles).filter(key => !!imageFiles[key]));
            const productImages = await productImageService_1.ProductImageService.uploadVariantImages(productId, variantId, imageFiles);
            // Clear product cache
            await (0, cache_1.clearCache)(`products:${productId}`);
            await (0, cache_1.clearCache)('products:*');
            res.status(statusCodes_1.StatusCodes.OK).json(productImages);
        }
        catch (error) {
            console.error('Error uploading product images:', error);
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
