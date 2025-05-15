"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const categoryController_1 = require("../controllers/categoryController");
const auth_1 = require("../middleware/auth");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
// Validation middleware
const categoryValidation = [
    (0, express_validator_1.body)('name').notEmpty().withMessage('Category name is required'),
    (0, express_validator_1.body)('description').notEmpty().withMessage('Category description is required')
];
// Public routes
router.get('/', categoryController_1.CategoryController.getAllCategories);
router.get('/:id', categoryController_1.CategoryController.getCategory);
// Protected routes - Admin only
router.post('/', auth_1.authenticate, (0, auth_1.authorize)(['admin']), categoryValidation, categoryController_1.CategoryController.createCategory);
router.put('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), categoryValidation, categoryController_1.CategoryController.updateCategory);
router.delete('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), categoryController_1.CategoryController.deleteCategory);
exports.default = router;
