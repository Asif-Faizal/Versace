"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const categoryController_1 = require("../controllers/categoryController");
const auth_1 = require("../middleware/auth");
const express_validator_1 = require("express-validator");
const cache_1 = require("../middleware/cache");
const fileUpload_1 = require("../middleware/fileUpload");
const router = (0, express_1.Router)();
// Validation middleware
const categoryValidation = [
    (0, express_validator_1.body)('name').notEmpty().withMessage('Category name is required'),
    (0, express_validator_1.body)('description').notEmpty().withMessage('Category description is required')
];
// Protected routes - Both users and admins - with caching
router.get('/', auth_1.authenticate, (0, cache_1.cacheMiddleware)('categories'), categoryController_1.CategoryController.getAllCategories);
router.get('/:id', auth_1.authenticate, (0, cache_1.cacheMiddleware)('categories'), categoryController_1.CategoryController.getCategory);
// Protected routes - Admin only
router.post('/', auth_1.authenticate, (0, auth_1.authorize)(['admin']), fileUpload_1.upload.single('image'), // Add multer middleware to handle file upload
fileUpload_1.handleUploadErrors, // Handle any file upload errors
categoryValidation, categoryController_1.CategoryController.createCategory);
router.put('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), fileUpload_1.upload.single('image'), // Add multer middleware to handle file upload
fileUpload_1.handleUploadErrors, // Handle any file upload errors
categoryValidation, categoryController_1.CategoryController.updateCategory);
router.delete('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), categoryController_1.CategoryController.deleteCategory);
exports.default = router;
