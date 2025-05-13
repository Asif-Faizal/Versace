"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authorize = exports.blacklistToken = exports.authenticate = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const User_1 = require("../models/User");
const config_1 = __importDefault(require("../config/config"));
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("./errorHandler");
// In-memory token blacklist
const tokenBlacklist = new Set();
const authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'No token provided');
        }
        const token = authHeader.split(' ')[1];
        // Check if token is blacklisted
        if (tokenBlacklist.has(token)) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Token has been invalidated');
        }
        if (!config_1.default.jwtSecret) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
        }
        const decoded = jsonwebtoken_1.default.verify(token, config_1.default.jwtSecret);
        // Check if token has expired
        if (decoded.exp * 1000 < Date.now()) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Token has expired');
        }
        const user = await User_1.User.findById(decoded.userId).select('-password -refreshToken');
        if (!user) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'User not found');
        }
        // Check if user's token expiry is set to epoch (logged out)
        if (user.tokenExpiry && user.tokenExpiry.getTime() === 0) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'User has been logged out');
        }
        req.user = {
            _id: user._id.toString(),
            email: user.email,
            role: user.role
        };
        next();
    }
    catch (error) {
        if (error instanceof jsonwebtoken_1.default.JsonWebTokenError) {
            next(new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid token'));
        }
        else {
            next(error);
        }
    }
};
exports.authenticate = authenticate;
// Function to blacklist a token
const blacklistToken = (token) => {
    tokenBlacklist.add(token);
};
exports.blacklistToken = blacklistToken;
const authorize = (...roles) => {
    return (req, res, next) => {
        if (!req.user) {
            return next(new errorHandler_1.AppError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated'));
        }
        if (!roles.includes(req.user.role)) {
            return next(new errorHandler_1.AppError(statusCodes_1.StatusCodes.FORBIDDEN, 'Not authorized'));
        }
        next();
    };
};
exports.authorize = authorize;
