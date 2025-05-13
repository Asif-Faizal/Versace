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

const deleteAccountValidation = [
  body('password').notEmpty().withMessage('Password is required for account deletion')
];

const otpValidation = [
  body('email').isEmail().withMessage('Please enter a valid email')
];

const verifyOtpValidation = [
  body('email').isEmail().withMessage('Please enter a valid email'),
  body('otp').isLength({ min: 6, max: 6 }).withMessage('OTP must be 6 digits')
];

// Public routes
router.post('/register', registerValidation, AuthController.register);
router.post('/login', loginValidation, AuthController.login);
router.post('/refresh-token', refreshTokenValidation, AuthController.refreshToken);
router.post('/send-otp', otpValidation, AuthController.sendOtp);
router.post('/verify-otp', verifyOtpValidation, AuthController.verifyOtp);

// Protected routes
router.post('/logout', authenticate, AuthController.logout);
router.put('/profile', authenticate, AuthController.updateProfile);
router.delete('/account', authenticate, deleteAccountValidation, AuthController.deleteAccount);

// Get user details
router.get('/me', authenticate, AuthController.getUserDetails);

export default router; 