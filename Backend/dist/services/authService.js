"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthService = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const User_1 = require("../models/User");
const config_1 = __importDefault(require("../config/config"));
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
const auth_1 = require("../middleware/auth");
const emailService_1 = __importDefault(require("./emailService"));
class AuthService {
    static generateTokens(user) {
        if (!config_1.default.jwtSecret) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
        }
        const payload = {
            userId: user._id.toString(),
            email: user.email,
            role: user.role
        };
        const signOptions = {
            expiresIn: config_1.default.jwt.accessTokenExpiry
        };
        const accessToken = jsonwebtoken_1.default.sign(payload, config_1.default.jwtSecret, signOptions);
        const refreshSignOptions = {
            expiresIn: config_1.default.jwt.refreshTokenExpiry
        };
        const refreshToken = jsonwebtoken_1.default.sign(payload, config_1.default.jwtSecret, refreshSignOptions);
        return { accessToken, refreshToken };
    }
    static validateDevice(user, deviceInfo) {
        if (!deviceInfo?.deviceId) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Device ID is required');
        }
        if (user.lastUsedDeviceId && user.lastUsedDeviceId !== deviceInfo.deviceId) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.FORBIDDEN, 'Access denied: Device mismatch');
        }
    }
    static async register(userData) {
        const existingUser = await User_1.User.findOne({ email: userData.email });
        if (existingUser) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.CONFLICT, 'Email already registered');
        }
        const user = await User_1.User.create(userData);
        const tokens = this.generateTokens(user);
        user.refreshToken = tokens.refreshToken;
        user.lastUsedDeviceId = userData.deviceId;
        user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
        await user.save();
        return {
            user: {
                _id: user._id.toString(),
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role
            },
            ...tokens
        };
    }
    static async login(email, password, deviceInfo) {
        const user = await User_1.User.findOne({ email });
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid credentials');
        }
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid credentials');
        }
        this.validateDevice(user, deviceInfo);
        // Update device information if provided
        if (deviceInfo) {
            user.deviceId = deviceInfo.deviceId;
            user.deviceModel = deviceInfo.deviceModel;
            user.deviceOs = deviceInfo.deviceOs;
            user.lastUsedDeviceId = deviceInfo.deviceId;
        }
        const tokens = this.generateTokens(user);
        user.refreshToken = tokens.refreshToken;
        user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
        await user.save();
        return {
            user: {
                _id: user._id.toString(),
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role
            },
            ...tokens
        };
    }
    static async refreshTokens(refreshToken, deviceInfo) {
        if (!config_1.default.jwtSecret) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
        }
        try {
            const decoded = jsonwebtoken_1.default.verify(refreshToken, config_1.default.jwtSecret);
            const user = await User_1.User.findById(decoded.userId).select('+refreshToken');
            if (!user || user.refreshToken !== refreshToken) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
            }
            // Check if token has expired
            if (user.tokenExpiry && user.tokenExpiry < new Date()) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Token has expired');
            }
            this.validateDevice(user, deviceInfo);
            // Update device information if provided
            if (deviceInfo) {
                user.deviceId = deviceInfo.deviceId;
                user.deviceModel = deviceInfo.deviceModel;
                user.deviceOs = deviceInfo.deviceOs;
                user.lastUsedDeviceId = deviceInfo.deviceId;
            }
            const tokens = this.generateTokens(user);
            user.refreshToken = tokens.refreshToken;
            user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
            await user.save();
            return {
                user: {
                    _id: user._id.toString(),
                    email: user.email,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    role: user.role
                },
                ...tokens
            };
        }
        catch (error) {
            if (error instanceof jsonwebtoken_1.default.JsonWebTokenError) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
            }
            throw error;
        }
    }
    static async logout(userId, deviceInfo, accessToken) {
        const user = await User_1.User.findById(userId);
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        this.validateDevice(user, deviceInfo);
        // Update device information if provided
        if (deviceInfo) {
            user.deviceId = deviceInfo.deviceId;
            user.deviceModel = deviceInfo.deviceModel;
            user.deviceOs = deviceInfo.deviceOs;
        }
        // Invalidate tokens
        user.refreshToken = undefined;
        user.tokenExpiry = new Date(0); // Set to epoch time to ensure token is expired
        // Blacklist the access token if provided
        if (accessToken) {
            (0, auth_1.blacklistToken)(accessToken);
        }
        await user.save();
    }
    static async updateUser(userId, updateData, deviceInfo) {
        const user = await User_1.User.findById(userId);
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        this.validateDevice(user, deviceInfo);
        // Prevent updating sensitive fields
        const { password, role, refreshToken, ...safeUpdateData } = updateData;
        Object.assign(user, safeUpdateData);
        // Update device information if provided
        if (deviceInfo) {
            user.deviceId = deviceInfo.deviceId;
            user.deviceModel = deviceInfo.deviceModel;
            user.deviceOs = deviceInfo.deviceOs;
            user.lastUsedDeviceId = deviceInfo.deviceId;
        }
        await user.save();
        const tokens = this.generateTokens(user);
        return {
            user: {
                _id: user._id.toString(),
                email: user.email,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role
            },
            ...tokens
        };
    }
    static async deleteUser(userId, password, deviceInfo, accessToken) {
        const user = await User_1.User.findById(userId).select('+password');
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        // Verify password
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid password');
        }
        // Validate device
        this.validateDevice(user, deviceInfo);
        // Log device information before deletion if provided
        if (deviceInfo) {
            console.log(`User deleted from device: ${deviceInfo.deviceId}, Model: ${deviceInfo.deviceModel}, OS: ${deviceInfo.deviceOs}`);
        }
        // Blacklist the access token if provided
        if (accessToken) {
            (0, auth_1.blacklistToken)(accessToken);
        }
        await User_1.User.findByIdAndDelete(userId);
    }
    static generateOtp() {
        return Math.floor(100000 + Math.random() * 900000).toString();
    }
    static async sendOtp(email) {
        const user = await User_1.User.findOne({ email });
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        if (user.isEmailVerified) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Email is already verified');
        }
        // Prevent resending OTP within the resend interval
        if (user.emailOtpExpiry && user.emailOtp && user.emailOtpExpiry.getTime() > Date.now()) {
            const timeLeft = user.emailOtpExpiry.getTime() - Date.now();
            if (timeLeft > (config_1.default.otp.expiryMs - config_1.default.otp.resendIntervalMs)) {
                throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.TOO_MANY_REQUESTS, 'Please wait for 1 minute before requesting another OTP');
            }
        }
        const otp = this.generateOtp();
        const otpExpiry = new Date(Date.now() + config_1.default.otp.expiryMs); // 1 minute
        user.emailOtp = otp;
        user.emailOtpExpiry = otpExpiry;
        await user.save();
        await emailService_1.default.sendOtpEmail(email, otp);
    }
    static async verifyOtp(email, otp) {
        const user = await User_1.User.findOne({ email }).select('+emailOtp +emailOtpExpiry');
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        if (user.isEmailVerified) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Email is already verified');
        }
        if (!user.emailOtp || !user.emailOtpExpiry) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'No OTP found. Please request a new OTP');
        }
        if (user.emailOtpExpiry < new Date()) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'OTP has expired. Please request a new OTP');
        }
        if (user.emailOtp !== otp) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.BAD_REQUEST, 'Invalid OTP');
        }
        user.isEmailVerified = true;
        user.emailOtp = undefined;
        user.emailOtpExpiry = undefined;
        await user.save();
    }
}
exports.AuthService = AuthService;
