"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const authController_1 = require("../controllers/authController");
const auth_1 = require("../middleware/auth");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
// Validation middleware
const registerValidation = [
    (0, express_validator_1.body)('email').isEmail().withMessage('Please enter a valid email'),
    (0, express_validator_1.body)('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long'),
    (0, express_validator_1.body)('firstName').notEmpty().withMessage('First name is required'),
    (0, express_validator_1.body)('lastName').notEmpty().withMessage('Last name is required')
];
const loginValidation = [
    (0, express_validator_1.body)('email').isEmail().withMessage('Please enter a valid email'),
    (0, express_validator_1.body)('password').notEmpty().withMessage('Password is required')
];
const refreshTokenValidation = [
    (0, express_validator_1.body)('refreshToken').notEmpty().withMessage('Refresh token is required')
];
// Public routes
router.post('/register', registerValidation, authController_1.AuthController.register);
router.post('/login', loginValidation, authController_1.AuthController.login);
router.post('/refresh-token', refreshTokenValidation, authController_1.AuthController.refreshToken);
// Protected routes
router.post('/logout', auth_1.authenticate, authController_1.AuthController.logout);
router.put('/profile', auth_1.authenticate, authController_1.AuthController.updateProfile);
router.delete('/account', auth_1.authenticate, authController_1.AuthController.deleteAccount);
exports.default = router;
