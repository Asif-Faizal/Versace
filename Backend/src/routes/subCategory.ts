import { Router } from 'express';
import { SubCategoryController } from '../controllers/subCategoryController';
import { authenticate, authorize } from '../middleware/auth';
import { body } from 'express-validator';
import { upload, handleUploadErrors } from '../middleware/fileUpload';

const router = Router();

// Validation middleware
const subCategoryValidation = [
  body('name').notEmpty().withMessage('SubCategory name is required'),
  body('description').notEmpty().withMessage('SubCategory description is required'),
  body('category').isMongoId().withMessage('Valid category ID is required')
];

// Protected routes - Both users and admins
router.get('/', authenticate, SubCategoryController.getAllSubCategories);
router.get('/:id', authenticate, SubCategoryController.getSubCategory);

// Protected routes - Admin only
router.post('/', 
  authenticate, 
  authorize(['admin']), 
  upload.single('image'), // Add multer middleware to handle file upload
  handleUploadErrors, // Handle any file upload errors
  subCategoryValidation, 
  SubCategoryController.createSubCategory
);

router.put('/:id', 
  authenticate, 
  authorize(['admin']), 
  upload.single('image'), // Add multer middleware to handle file upload
  handleUploadErrors, // Handle any file upload errors
  subCategoryValidation, 
  SubCategoryController.updateSubCategory
);

router.delete('/:id', authenticate, authorize(['admin']), SubCategoryController.deleteSubCategory);

export default router; 