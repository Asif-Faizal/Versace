"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductService = void 0;
const Product_1 = require("../models/Product");
const Category_1 = require("../models/Category");
const SubCategory_1 = require("../models/SubCategory");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
const mongoose_1 = __importDefault(require("mongoose"));
class ProductService {
    static async createProduct(productData) {
        // Verify category exists
        const category = await Category_1.Category.findById(productData.category);
        if (!category) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
        }
        // Verify subcategory exists and belongs to the category
        const subcategory = await SubCategory_1.SubCategory.findOne({
            _id: productData.subcategory,
            category: productData.category
        });
        if (!subcategory) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Subcategory not found or does not belong to the specified category');
        }
        const product = await Product_1.Product.create(productData);
        return product;
    }
    static async getProductById(id) {
        const product = await Product_1.Product.findById(id)
            .populate('category', 'name')
            .populate('subcategory', 'name');
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        return product;
    }
    static async getAllProducts(query = {}) {
        const { page = 1, limit = 10, category, subcategory, minPrice, maxPrice, isNewProduct, isTrending, search, sortBy = 'createdAt', sortOrder = 'desc' } = query;
        console.log('Raw query parameters:', query);
        console.log('Parsed parameters:', { minPrice, maxPrice, isNewProduct, isTrending });
        // Build filter object
        const filter = {};
        // Category and subcategory filters
        if (category) {
            filter.category = new mongoose_1.default.Types.ObjectId(category);
        }
        if (subcategory) {
            filter.subcategory = new mongoose_1.default.Types.ObjectId(subcategory);
        }
        // Price range filter
        if (minPrice || maxPrice) {
            filter.basePrice = {};
            if (minPrice) {
                filter.basePrice.$gte = parseFloat(minPrice);
            }
            if (maxPrice) {
                filter.basePrice.$lte = parseFloat(maxPrice);
            }
        }
        // Boolean filters
        if (isNewProduct === 'true') {
            filter.isNewProduct = true;
        }
        else if (isNewProduct === 'false') {
            filter.isNewProduct = false;
        }
        if (isTrending === 'true') {
            filter.isTrending = true;
        }
        else if (isTrending === 'false') {
            filter.isTrending = false;
        }
        // Text search
        if (search) {
            filter.$or = [
                { name: { $regex: search, $options: 'i' } },
                { description: { $regex: search, $options: 'i' } }
            ];
        }
        console.log('Final filter:', JSON.stringify(filter, null, 2));
        // Build sort object
        const sort = {};
        const validSortFields = ['createdAt', 'basePrice', 'rating', 'name'];
        const validSortOrders = ['asc', 'desc'];
        if (validSortFields.includes(sortBy) && validSortOrders.includes(sortOrder)) {
            sort[sortBy] = sortOrder === 'asc' ? 1 : -1;
        }
        else {
            sort.createdAt = -1; // Default sort
        }
        const skip = (Number(page) - 1) * Number(limit);
        try {
            const [products, total] = await Promise.all([
                Product_1.Product.find(filter)
                    .populate('category', 'name')
                    .populate('subcategory', 'name')
                    .sort(sort)
                    .skip(skip)
                    .limit(Number(limit)),
                Product_1.Product.countDocuments(filter)
            ]);
            return {
                products,
                total,
                page: Number(page),
                limit: Number(limit),
                totalPages: Math.ceil(total / Number(limit))
            };
        }
        catch (error) {
            if (error instanceof mongoose_1.default.Error.CastError) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Invalid filter parameters');
            }
            throw error;
        }
    }
    static async getProductsByCategory(categoryId) {
        const products = await Product_1.Product.find({ category: categoryId })
            .populate('category', 'name')
            .populate('subcategory', 'name');
        return products;
    }
    static async getProductsBySubCategory(subCategoryId) {
        const products = await Product_1.Product.find({ subcategory: subCategoryId })
            .populate('category', 'name')
            .populate('subcategory', 'name');
        return products;
    }
    static async updateProduct(id, updateData) {
        const product = await Product_1.Product.findById(id);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        // If category is being updated, verify it exists
        if (updateData.category) {
            const category = await Category_1.Category.findById(updateData.category);
            if (!category) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Category not found');
            }
        }
        // If subcategory is being updated, verify it exists and belongs to the category
        if (updateData.subcategory) {
            const subcategory = await SubCategory_1.SubCategory.findOne({
                _id: updateData.subcategory,
                category: updateData.category || product.category
            });
            if (!subcategory) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Subcategory not found or does not belong to the specified category');
            }
        }
        const updatedProduct = await Product_1.Product.findByIdAndUpdate(id, { $set: updateData }, { new: true, runValidators: true }).populate('category', 'name').populate('subcategory', 'name');
        return updatedProduct;
    }
    static async deleteProduct(id) {
        const product = await Product_1.Product.findByIdAndDelete(id);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
    }
    static async toggleWishlist(id) {
        const product = await Product_1.Product.findById(id);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        product.isInWishlist = !product.isInWishlist;
        await product.save();
        return product;
    }
    static async toggleCart(id) {
        const product = await Product_1.Product.findById(id);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        product.isInCart = !product.isInCart;
        await product.save();
        return product;
    }
    static async updateRating(id, rating) {
        if (rating < 0 || rating > 5) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Rating must be between 0 and 5');
        }
        const product = await Product_1.Product.findById(id);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        product.rating = rating;
        await product.save();
        return product;
    }
    static async getNewProducts(limit = 10) {
        return Product_1.Product.find({ isNewProduct: true })
            .populate('category', 'name')
            .populate('subcategory', 'name')
            .sort({ createdAt: -1 })
            .limit(limit);
    }
    static async getTrendingProducts(limit = 10) {
        return Product_1.Product.find({ isTrending: true })
            .populate('category', 'name')
            .populate('subcategory', 'name')
            .sort({ rating: -1 })
            .limit(limit);
    }
    static async addVariant(productId, variantData) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        product.variants.push(variantData);
        await product.save();
        return product;
    }
    static async updateVariant(productId, variantId, updateData) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        const variantIndex = product.variants.findIndex((v) => v._id.toString() === variantId);
        if (variantIndex === -1) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Variant not found');
        }
        const updatedVariant = {
            ...product.variants[variantIndex].toObject(),
            ...updateData
        };
        product.variants[variantIndex] = updatedVariant;
        await product.save();
        return product;
    }
    static async deleteVariant(productId, variantId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        product.variants = product.variants.filter((v) => v._id.toString() !== variantId);
        await product.save();
        return product;
    }
    static async addToWishlist(productId, userId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        const userIdObj = new mongoose_1.default.Types.ObjectId(userId);
        if (!product.wishlist.some(id => id.equals(userIdObj))) {
            product.wishlist.push(userIdObj);
            await product.save();
        }
        return product;
    }
    static async removeFromWishlist(productId, userId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        const userIdObj = new mongoose_1.default.Types.ObjectId(userId);
        product.wishlist = product.wishlist.filter(id => !id.equals(userIdObj));
        await product.save();
        return product;
    }
    static async addToCart(productId, userId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        const userIdObj = new mongoose_1.default.Types.ObjectId(userId);
        if (!product.cart.some(id => id.equals(userIdObj))) {
            product.cart.push(userIdObj);
            await product.save();
        }
        return product;
    }
    static async removeFromCart(productId, userId) {
        const product = await Product_1.Product.findById(productId);
        if (!product) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'Product not found');
        }
        const userIdObj = new mongoose_1.default.Types.ObjectId(userId);
        product.cart = product.cart.filter(id => !id.equals(userIdObj));
        await product.save();
        return product;
    }
}
exports.ProductService = ProductService;
