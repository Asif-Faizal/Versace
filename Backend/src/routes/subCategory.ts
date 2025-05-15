import { Router } from 'express';
import { SubCategoryController } from '../controllers/subCategoryController';
import { authenticate, authorize } from '../middleware/auth';
import { body } from 'express-validator';

const router = Router();

// Validation middleware
const subCategoryValidation = [
  body('name').notEmpty().withMessage('SubCategory name is required'),
  body('description').notEmpty().withMessage('SubCategory description is required'),
  body('category').isMongoId().withMessage('Valid category ID is required')
];

// Public routes
router.get('/', SubCategoryController.getAllSubCategories);
router.get('/:id', SubCategoryController.getSubCategory);

// Protected routes - Admin only
router.post('/', authenticate, authorize(['admin']), subCategoryValidation, SubCategoryController.createSubCategory);
router.put('/:id', authenticate, authorize(['admin']), subCategoryValidation, SubCategoryController.updateSubCategory);
router.delete('/:id', authenticate, authorize(['admin']), SubCategoryController.deleteSubCategory);

export default router; 