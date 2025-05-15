import { Request, Response, NextFunction } from 'express';
import { ProductService } from '../services/productService';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import { clearCache } from '../middleware/cache';

export class ProductController {
  static async createProduct(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.createProduct(req.body);
      // Clear product cache after creating a new product
      await clearCache('products:*');
      res.status(StatusCodes.CREATED).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async getProduct(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.getProductById(req.params.id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async getAllProducts(req: Request, res: Response, next: NextFunction) {
    try {
      const {
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
      } = req.query;

      const result = await ProductService.getAllProducts({
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

      res.status(StatusCodes.OK).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async getProductsByCategory(req: Request, res: Response, next: NextFunction) {
    try {
      const products = await ProductService.getProductsByCategory(req.params.categoryId);
      res.status(StatusCodes.OK).json(products);
    } catch (error) {
      next(error);
    }
  }

  static async getProductsBySubCategory(req: Request, res: Response, next: NextFunction) {
    try {
      const products = await ProductService.getProductsBySubCategory(req.params.subCategoryId);
      res.status(StatusCodes.OK).json(products);
    } catch (error) {
      next(error);
    }
  }

  static async updateProduct(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.updateProduct(req.params.id, req.body);
      // Clear both specific product cache and any list that might contain this product
      await clearCache(`products:*`);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteProduct(req: Request, res: Response, next: NextFunction) {
    try {
      await ProductService.deleteProduct(req.params.id);
      // Clear cache for all products after deletion
      await clearCache('products:*');
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }

  static async addToWishlist(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const product = await ProductService.addToWishlist(req.params.id, req.user._id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async removeFromWishlist(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const product = await ProductService.removeFromWishlist(req.params.id, req.user._id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async getWishlistItems(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const products = await ProductService.getWishlistItems(req.user._id);
      res.status(StatusCodes.OK).json(products);
    } catch (error) {
      next(error);
    }
  }

  static async addToCart(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }

      const { variantCombinationId, quantity } = req.body;
      if (!variantCombinationId) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variant combination ID is required');
      }

      const cartItem = await ProductService.addToCart(
        req.params.id,
        req.user._id,
        variantCombinationId,
        quantity
      );
      // Clear cart cache for this user
      await clearCache(`cart:*${req.user._id}*`);
      res.status(StatusCodes.OK).json(cartItem);
    } catch (error) {
      next(error);
    }
  }

  static async removeFromCart(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }

      const { variantCombinationId } = req.body;
      if (!variantCombinationId) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variant combination ID is required');
      }

      await ProductService.removeFromCart(
        req.params.id,
        req.user._id,
        variantCombinationId
      );
      // Clear cart cache for this user
      await clearCache(`cart:*${req.user._id}*`);
      res.status(StatusCodes.OK).json({ message: 'Item removed from cart' });
    } catch (error) {
      next(error);
    }
  }

  static async clearCart(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }

      await ProductService.clearCart(req.user._id);
      // Clear cart cache for this user
      await clearCache(`cart:*${req.user._id}*`);
      res.status(StatusCodes.OK).json({ message: 'Cart cleared successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async getCartItems(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const cartItems = await ProductService.getCartItems(req.user._id);
      res.status(StatusCodes.OK).json(cartItems);
    } catch (error) {
      next(error);
    }
  }

  static async toggleWishlist(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.toggleWishlist(req.params.id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async toggleCart(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.toggleCart(req.params.id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async updateRating(req: Request, res: Response, next: NextFunction) {
    try {
      const { rating } = req.body;
      if (typeof rating !== 'number') {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Rating must be a number');
      }
      const product = await ProductService.updateRating(req.params.id, rating);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async getNewProducts(req: Request, res: Response, next: NextFunction) {
    try {
      const limit = parseInt(req.query.limit as string) || 10;
      const products = await ProductService.getNewProducts(limit);
      res.status(StatusCodes.OK).json(products);
    } catch (error) {
      next(error);
    }
  }

  static async getTrendingProducts(req: Request, res: Response, next: NextFunction) {
    try {
      const limit = parseInt(req.query.limit as string) || 10;
      const products = await ProductService.getTrendingProducts(limit);
      res.status(StatusCodes.OK).json(products);
    } catch (error) {
      next(error);
    }
  }

  // Product attribute management methods
  static async addProductVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const { variant } = req.body;
      if (!variant) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variant name is required');
      }
      const product = await ProductService.addProductVariant(req.params.id, variant);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async removeProductVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.removeProductVariant(req.params.id, req.params.variantName);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async addProductColor(req: Request, res: Response, next: NextFunction) {
    try {
      const { color } = req.body;
      if (!color) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Color name is required');
      }
      const product = await ProductService.addProductColor(req.params.id, color);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async removeProductColor(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.removeProductColor(req.params.id, req.params.colorName);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async addProductSize(req: Request, res: Response, next: NextFunction) {
    try {
      const { size } = req.body;
      if (!size) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Size name is required');
      }
      const product = await ProductService.addProductSize(req.params.id, size);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async removeProductSize(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.removeProductSize(req.params.id, req.params.sizeName);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  // Variant combination methods
  static async addVariantCombination(req: Request, res: Response, next: NextFunction) {
    try {
      const combination = req.body;
      const product = await ProductService.addVariantCombination(req.params.id, combination);
      res.status(StatusCodes.CREATED).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async updateVariantCombination(req: Request, res: Response, next: NextFunction) {
    try {
      const combination = req.body;
      const product = await ProductService.updateVariantCombination(
        req.params.id,
        req.params.combinationId,
        combination
      );
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteVariantCombination(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.deleteVariantCombination(
        req.params.id,
        req.params.combinationId
      );
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteMultipleVariantCombinations(req: Request, res: Response, next: NextFunction) {
    try {
      const { combinationIds } = req.body;
      if (!Array.isArray(combinationIds) || combinationIds.length === 0) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Valid combinationIds array is required');
      }
      
      const product = await ProductService.deleteMultipleVariantCombinations(req.params.id, combinationIds);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async getVariantCombinations(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.getProductById(req.params.id);
      res.status(StatusCodes.OK).json(product.variantCombinations);
    } catch (error) {
      next(error);
    }
  }

  // Bulk operations for product attributes
  static async addMultipleProductVariants(req: Request, res: Response, next: NextFunction) {
    try {
      const { variants } = req.body;
      if (!Array.isArray(variants) || variants.length === 0) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variants array is required');
      }
      
      const product = await ProductService.addMultipleProductVariants(req.params.id, variants);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async addMultipleProductColors(req: Request, res: Response, next: NextFunction) {
    try {
      const { colors } = req.body;
      if (!Array.isArray(colors) || colors.length === 0) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Colors array is required');
      }
      
      const product = await ProductService.addMultipleProductColors(req.params.id, colors);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async addMultipleProductSizes(req: Request, res: Response, next: NextFunction) {
    try {
      const { sizes } = req.body;
      if (!Array.isArray(sizes) || sizes.length === 0) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Sizes array is required');
      }
      
      const product = await ProductService.addMultipleProductSizes(req.params.id, sizes);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async addMultipleVariantCombinations(req: Request, res: Response, next: NextFunction) {
    try {
      const { combinations } = req.body;
      if (!Array.isArray(combinations) || combinations.length === 0) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Valid combinations array is required');
      }
      
      const product = await ProductService.addMultipleVariantCombinations(req.params.id, combinations);
      res.status(StatusCodes.CREATED).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const { variant } = req.body;

      if (!variant) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variant name is required');
      }

      const product = await ProductService.deleteVariant(id, variant);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteColor(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const { color } = req.body;

      if (!color) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Color name is required');
      }

      const product = await ProductService.deleteColor(id, color);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteSize(req: Request, res: Response, next: NextFunction) {
    try {
      const { id } = req.params;
      const { size } = req.body;

      if (!size) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Size name is required');
      }

      const product = await ProductService.deleteSize(id, size);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async updateCartItemQuantity(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }

      const { variantCombinationId, quantity } = req.body;
      if (!variantCombinationId) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Variant combination ID is required');
      }

      if (typeof quantity !== 'number' || quantity < 1) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Quantity must be a positive number');
      }

      const cartItem = await ProductService.updateCartItemQuantity(
        req.params.id,
        req.user._id,
        variantCombinationId,
        quantity
      );
      // Clear cart cache for this user
      await clearCache(`cart:*${req.user._id}*`);
      res.status(StatusCodes.OK).json(cartItem);
    } catch (error) {
      next(error);
    }
  }
} 