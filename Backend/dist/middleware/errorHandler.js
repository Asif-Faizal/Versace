"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
const statusCodes_1 = require("../utils/statusCodes");
const logger_1 = __importDefault(require("../utils/logger"));
const errorHandler = (err, req, res, next) => {
    const status = err.status || statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR;
    const message = err.message || 'Something went wrong!';
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
        user: req.user
    });
    // Send error response
    res.status(status).json({
        error: {
            message,
            status,
            path: req.path,
            timestamp: new Date().toISOString()
        }
    });
};
exports.errorHandler = errorHandler;
