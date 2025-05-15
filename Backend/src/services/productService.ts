import { Product, IProduct, IVariant } from '../models/Product';
import { Category } from '../models/Category';
import { SubCategory } from '../models/SubCategory';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import mongoose from 'mongoose';

interface PaginatedResponse<T> {
  products: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export class ProductService {
  static async createProduct(productData: Partial<IProduct>): Promise<IProduct> {
    // Verify category exists
    const category = await Category.findById(productData.category);
    if (!category) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
    }

    // Verify subcategory exists and belongs to the category
    const subcategory = await SubCategory.findOne({
      _id: productData.subcategory,
      category: productData.category
    });
    if (!subcategory) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Subcategory not found or does not belong to the specified category');
    }

    const product = await Product.create(productData);
    return product;
  }

  static async getProductById(id: string): Promise<IProduct> {
    const product = await Product.findById(id)
      .populate('category', 'name')
      .populate('subcategory', 'name');
    
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    return product;
  }

  static async getAllProducts(query: any = {}): Promise<PaginatedResponse<IProduct>> {
    const {
      page = 1,
      limit = 10,
      category,
      subcategory,
      minPrice,
      maxPrice,
      isNewProduct,
      isTrending,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = query;

    console.log('Raw query parameters:', query);
    console.log('Parsed parameters:', { minPrice, maxPrice, isNewProduct, isTrending });

    // Build filter object
    const filter: any = {};

    // Category and subcategory filters
    if (category) {
      filter.category = new mongoose.Types.ObjectId(category as string);
    }
    if (subcategory) {
      filter.subcategory = new mongoose.Types.ObjectId(subcategory as string);
    }

    // Price range filter
    if (minPrice || maxPrice) {
      filter.basePrice = {};
      if (minPrice) {
        filter.basePrice.$gte = parseFloat(minPrice as string);
      }
      if (maxPrice) {
        filter.basePrice.$lte = parseFloat(maxPrice as string);
      }
    }

    // Boolean filters
    if (isNewProduct === 'true') {
      filter.isNewProduct = true;
    } else if (isNewProduct === 'false') {
      filter.isNewProduct = false;
    }

    if (isTrending === 'true') {
      filter.isTrending = true;
    } else if (isTrending === 'false') {
      filter.isTrending = false;
    }

    // Text search
    if (search) {
      filter.$or = [
        { name: { $regex: search as string, $options: 'i' } },
        { description: { $regex: search as string, $options: 'i' } }
      ];
    }

    console.log('Final filter:', JSON.stringify(filter, null, 2));

    // Build sort object
    const sort: any = {};
    const validSortFields = ['createdAt', 'basePrice', 'rating', 'name'];
    const validSortOrders = ['asc', 'desc'];

    if (validSortFields.includes(sortBy as string) && validSortOrders.includes(sortOrder as string)) {
      sort[sortBy as string] = sortOrder === 'asc' ? 1 : -1;
    } else {
      sort.createdAt = -1; // Default sort
    }

    const skip = (Number(page) - 1) * Number(limit);

    try {
      const [products, total] = await Promise.all([
        Product.find(filter)
          .populate('category', 'name')
          .populate('subcategory', 'name')
          .sort(sort)
          .skip(skip)
          .limit(Number(limit)),
        Product.countDocuments(filter)
      ]);

      return {
        products,
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / Number(limit))
      };
    } catch (error) {
      if (error instanceof mongoose.Error.CastError) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Invalid filter parameters');
      }
      throw error;
    }
  }

  static async getProductsByCategory(categoryId: string): Promise<IProduct[]> {
    const products = await Product.find({ category: categoryId })
      .populate('category', 'name')
      .populate('subcategory', 'name');
    return products;
  }

  static async getProductsBySubCategory(subCategoryId: string): Promise<IProduct[]> {
    const products = await Product.find({ subcategory: subCategoryId })
      .populate('category', 'name')
      .populate('subcategory', 'name');
    return products;
  }

  static async updateProduct(id: string, updateData: Partial<IProduct>): Promise<IProduct> {
    const product = await Product.findById(id);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // If category is being updated, verify it exists
    if (updateData.category) {
      const category = await Category.findById(updateData.category);
      if (!category) {
        throw new AppError(StatusCodes.NOT_FOUND, 'Category not found');
      }
    }

    // If subcategory is being updated, verify it exists and belongs to the category
    if (updateData.subcategory) {
      const subcategory = await SubCategory.findOne({
        _id: updateData.subcategory,
        category: updateData.category || product.category
      });
      if (!subcategory) {
        throw new AppError(StatusCodes.NOT_FOUND, 'Subcategory not found or does not belong to the specified category');
      }
    }

    const updatedProduct = await Product.findByIdAndUpdate(
      id,
      { $set: updateData },
      { new: true, runValidators: true }
    ).populate('category', 'name').populate('subcategory', 'name');

    return updatedProduct!;
  }

  static async deleteProduct(id: string): Promise<void> {
    const product = await Product.findByIdAndDelete(id);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }
  }

  static async toggleWishlist(id: string): Promise<IProduct> {
    const product = await Product.findById(id);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    product.isInWishlist = !product.isInWishlist;
    await product.save();

    return product;
  }

  static async toggleCart(id: string): Promise<IProduct> {
    const product = await Product.findById(id);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    product.isInCart = !product.isInCart;
    await product.save();

    return product;
  }

  static async updateRating(id: string, rating: number): Promise<IProduct> {
    if (rating < 0 || rating > 5) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Rating must be between 0 and 5');
    }

    const product = await Product.findById(id);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    product.rating = rating;
    await product.save();

    return product;
  }

  static async getNewProducts(limit: number = 10): Promise<IProduct[]> {
    return Product.find({ isNewProduct: true })
      .populate('category', 'name')
      .populate('subcategory', 'name')
      .sort({ createdAt: -1 })
      .limit(limit);
  }

  static async getTrendingProducts(limit: number = 10): Promise<IProduct[]> {
    return Product.find({ isTrending: true })
      .populate('category', 'name')
      .populate('subcategory', 'name')
      .sort({ rating: -1 })
      .limit(limit);
  }

  static async addVariant(productId: string, variantData: Partial<IVariant>): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    product.variants.push(variantData as IVariant);
    await product.save();
    return product;
  }

  static async updateVariant(productId: string, variantId: string, updateData: Partial<IVariant>): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const variantIndex = product.variants.findIndex(
      (v) => v._id.toString() === variantId
    );

    if (variantIndex === -1) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant not found');
    }

    const updatedVariant = {
      ...product.variants[variantIndex].toObject(),
      ...updateData
    };

    product.variants[variantIndex] = updatedVariant as IVariant;
    await product.save();
    return product;
  }

  static async deleteVariant(productId: string, variantId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    product.variants = product.variants.filter(
      (v) => v._id.toString() !== variantId
    );

    await product.save();
    return product;
  }

  static async addToWishlist(productId: string, userId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const userIdObj = new mongoose.Types.ObjectId(userId);
    if (!product.wishlist.some(id => id.equals(userIdObj))) {
      product.wishlist.push(userIdObj);
      await product.save();
    }

    return product;
  }

  static async removeFromWishlist(productId: string, userId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const userIdObj = new mongoose.Types.ObjectId(userId);
    product.wishlist = product.wishlist.filter(id => !id.equals(userIdObj));
    await product.save();
    return product;
  }

  static async addToCart(productId: string, userId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const userIdObj = new mongoose.Types.ObjectId(userId);
    if (!product.cart.some(id => id.equals(userIdObj))) {
      product.cart.push(userIdObj);
      await product.save();
    }

    return product;
  }

  static async removeFromCart(productId: string, userId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const userIdObj = new mongoose.Types.ObjectId(userId);
    product.cart = product.cart.filter(id => !id.equals(userIdObj));
    await product.save();
    return product;
  }
} 