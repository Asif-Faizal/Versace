import { Router } from 'express';
import { CategoryController } from '../controllers/categoryController';
import { authenticate, authorize } from '../middleware/auth';
import { body } from 'express-validator';
import { cacheMiddleware } from '../middleware/cache';

const router = Router();

// Validation middleware
const categoryValidation = [
  body('name').notEmpty().withMessage('Category name is required'),
  body('description').notEmpty().withMessage('Category description is required')
];

// Protected routes - Both users and admins - with caching
router.get('/', authenticate, cacheMiddleware('categories'), CategoryController.getAllCategories);
router.get('/:id', authenticate, cacheMiddleware('categories'), CategoryController.getCategory);

// Protected routes - Admin only
router.post('/', authenticate, authorize(['admin']), categoryValidation, CategoryController.createCategory);
router.put('/:id', authenticate, authorize(['admin']), categoryValidation, CategoryController.updateCategory);
router.delete('/:id', authenticate, authorize(['admin']), CategoryController.deleteCategory);

export default router;