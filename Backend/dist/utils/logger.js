"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorLogger = exports.requestLogger = void 0;
const winston_1 = __importDefault(require("winston"));
const config_1 = __importDefault(require("../config/config"));
// Create the logger instance
const logger = winston_1.default.createLogger({
    level: config_1.default.logLevel,
    format: winston_1.default.format.combine(winston_1.default.format.timestamp(), winston_1.default.format.json()),
    transports: [
        new winston_1.default.transports.Console({
            format: winston_1.default.format.combine(winston_1.default.format.colorize(), winston_1.default.format.simple())
        })
    ]
});
// Add file transports for production
if (config_1.default.env === 'production') {
    logger.add(new winston_1.default.transports.File({ filename: 'error.log', level: 'error' }));
    logger.add(new winston_1.default.transports.File({ filename: 'combined.log' }));
}
// Request logging middleware
const requestLogger = (req, res, next) => {
    const start = Date.now();
    // Log request
    logger.info('Incoming Request', {
        method: req.method,
        url: req.url,
        query: req.query,
        body: req.body,
        ip: req.ip,
        userAgent: req.get('user-agent')
    });
    // Capture response
    const originalSend = res.send;
    res.send = function (body) {
        const responseTime = Date.now() - start;
        // Log response
        logger.info('Outgoing Response', {
            method: req.method,
            url: req.url,
            statusCode: res.statusCode,
            responseTime: `${responseTime}ms`,
            body: body
        });
        return originalSend.call(this, body);
    };
    next();
};
exports.requestLogger = requestLogger;
// Error logging middleware
const errorLogger = (err, req, res, next) => {
    logger.error('Error occurred', {
        error: err.message,
        stack: err.stack,
        method: req.method,
        url: req.url,
        body: req.body,
        query: req.query,
        ip: req.ip
    });
    next(err);
};
exports.errorLogger = errorLogger;
exports.default = logger;
