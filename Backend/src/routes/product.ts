import { Router } from 'express';
import { ProductController } from '../controllers/productController';
import { authenticate, authorize } from '../middleware/auth';
import { body, query } from 'express-validator';

const router = Router();

// Validation middleware
const productValidation = [
  body('name').notEmpty().withMessage('Product name is required'),
  body('description').notEmpty().withMessage('Product description is required'),
  body('basePrice').isNumeric().withMessage('Base price must be a number'),
  body('category').isMongoId().withMessage('Valid category ID is required'),
  body('subCategory').isMongoId().withMessage('Valid subcategory ID is required')
];

const variantValidation = [
  body('name').notEmpty().withMessage('Variant name is required'),
  body('price').isNumeric().withMessage('Price must be a number')
];

const queryValidation = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('minPrice').optional().isNumeric().withMessage('Minimum price must be a number'),
  query('maxPrice').optional().isNumeric().withMessage('Maximum price must be a number'),
  query('isNewProduct').optional().isBoolean().withMessage('isNewProduct must be a boolean'),
  query('isTrending').optional().isBoolean().withMessage('isTrending must be a boolean'),
  query('category').optional().isMongoId().withMessage('Invalid category ID'),
  query('subcategory').optional().isMongoId().withMessage('Invalid subcategory ID'),
  query('search').optional().isString().withMessage('Search must be a string'),
  query('sortBy').optional().isIn(['createdAt', 'basePrice', 'rating', 'name']).withMessage('Invalid sort field'),
  query('sortOrder').optional().isIn(['asc', 'desc']).withMessage('Sort order must be either asc or desc')
];

// Public routes
router.get('/', queryValidation, ProductController.getAllProducts);
router.get('/new', queryValidation, ProductController.getNewProducts);
router.get('/trending', queryValidation, ProductController.getTrendingProducts);
router.get('/:id', ProductController.getProduct);
router.get('/category/:categoryId', ProductController.getProductsByCategory);
router.get('/subcategory/:subCategoryId', ProductController.getProductsBySubCategory);

// Protected routes - Admin only
router.post('/', authenticate, authorize(['admin']), productValidation, ProductController.createProduct);
router.put('/:id', authenticate, authorize(['admin']), productValidation, ProductController.updateProduct);
router.delete('/:id', authenticate, authorize(['admin']), ProductController.deleteProduct);

// Variant management - Admin only
router.post('/:id/variants', authenticate, authorize(['admin']), variantValidation, ProductController.addVariant);
router.put('/:id/variants/:variantId', authenticate, authorize(['admin']), variantValidation, ProductController.updateVariant);
router.delete('/:id/variants/:variantId', authenticate, authorize(['admin']), ProductController.deleteVariant);

// User-specific routes (require authentication)
router.post('/:id/wishlist', authenticate, ProductController.addToWishlist);
router.delete('/:id/wishlist', authenticate, ProductController.removeFromWishlist);
router.post('/:id/cart', authenticate, ProductController.addToCart);
router.delete('/:id/cart', authenticate, ProductController.removeFromCart);

export default router; 