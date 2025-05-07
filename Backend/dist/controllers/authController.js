"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const authService_1 = require("../services/authService");
const statusCodes_1 = require("../utils/statusCodes");
class AuthController {
    static async register(req, res, next) {
        try {
            const result = await authService_1.AuthService.register(req.body);
            res.status(statusCodes_1.StatusCodes.CREATED).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async login(req, res, next) {
        try {
            const { email, password } = req.body;
            const result = await authService_1.AuthService.login(email, password);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async refreshToken(req, res, next) {
        try {
            const { refreshToken } = req.body;
            const result = await authService_1.AuthService.refreshTokens(refreshToken);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async logout(req, res, next) {
        try {
            if (!req.user?._id) {
                throw { status: statusCodes_1.StatusCodes.UNAUTHORIZED, message: 'Not authenticated' };
            }
            await authService_1.AuthService.logout(req.user._id);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
    static async updateProfile(req, res, next) {
        try {
            if (!req.user?._id) {
                throw { status: statusCodes_1.StatusCodes.UNAUTHORIZED, message: 'Not authenticated' };
            }
            const result = await authService_1.AuthService.updateUser(req.user._id, req.body);
            res.status(statusCodes_1.StatusCodes.OK).json(result);
        }
        catch (error) {
            next(error);
        }
    }
    static async deleteAccount(req, res, next) {
        try {
            if (!req.user?._id) {
                throw { status: statusCodes_1.StatusCodes.UNAUTHORIZED, message: 'Not authenticated' };
            }
            await authService_1.AuthService.deleteUser(req.user._id);
            res.status(statusCodes_1.StatusCodes.NO_CONTENT).send();
        }
        catch (error) {
            next(error);
        }
    }
}
exports.AuthController = AuthController;
