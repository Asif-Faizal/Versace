"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductImageService = void 0;
const Product_1 = require("../models/Product");
const errorHandler_1 = require("../middleware/errorHandler");
const statusCodes_1 = require("../utils/statusCodes");
const fileUploadService_1 = __importDefault(require("./fileUploadService"));
const config_1 = __importDefault(require("../config/config"));
const fileUpload_1 = require("../middleware/fileUpload");
class ProductImageService {
    /**
     * Upload images for a specific product variant combination
     * @param productId Product ID
     * @param variantCombinationId Variant combination ID
     * @param imageFiles Object containing image files (main, thumbnail, detail1, detail2)
     */
    static async uploadVariantImages(productId, variantCombinationId, imageFiles) {
        // Start with debugging information
        console.log(`Uploading images for product ${productId}, variant ${variantCombinationId}`);
        console.log('Image files received:', Object.keys(imageFiles).filter(key => !!imageFiles[key]));
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        // Find the variant combination
        const variantCombination = product.variantCombinations.find(vc => vc._id.toString() === variantCombinationId);
        if (!variantCombination) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Variant combination not found');
        }
        // Current images for the variant (if any)
        const currentImages = variantCombination.images || {};
        const updatedImages = {
            main: currentImages.main || '',
            thumbnail: currentImages.thumbnail || '',
            detail1: currentImages.detail1 || '',
            detail2: currentImages.detail2 || ''
        };
        // Upload each provided image
        for (const [imageType, file] of Object.entries(imageFiles)) {
            if (!file) {
                console.log(`No file provided for ${imageType}, skipping`);
                continue;
            }
            try {
                console.log(`Processing ${imageType} image: ${file.originalname}, size: ${file.size} bytes`);
                // Generate a unique name for the image
                const variant = variantCombination.variant || 'default';
                const color = variantCombination.color || 'default';
                const fileName = (0, fileUpload_1.generateFileName)(file, `product-${productId}-${variant}-${color}-${imageType}`);
                console.log(`Generated filename: ${fileName}`);
                // Delete existing image if there is one
                if (currentImages[imageType]) {
                    try {
                        const oldFileName = currentImages[imageType].split('/').pop();
                        if (oldFileName) {
                            console.log(`Deleting old image: ${oldFileName}`);
                            await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.products, oldFileName);
                        }
                    }
                    catch (error) {
                        console.error(`Error deleting old ${imageType} image:`, error);
                        // Continue with the upload even if deletion fails
                    }
                }
                // Upload the new image
                console.log(`Uploading to bucket: ${config_1.default.supabase.buckets.products}`);
                const imageUrl = await fileUploadService_1.default.uploadImage(file.buffer, config_1.default.supabase.buckets.products, fileName);
                console.log(`Upload successful, URL: ${imageUrl}`);
                // Update the image URL
                updatedImages[imageType] = imageUrl;
            }
            catch (error) {
                console.error(`Error processing ${imageType} image:`, error);
                // Continue with other images even if one fails
            }
        }
        console.log('Final image URLs:', updatedImages);
        // Update the product in the database
        await Product_1.Product.updateOne({ _id: productId, 'variantCombinations._id': variantCombinationId }, { $set: { 'variantCombinations.$.images': updatedImages } });
        console.log('Database updated successfully');
        return updatedImages;
    }
    /**
     * Delete all images for a specific product variant combination
     * @param productId Product ID
     * @param variantCombinationId Variant combination ID
     */
    static async deleteVariantImages(productId, variantCombinationId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        // Find the variant combination
        const variantCombination = product.variantCombinations.find(vc => vc._id.toString() === variantCombinationId);
        if (!variantCombination) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Variant combination not found');
        }
        // Delete all images from Supabase
        const images = variantCombination.images;
        if (!images)
            return;
        const imageTypes = ['main', 'thumbnail', 'detail1', 'detail2'];
        for (const imageType of imageTypes) {
            if (images[imageType]) {
                try {
                    const fileName = images[imageType].split('/').pop();
                    if (fileName) {
                        await fileUploadService_1.default.deleteImage(config_1.default.supabase.buckets.products, fileName);
                    }
                }
                catch (error) {
                    console.error(`Error deleting ${imageType} image:`, error);
                    // Continue with other deletions even if one fails
                }
            }
        }
        // Clear the images in the database
        await Product_1.Product.updateOne({ _id: productId, 'variantCombinations._id': variantCombinationId }, { $set: { 'variantCombinations.$.images': {} } });
    }
}
exports.ProductImageService = ProductImageService;
exports.default = ProductImageService;
