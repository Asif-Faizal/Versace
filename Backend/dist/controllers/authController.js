"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const authService_1 = require("../services/authService");
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
class AuthController {
    static getDeviceInfo(req) {
        return {
            deviceId: req.headers['deviceid'],
            deviceModel: req.headers['devicemodel'],
            deviceOs: req.headers['deviceos']
        };
    }
    static async register(req, res, next) {
        try {
            const deviceInfo = AuthController.getDeviceInfo(req);
            const result = await authService_1.AuthService.register({
                ...req.body,
                ...deviceInfo
            });
            res.status(statusCodes_1.StatusCodes.CREATED).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async login(req, res, next) {
        try {
            const { email, password } = req.body;
            const deviceInfo = AuthController.getDeviceInfo(req);
            const result = await authService_1.AuthService.login(email, password, deviceInfo);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async refreshToken(req, res, next) {
        try {
            const { refreshToken } = req.body;
            const deviceInfo = AuthController.getDeviceInfo(req);
            const result = await authService_1.AuthService.refreshTokens(refreshToken, deviceInfo);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async logout(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const deviceInfo = AuthController.getDeviceInfo(req);
            const accessToken = req.headers.authorization?.split(' ')[1];
            await authService_1.AuthService.logout(req.user._id, deviceInfo, accessToken);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
    static async updateProfile(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const deviceInfo = AuthController.getDeviceInfo(req);
            const result = await authService_1.AuthService.updateUser(req.user._id, req.body, deviceInfo);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteAccount(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            const { password } = req.body;
            if (!password) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Password is required for account deletion');
            }
            const deviceInfo = AuthController.getDeviceInfo(req);
            const accessToken = req.headers.authorization?.split(' ')[1];
            await authService_1.AuthService.deleteUser(req.user._id, password, deviceInfo, accessToken);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
    static async sendOtp(req, res, next) {
        try {
            const { email } = req.body;
            await authService_1.AuthService.sendOtp(email);
            res.status(statusCodes_1.StatusCodes.OK).json({ message: 'OTP sent successfully' });
        }
        catch (error) {
            next(error);
        }
    }
    static async verifyOtp(req, res, next) {
        try {
            const { email, otp } = req.body;
            await authService_1.AuthService.verifyOtp(email, otp);
            res.status(statusCodes_1.StatusCodes.OK).json({ message: 'Email verified successfully' });
        }
        catch (error) {
            next(error);
        }
    }
    static async getUserDetails(req, res, next) {
        try {
            if (!req.user?._id) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated');
            }
            // Get device info from headers
            const deviceInfo = AuthController.getDeviceInfo(req);
            if (!deviceInfo.deviceId) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Device ID header is required');
            }
            // Fetch user details from DB
            const { User } = await Promise.resolve().then(() => __importStar(require('../models/User')));
            const user = await User.findById(req.user._id).select('-password -refreshToken');
            if (!user) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
            }
            // Check for deviceId mismatch
            if (user.lastUsedDeviceId && user.lastUsedDeviceId !== deviceInfo.deviceId) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Device ID mismatch');
            }
            res.status(statusCodes_1.StatusCodes.OK).json({
                _id: user._id,
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role,
                isActive: user.isActive,
                isEmailVerified: user.isEmailVerified,
                createdAt: user.createdAt,
                updatedAt: user.updatedAt
            });
        }
        catch (error) {
            next(error);
        }
    }
}
exports.AuthController = AuthController;
