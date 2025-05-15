import { Product, IProduct, IVariantCombination} from '../models/Product';
import { Category } from '../models/Category';
import { SubCategory } from '../models/SubCategory';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import mongoose from 'mongoose';
import { CartItem, ICartItem } from '../models/CartItem';

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

  static async addToWishlist(productId: string, userId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const userIdObj = new mongoose.Types.ObjectId(userId);
    if (product.wishlist.some(id => id.equals(userIdObj))) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Product is already in wishlist');
    }

    product.wishlist.push(userIdObj);
    await product.save();
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

  static async addToCart(
    productId: string, 
    userId: string, 
    variantCombinationId: string,
    quantity: number = 1
  ): Promise<ICartItem> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Find the variant combination
    const combination = product.variantCombinations.find(
      combo => combo._id.toString() === variantCombinationId
    );

    if (!combination) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Invalid variant combination');
    }

    if (combination.stock < quantity) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Insufficient stock');
    }

    // Check if the same variant combination is already in cart
    const existingCartItem = await CartItem.findOne({
      user: userId,
      product: productId,
      variantCombinationId: new mongoose.Types.ObjectId(variantCombinationId)
    });

    if (existingCartItem) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'This product variant is already in your cart');
    }

    // Calculate total price
    const totalPrice = (product.basePrice + combination.additionalPrice) * quantity;

    // Create cart item
    const cartItem = await CartItem.create({
      user: userId,
      product: productId,
      variantCombinationId: new mongoose.Types.ObjectId(variantCombinationId),
      quantity,
      price: totalPrice
    });

    return cartItem;
  }

  static async removeFromCart(
    productId: string, 
    userId: string,
    variantCombinationId: string
  ): Promise<void> {
    const result = await CartItem.deleteOne({
      user: userId,
      product: productId,
      variantCombinationId: new mongoose.Types.ObjectId(variantCombinationId)
    });

    if (result.deletedCount === 0) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Cart item not found');
    }
  }

  static async clearCart(userId: string): Promise<void> {
    const result = await CartItem.deleteMany({ user: userId });
    if (result.deletedCount === 0) {
      throw new AppError(StatusCodes.NOT_FOUND, 'No items found in cart');
    }
  }

  static async getCartItems(userId: string): Promise<ICartItem[]> {
    return CartItem.find({ user: userId })
      .populate({
        path: 'product',
        select: 'name basePrice images',
        populate: {
          path: 'variantCombinations',
          match: { _id: { $eq: '$variantCombinationId' } },
          select: 'variant color size additionalPrice stock'
        }
      })
      .select('quantity price variantCombinationId')
      .sort({ createdAt: -1 });
  }

  static async getWishlistItems(userId: string): Promise<IProduct[]> {
    return Product.find({ wishlist: userId })
      .populate('category', 'name')
      .populate('subcategory', 'name')
      .sort({ createdAt: -1 });
  }

  // Product attribute management methods
  static async addProductVariant(productId: string, variant: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    if (product.variants.includes(variant)) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Variant already exists');
    }

    product.variants.push(variant);
    await product.save();
    return product;
  }

  static async removeProductVariant(productId: string, variantName: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if variant is used in any combination
    const variantInUse = product.variantCombinations.some(combo => combo.variant === variantName);
    if (variantInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST, 
        'Cannot remove variant because it is used in at least one variant combination'
      );
    }

    product.variants = product.variants.filter(v => v !== variantName);
    await product.save();
    return product;
  }

  static async addProductColor(productId: string, color: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    if (product.colors.includes(color)) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Color already exists');
    }

    product.colors.push(color);
    await product.save();
    return product;
  }

  static async removeProductColor(productId: string, colorName: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if color is used in any combination
    const colorInUse = product.variantCombinations.some(combo => combo.color === colorName);
    if (colorInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST, 
        'Cannot remove color because it is used in at least one variant combination'
      );
    }

    product.colors = product.colors.filter(c => c !== colorName);
    await product.save();
    return product;
  }

  static async addProductSize(productId: string, size: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    if (product.sizes.includes(size)) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Size already exists');
    }

    product.sizes.push(size);
    await product.save();
    return product;
  }

  static async removeProductSize(productId: string, sizeName: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if size is used in any combination
    const sizeInUse = product.variantCombinations.some(combo => combo.size === sizeName);
    if (sizeInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST, 
        'Cannot remove size because it is used in at least one variant combination'
      );
    }

    product.sizes = product.sizes.filter(s => s !== sizeName);
    await product.save();
    return product;
  }

  // Variant combination methods
  static async addVariantCombination(productId: string, combinationData: Partial<IVariantCombination>): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Process indices to populate variant, color and size
    if (combinationData.variantIndex !== undefined) {
      if (combinationData.variantIndex < 0 || combinationData.variantIndex >= product.variants.length) {
        throw new AppError(StatusCodes.BAD_REQUEST, `Invalid variant index: ${combinationData.variantIndex}`);
      }
      combinationData.variant = product.variants[combinationData.variantIndex];
    }

    if (combinationData.colorIndex !== undefined) {
      if (combinationData.colorIndex < 0 || combinationData.colorIndex >= product.colors.length) {
        throw new AppError(StatusCodes.BAD_REQUEST, `Invalid color index: ${combinationData.colorIndex}`);
      }
      combinationData.color = product.colors[combinationData.colorIndex];
    }

    if (combinationData.sizeIndex !== undefined) {
      if (combinationData.sizeIndex < 0 || combinationData.sizeIndex >= product.sizes.length) {
        throw new AppError(StatusCodes.BAD_REQUEST, `Invalid size index: ${combinationData.sizeIndex}`);
      }
      combinationData.size = product.sizes[combinationData.sizeIndex];
    }

    // Validate variant, color, and size existence
    if (combinationData.variant && !product.variants.includes(combinationData.variant)) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Variant "${combinationData.variant}" does not exist in this product`);
    }

    if (combinationData.color && !product.colors.includes(combinationData.color)) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Color "${combinationData.color}" does not exist in this product`);
    }

    if (combinationData.size && !product.sizes.includes(combinationData.size)) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Size "${combinationData.size}" does not exist in this product`);
    }

    // Check for duplicate combination
    const existingCombination = product.variantCombinations.find(
      c => c.variant === (combinationData.variant || null) &&
           c.color === (combinationData.color || null) &&
           c.size === (combinationData.size || null)
    );

    if (existingCombination) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'This variant combination already exists');
    }

    // Ensure required fields
    if (!combinationData.additionalPrice && combinationData.additionalPrice !== 0) {
      combinationData.additionalPrice = 0;
    }

    if (!combinationData.stock && combinationData.stock !== 0) {
      combinationData.stock = 0;
    }

    product.variantCombinations.push(combinationData as IVariantCombination);
    await product.save();
    return product;
  }

  static async updateVariantCombination(
    productId: string, 
    combinationId: string, 
    updateData: Partial<IVariantCombination>
  ): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const combinationIndex = product.variantCombinations.findIndex(
      c => c._id.toString() === combinationId
    );

    if (combinationIndex === -1) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant combination not found');
    }

    // Validate variant, color, and size if they are being updated
    if (
      updateData.variant && 
      updateData.variant !== product.variantCombinations[combinationIndex].variant && 
      !product.variants.includes(updateData.variant)
    ) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Variant "${updateData.variant}" does not exist in this product`);
    }

    if (
      updateData.color && 
      updateData.color !== product.variantCombinations[combinationIndex].color && 
      !product.colors.includes(updateData.color)
    ) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Color "${updateData.color}" does not exist in this product`);
    }

    if (
      updateData.size && 
      updateData.size !== product.variantCombinations[combinationIndex].size && 
      !product.sizes.includes(updateData.size)
    ) {
      throw new AppError(StatusCodes.BAD_REQUEST, `Size "${updateData.size}" does not exist in this product`);
    }

    // Check for duplicate combination
    if (updateData.variant !== undefined || updateData.color !== undefined || updateData.size !== undefined) {
      const newVariant = updateData.variant !== undefined ? updateData.variant : product.variantCombinations[combinationIndex].variant;
      const newColor = updateData.color !== undefined ? updateData.color : product.variantCombinations[combinationIndex].color;
      const newSize = updateData.size !== undefined ? updateData.size : product.variantCombinations[combinationIndex].size;

      const duplicateExists = product.variantCombinations.some((c, index) => 
        index !== combinationIndex &&
        c.variant === newVariant &&
        c.color === newColor &&
        c.size === newSize
      );

      if (duplicateExists) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'This variant combination already exists');
      }
    }

    // Update the combination
    const updatedCombination = {
      ...product.variantCombinations[combinationIndex].toObject(),
      ...updateData
    };

    product.variantCombinations[combinationIndex] = updatedCombination as IVariantCombination;
    await product.save();
    return product;
  }

  static async deleteVariantCombination(productId: string, combinationId: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    const combinationExists = product.variantCombinations.some(
      c => c._id.toString() === combinationId
    );

    if (!combinationExists) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant combination not found');
    }

    product.variantCombinations = product.variantCombinations.filter(
      c => c._id.toString() !== combinationId
    );

    await product.save();
    return product;
  }

  // Delete multiple variant combinations at once
  static async deleteMultipleVariantCombinations(productId: string, combinationIds: string[]): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    if (!Array.isArray(combinationIds) || combinationIds.length === 0) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Valid combination IDs array is required');
    }

    const notFoundIds: string[] = [];
    const deletedIds: string[] = [];

    // Check which IDs exist
    for (const id of combinationIds) {
      const exists = product.variantCombinations.some(c => c._id.toString() === id);
      if (exists) {
        deletedIds.push(id);
      } else {
        notFoundIds.push(id);
      }
    }

    if (deletedIds.length === 0) {
      throw new AppError(StatusCodes.NOT_FOUND, 'None of the specified combinations were found');
    }

    // Filter out the combinations to delete
    product.variantCombinations = product.variantCombinations.filter(
      c => !deletedIds.includes(c._id.toString())
    );

    await product.save();

    // Return warnings if some combinations weren't found
    if (notFoundIds.length > 0) {
      return {
        ...product.toObject(),
        warnings: [`The following combinations were not found: ${notFoundIds.join(', ')}`]
      } as any;
    }

    return product;
  }

  // Create multiple variant combinations at once
  static async addMultipleVariantCombinations(productId: string, combinations: Array<Partial<IVariantCombination>>): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    if (!Array.isArray(combinations) || combinations.length === 0) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Valid combinations array is required');
    }

    const validCombinations: Partial<IVariantCombination>[] = [];
    const errors: string[] = [];

    // Validate all combinations first
    for (const [index, combo] of combinations.entries()) {
      try {
        // Process indices to set variants, colors, and sizes
        if (combo.variantIndex !== undefined) {
          if (combo.variantIndex < 0 || combo.variantIndex >= product.variants.length) {
            errors.push(`Combination ${index+1}: Invalid variant index: ${combo.variantIndex}`);
            continue;
          }
          combo.variant = product.variants[combo.variantIndex];
        }

        if (combo.colorIndex !== undefined) {
          if (combo.colorIndex < 0 || combo.colorIndex >= product.colors.length) {
            errors.push(`Combination ${index+1}: Invalid color index: ${combo.colorIndex}`);
            continue;
          }
          combo.color = product.colors[combo.colorIndex];
        }

        if (combo.sizeIndex !== undefined) {
          if (combo.sizeIndex < 0 || combo.sizeIndex >= product.sizes.length) {
            errors.push(`Combination ${index+1}: Invalid size index: ${combo.sizeIndex}`);
            continue;
          }
          combo.size = product.sizes[combo.sizeIndex];
        }

        // Validate variant
        if (combo.variant && !product.variants.includes(combo.variant)) {
          errors.push(`Combination ${index+1}: Variant "${combo.variant}" does not exist in this product`);
          continue;
        }

        // Validate color
        if (combo.color && !product.colors.includes(combo.color)) {
          errors.push(`Combination ${index+1}: Color "${combo.color}" does not exist in this product`);
          continue;
        }

        // Validate size
        if (combo.size && !product.sizes.includes(combo.size)) {
          errors.push(`Combination ${index+1}: Size "${combo.size}" does not exist in this product`);
          continue;
        }

        // Check for duplicates within existing combinations
        const existingCombination = product.variantCombinations.find(
          c => c.variant === (combo.variant || null) &&
               c.color === (combo.color || null) &&
               c.size === (combo.size || null)
        );

        if (existingCombination) {
          errors.push(`Combination ${index+1}: This variant combination already exists`);
          continue;
        }

        // Check for duplicates within the current batch
        const duplicateInBatch = validCombinations.find(
          c => c.variant === (combo.variant || null) &&
               c.color === (combo.color || null) &&
               c.size === (combo.size || null)
        );

        if (duplicateInBatch) {
          errors.push(`Combination ${index+1}: Duplicate combination in the request`);
          continue;
        }

        // Set defaults
        if (!combo.additionalPrice && combo.additionalPrice !== 0) {
          combo.additionalPrice = 0;
        }

        if (!combo.stock && combo.stock !== 0) {
          combo.stock = 0;
        }

        validCombinations.push(combo);
      } catch (error) {
        errors.push(`Combination ${index+1}: ${error instanceof Error ? error.message : String(error)}`);
      }
    }

    if (validCombinations.length === 0) {
      throw new AppError(
        StatusCodes.BAD_REQUEST, 
        `No valid combinations to add. Errors: ${errors.join('; ')}`
      );
    }

    // Add all valid combinations
    product.variantCombinations.push(...validCombinations as IVariantCombination[]);
    await product.save();

    // Return warnings if some combinations had errors
    if (errors.length > 0) {
      return {
        ...product.toObject(),
        warnings: errors
      } as any;
    }

    return product;
  }

  // Calculate final price for a specific variant combination
  static calculateFinalPrice(basePrice: number, additionalPrice: number): number {
    return basePrice + additionalPrice;
  }

  // Bulk operations for product attributes
  static async addMultipleProductVariants(productId: string, variants: string[]): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Filter out duplicates
    const uniqueVariants = variants.filter(
      variant => !product.variants.includes(variant)
    );

    if (uniqueVariants.length === 0) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'All variants already exist');
    }

    product.variants.push(...uniqueVariants);
    await product.save();
    return product;
  }

  static async addMultipleProductColors(productId: string, colors: string[]): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Filter out duplicates
    const uniqueColors = colors.filter(
      color => !product.colors.includes(color)
    );

    if (uniqueColors.length === 0) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'All colors already exist');
    }

    product.colors.push(...uniqueColors);
    await product.save();
    return product;
  }

  static async addMultipleProductSizes(productId: string, sizes: string[]): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Filter out duplicates
    const uniqueSizes = sizes.filter(
      size => !product.sizes.includes(size)
    );

    if (uniqueSizes.length === 0) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'All sizes already exist');
    }

    product.sizes.push(...uniqueSizes);
    await product.save();
    return product;
  }

  // Single deletion methods
  static async deleteVariant(productId: string, variant: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if variant exists
    if (!product.variants.includes(variant)) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant not found');
    }

    // Check if variant is in use
    const isVariantInUse = product.variantCombinations.some(combo => combo.variant === variant);
    if (isVariantInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST,
        'Cannot delete variant because it is used in at least one variant combination'
      );
    }

    // Remove the variant
    product.variants = product.variants.filter(v => v !== variant);
    await product.save();
    return product;
  }

  static async deleteColor(productId: string, color: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if color exists
    if (!product.colors.includes(color)) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Color not found');
    }

    // Check if color is in use
    const isColorInUse = product.variantCombinations.some(combo => combo.color === color);
    if (isColorInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST,
        'Cannot delete color because it is used in at least one variant combination'
      );
    }

    // Remove the color
    product.colors = product.colors.filter(c => c !== color);
    await product.save();
    return product;
  }

  static async deleteSize(productId: string, size: string): Promise<IProduct> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Check if size exists
    if (!product.sizes.includes(size)) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Size not found');
    }

    // Check if size is in use
    const isSizeInUse = product.variantCombinations.some(combo => combo.size === size);
    if (isSizeInUse) {
      throw new AppError(
        StatusCodes.BAD_REQUEST,
        'Cannot delete size because it is used in at least one variant combination'
      );
    }

    // Remove the size
    product.sizes = product.sizes.filter(s => s !== size);
    await product.save();
    return product;
  }

  static async updateCartItemQuantity(
    productId: string,
    userId: string,
    variantCombinationId: string,
    quantity: number
  ): Promise<ICartItem> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Find the variant combination
    const combination = product.variantCombinations.find(
      combo => combo._id.toString() === variantCombinationId
    );

    if (!combination) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Invalid variant combination');
    }

    if (quantity < 1) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Quantity must be at least 1');
    }

    if (combination.stock < quantity) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Insufficient stock');
    }

    // Find and update the cart item
    const cartItem = await CartItem.findOne({
      user: userId,
      product: productId,
      variantCombinationId: new mongoose.Types.ObjectId(variantCombinationId)
    });

    if (!cartItem) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Cart item not found');
    }

    // Calculate new total price
    const totalPrice = (product.basePrice + combination.additionalPrice) * quantity;

    // Update the cart item
    cartItem.quantity = quantity;
    cartItem.price = totalPrice;
    await cartItem.save();

    return cartItem;
  }
} 