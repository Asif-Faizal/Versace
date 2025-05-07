"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authorize = exports.authenticate = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const User_1 = require("../models/User");
const config_1 = __importDefault(require("../config/config"));
const statusCodes_1 = require("../utils/statusCodes");
class AuthError extends Error {
    constructor(status, message) {
        super(message);
        this.status = status;
        this.name = 'AuthError';
    }
}
const authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
            throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'No token provided');
        }
        const token = authHeader.split(' ')[1];
        if (!config_1.default.jwtSecret) {
            throw new AuthError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
        }
        const decoded = jsonwebtoken_1.default.verify(token, config_1.default.jwtSecret);
        const user = await User_1.User.findById(decoded.userId).select('-password -refreshToken');
        if (!user) {
            throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'User not found');
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
            next(new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid token'));
        }
        else {
            next(error);
        }
    }
};
exports.authenticate = authenticate;
const authorize = (...roles) => {
    return (req, res, next) => {
        if (!req.user) {
            return next(new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Not authenticated'));
        }
        if (!roles.includes(req.user.role)) {
            return next(new AuthError(statusCodes_1.StatusCodes.FORBIDDEN, 'Not authorized'));
        }
        next();
    };
};
exports.authorize = authorize;
