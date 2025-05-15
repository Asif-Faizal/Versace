"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const subCategoryController_1 = require("../controllers/subCategoryController");
const auth_1 = require("../middleware/auth");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
// Validation middleware
const subCategoryValidation = [
    (0, express_validator_1.body)('name').notEmpty().withMessage('SubCategory name is required'),
    (0, express_validator_1.body)('description').notEmpty().withMessage('SubCategory description is required'),
    (0, express_validator_1.body)('category').isMongoId().withMessage('Valid category ID is required')
];
// Protected routes - Both users and admins
router.get('/', auth_1.authenticate, subCategoryController_1.SubCategoryController.getAllSubCategories);
router.get('/:id', auth_1.authenticate, subCategoryController_1.SubCategoryController.getSubCategory);
// Protected routes - Admin only
router.post('/', auth_1.authenticate, (0, auth_1.authorize)(['admin']), subCategoryValidation, subCategoryController_1.SubCategoryController.createSubCategory);
router.put('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), subCategoryValidation, subCategoryController_1.SubCategoryController.updateSubCategory);
router.delete('/:id', auth_1.authenticate, (0, auth_1.authorize)(['admin']), subCategoryController_1.SubCategoryController.deleteSubCategory);
exports.default = router;
