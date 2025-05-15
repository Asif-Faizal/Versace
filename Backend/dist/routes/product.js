"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const productController_1 = require("../controllers/productController");
const auth_1 = require("../middleware/auth");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
// Validation middleware
const productValidation = [
    (0, express_validator_1.body)('name').notEmpty().withMessage('Product name is required'),
    (0, express_validator_1.body)('description').notEmpty().withMessage('Product description is required'),
    (0, express_validator_1.body)('basePrice').isNumeric().withMessage('Base price must be a number'),
    (0, express_validator_1.body)('category').isMongoId().withMessage('Valid category ID is required'),
    (0, express_validator_1.body)('subCategory').isMongoId().withMessage('Valid subcategory ID is required')
];
const variantValidation = [
    (0, express_validator_1.body)('name').notEmpty().withMessage('Variant name is required'),
    (0, express_validator_1.body)('price').isNumeric().withMessage('Price must be a number'),
    (0, express_validator_1.body)('stock').isInt({ min: 0 }).withMessage('Stock must be a non-negative integer')
];
const queryValidation = [
    (0, express_validator_1.query)('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    (0, express_validator_1.query)('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
    (0, express_validator_1.query)('minPrice').optional().isNumeric().withMessage('Minimum price must be a number'),
    (0, express_validator_1.query)('maxPrice').optional().isNumeric().withMessage('Maximum price must be a number'),
    (0, express_validator_1.query)('isNewProduct').optional().isBoolean().withMessage('isNewProduct must be a boolean'),
    (0, express_validator_1.query)('isTrending').optional().isBoolean().withMessage('isTrending must be a boolean'),
    (0, express_validator_1.query)('category').optional().isMongoId().withMessage('Invalid category ID'),
    (0, express_validator_1.query)('subcategory').optional().isMongoId().withMessage('Invalid subcategory ID'),
    (0, express_validator_1.query)('search').optional().isString().withMessage('Search must be a string'),
    (0, express_validator_1.query)('sortBy').optional().isIn(['createdAt', 'basePrice', 'rating', 'name']).withMessage('Invalid sort field'),
    (0, express_validator_1.query)('sortOrder').optional().isIn(['asc', 'desc']).withMessage('Sort order must be either asc or desc')
];
// Public routes
router.get('/', queryValidation, productController_1.ProductController.getAllProducts);
router.get('/new', queryValidation, productController_1.ProductController.getNewProducts);
router.get('/trending', queryValidation, productController_1.ProductController.getTrendingProducts);
router.get('/:id', productController_1.ProductController.getProduct);
router.get('/category/:categoryId', productController_1.ProductController.getProductsByCategory);
router.get('/subcategory/:subCategoryId', productController_1.ProductController.getProductsBySubCategory);
// Protected routes - Admin only
router.post('/', auth_1.authenticate, (0, auth_1.authorize)(['admin']), productValidation, productController_1.ProductController.createProduct);
router.put('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), productValidation, productController_1.ProductController.updateProduct);
router.delete('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), productController_1.ProductController.deleteProduct);
// Variant management - Admin only
router.post('/:id/variants', auth_1.authenticate, (0, auth_1.authorize)(['admin']), variantValidation, productController_1.ProductController.addVariant);
router.put('/:id/variants/:variantId', auth_1.authenticate, (0, auth_1.authorize)(['admin']), variantValidation, productController_1.ProductController.updateVariant);
router.delete('/:id/variants/:variantId', auth_1.authenticate, (0, auth_1.authorize)(['admin']), productController_1.ProductController.deleteVariant);
// User-specific routes (require authentication)
router.post('/:id/wishlist', auth_1.authenticate, productController_1.ProductController.addToWishlist);
router.delete('/:id/wishlist', auth_1.authenticate, productController_1.ProductController.removeFromWishlist);
router.post('/:id/cart', auth_1.authenticate, productController_1.ProductController.addToCart);
router.delete('/:id/cart', auth_1.authenticate, productController_1.ProductController.removeFromCart);
exports.default = router;
