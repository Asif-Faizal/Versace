import { Router } from 'express';
import { AuthController } from '../controllers/authController';
import { authenticate, authorize } from '../middleware/auth';
import { body } from 'express-validator';

const router = Router();

// Validation middleware
const registerValidation = [
  body('email').isEmail().withMessage('Please enter a valid email'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long'),
  body('firstName').notEmpty().withMessage('First name is required'),
  body('lastName').notEmpty().withMessage('Last name is required')
];

const loginValidation = [
  body('email').isEmail().withMessage('Please enter a valid email'),
  body('password').notEmpty().withMessage('Password is required')
];

const refreshTokenValidation = [
  body('refreshToken').notEmpty().withMessage('Refresh token is required')
];

// Public routes
router.post('/register', registerValidation, AuthController.register);
router.post('/login', loginValidation, AuthController.login);
router.post('/refresh-token', refreshTokenValidation, AuthController.refreshToken);

// Protected routes
router.post('/logout', authenticate, AuthController.logout);
router.put('/profile', authenticate, AuthController.updateProfile);
router.delete('/account', authenticate, AuthController.deleteAccount);

export default router; 