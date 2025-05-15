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

const variantCombinationValidation = [
  body('additionalPrice').isNumeric().withMessage('Additional price must be a number'),
  body('stock').isInt({ min: 0 }).withMessage('Stock must be a non-negative integer')
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

// User-specific routes (require authentication)
router.get('/wishlist', authenticate, ProductController.getWishlistItems);
router.get('/cart', authenticate, ProductController.getCartItems);

// Protected routes - Both users and admins
router.get('/', authenticate, queryValidation, ProductController.getAllProducts);
router.get('/new', authenticate, queryValidation, ProductController.getNewProducts);
router.get('/trending', authenticate, queryValidation, ProductController.getTrendingProducts);
router.get('/category/:categoryId', authenticate, ProductController.getProductsByCategory);
router.get('/subcategory/:subCategoryId', authenticate, ProductController.getProductsBySubCategory);

// Product-specific routes
router.get('/:id', authenticate, ProductController.getProduct);
router.post('/:id/wishlist', authenticate, ProductController.addToWishlist);
router.delete('/:id/wishlist', authenticate, ProductController.removeFromWishlist);
router.post('/:id/cart', authenticate, ProductController.addToCart);
router.delete('/:id/cart', authenticate, ProductController.removeFromCart);

// Protected routes - Admin only
router.post('/', authenticate, authorize(['admin']), productValidation, ProductController.createProduct);
router.put('/:id', authenticate, authorize(['admin']), productValidation, ProductController.updateProduct);
router.delete('/:id', authenticate, authorize(['admin']), ProductController.deleteProduct);

// Product attributes management - Admin only
router.post('/:id/variants', authenticate, authorize(['admin']), ProductController.addProductVariant);
router.post('/:id/variants/bulk', authenticate, authorize(['admin']), ProductController.addMultipleProductVariants);
router.delete('/:id/variants/:variantName', authenticate, authorize(['admin']), ProductController.removeProductVariant);

router.post('/:id/colors', authenticate, authorize(['admin']), ProductController.addProductColor);
router.post('/:id/colors/bulk', authenticate, authorize(['admin']), ProductController.addMultipleProductColors);
router.delete('/:id/colors/:colorName', authenticate, authorize(['admin']), ProductController.removeProductColor);

router.post('/:id/sizes', authenticate, authorize(['admin']), ProductController.addProductSize);
router.post('/:id/sizes/bulk', authenticate, authorize(['admin']), ProductController.addMultipleProductSizes);
router.delete('/:id/sizes/:sizeName', authenticate, authorize(['admin']), ProductController.removeProductSize);

// Variant combinations - Admin only
router.post('/:id/variant-combinations', authenticate, authorize(['admin']), variantCombinationValidation, ProductController.addVariantCombination);
router.post('/:id/variant-combinations/bulk', authenticate, authorize(['admin']), ProductController.addMultipleVariantCombinations);
router.delete('/:id/variant-combinations/bulk', authenticate, authorize(['admin']), ProductController.deleteMultipleVariantCombinations);
router.put('/:id/variant-combinations/:combinationId', authenticate, authorize(['admin']), variantCombinationValidation, ProductController.updateVariantCombination);
router.delete('/:id/variant-combinations/:combinationId', authenticate, authorize(['admin']), ProductController.deleteVariantCombination);
router.get('/:id/variant-combinations', authenticate, ProductController.getVariantCombinations);

// Single deletion routes - Admin only
router.delete('/:id/variant', authenticate, authorize(['admin']), ProductController.deleteVariant);
router.delete('/:id/color', authenticate, authorize(['admin']), ProductController.deleteColor);
router.delete('/:id/size', authenticate, authorize(['admin']), ProductController.deleteSize);

export default router; 