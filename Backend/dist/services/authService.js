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
class AuthError extends Error {
    constructor(status, message) {
        super(message);
        this.status = status;
        this.name = 'AuthError';
    }
}
class AuthService {
    static generateTokens(user) {
        if (!config_1.default.jwtSecret) {
            throw new AuthError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
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
    static async register(userData) {
        const existingUser = await User_1.User.findOne({ email: userData.email });
        if (existingUser) {
            throw new AuthError(statusCodes_1.StatusCodes.CONFLICT, 'Email already registered');
        }
        const user = await User_1.User.create(userData);
        const tokens = this.generateTokens(user);
        user.refreshToken = tokens.refreshToken;
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
    static async login(email, password) {
        const user = await User_1.User.findOne({ email });
        if (!user) {
            throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid credentials');
        }
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid credentials');
        }
        const tokens = this.generateTokens(user);
        user.refreshToken = tokens.refreshToken;
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
    static async refreshTokens(refreshToken) {
        if (!config_1.default.jwtSecret) {
            throw new AuthError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
        }
        try {
            const decoded = jsonwebtoken_1.default.verify(refreshToken, config_1.default.jwtSecret);
            const user = await User_1.User.findById(decoded.userId);
            if (!user || user.refreshToken !== refreshToken) {
                throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
            }
            const tokens = this.generateTokens(user);
            user.refreshToken = tokens.refreshToken;
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
                throw new AuthError(statusCodes_1.StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
            }
            throw error;
        }
    }
    static async logout(userId) {
        const user = await User_1.User.findByIdAndUpdate(userId, { refreshToken: null });
        if (!user) {
            throw new AuthError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
    }
    static async updateUser(userId, updateData) {
        const user = await User_1.User.findById(userId);
        if (!user) {
            throw new AuthError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
        // Prevent updating sensitive fields
        const { password, role, refreshToken, ...safeUpdateData } = updateData;
        Object.assign(user, safeUpdateData);
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
    static async deleteUser(userId) {
        const result = await User_1.User.findByIdAndDelete(userId);
        if (!result) {
            throw new AuthError(statusCodes_1.StatusCodes.NOT_FOUND, 'User not found');
        }
    }
}
exports.AuthService = AuthService;
