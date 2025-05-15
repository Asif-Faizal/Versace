import { Request, Response, NextFunction } from 'express';
import { ProductService } from '../services/productService';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

export class ProductController {
  static async createProduct(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.createProduct(req.body);
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
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteProduct(req: Request, res: Response, next: NextFunction) {
    try {
      await ProductService.deleteProduct(req.params.id);
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }

  static async addVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.addVariant(req.params.id, req.body);
      res.status(StatusCodes.CREATED).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async updateVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.updateVariant(
        req.params.id,
        req.params.variantId,
        req.body
      );
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async deleteVariant(req: Request, res: Response, next: NextFunction) {
    try {
      const product = await ProductService.deleteVariant(req.params.id, req.params.variantId);
      res.status(StatusCodes.OK).json(product);
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

  static async addToCart(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const product = await ProductService.addToCart(req.params.id, req.user._id);
      res.status(StatusCodes.OK).json(product);
    } catch (error) {
      next(error);
    }
  }

  static async removeFromCart(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const product = await ProductService.removeFromCart(req.params.id, req.user._id);
      res.status(StatusCodes.OK).json(product);
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
} 