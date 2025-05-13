"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = exports.AppError = void 0;
const statusCodes_1 = require("../utils/statusCodes");
const logger_1 = __importDefault(require("../utils/logger"));
class AppError extends Error {
    constructor(status, message, isOperational = true) {
        super(message);
        this.status = status;
        this.isOperational = isOperational;
        this.name = 'AppError';
        Error.captureStackTrace(this, this.constructor);
    }
}
exports.AppError = AppError;
const errorHandler = (err, req, res, next) => {
    // Default error values
    let status = statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR;
    let message = 'Something went wrong!';
    let isOperational = true;
    // Handle AppError instances
    if (err instanceof AppError) {
        status = err.status;
        message = err.message;
        isOperational = err.isOperational;
    }
    // Handle Mongoose validation errors
    if (err.name === 'ValidationError') {
        status = statusCodes_1.StatusCodes.BAD_REQUEST;
        message = Object.values(err.errors).map((val) => val.message).join(', ');
    }
    // Handle Mongoose duplicate key errors
    if (err.name === 'MongoError' && err.code === 11000) {
        status = statusCodes_1.StatusCodes.CONFLICT;
        message = 'Duplicate field value entered';
    }
    // Handle JWT errors
    if (err.name === 'JsonWebTokenError') {
        status = statusCodes_1.StatusCodes.UNAUTHORIZED;
        message = 'Invalid token';
    }
    if (err.name === 'TokenExpiredError') {
        status = statusCodes_1.StatusCodes.UNAUTHORIZED;
        message = 'Token expired';
    }
    // Log error
    logger_1.default.error('Error occurred:', {
        error: err.message,
        stack: err.stack,
        status,
        path: req.path,
        method: req.method,
        body: req.body,
        query: req.query,
        params: req.params,
        user: req.user,
        isOperational
    });
    // Send error response
    res.status(status).json({
        error: {
            message,
            status,
            path: req.path,
            timestamp: new Date().toISOString(),
            ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
        }
    });
};
exports.errorHandler = errorHandler;
