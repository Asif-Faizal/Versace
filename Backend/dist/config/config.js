"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/config.ts
const dotenv_1 = __importDefault(require("dotenv"));
const envFile = process.env.NODE_ENV === 'production' ? '.env.production' : '.env.development';
dotenv_1.default.config({ path: envFile });
// List of required environment variables
const requiredEnvVars = [
    'NODE_ENV',
    'PORT',
    'MONGO_URI',
    'JWT_SECRET',
    'CORS_ORIGIN',
    'LOG_LEVEL',
    'RATE_LIMIT_WINDOW_MS',
    'RATE_LIMIT_MAX',
    'ACCESS_TOKEN_EXPIRY',
    'REFRESH_TOKEN_EXPIRY',
    'EMAIL_HOST',
    'EMAIL_PORT',
    'EMAIL_USER',
    'EMAIL_PASSWORD',
    'EMAIL_FROM',
    'ADMIN_CREATION_TOKEN',
    'REDIS_URL'
];
// Check for missing variables
requiredEnvVars.forEach((name) => {
    if (!process.env[name]) {
        throw new Error(`Missing required environment variable: ${name}`);
    }
});
exports.default = {
    env: process.env.NODE_ENV,
    port: parseInt(process.env.PORT, 10),
    mongoUri: process.env.MONGO_URI,
    jwtSecret: process.env.JWT_SECRET,
    corsOrigin: process.env.CORS_ORIGIN,
    logLevel: process.env.LOG_LEVEL,
    rateLimit: {
        windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10),
        max: parseInt(process.env.RATE_LIMIT_MAX, 10),
    },
    jwt: {
        accessTokenExpiry: process.env.ACCESS_TOKEN_EXPIRY,
        refreshTokenExpiry: process.env.REFRESH_TOKEN_EXPIRY,
    },
    email: {
        host: process.env.EMAIL_HOST,
        port: parseInt(process.env.EMAIL_PORT, 10),
        secure: process.env.EMAIL_SECURE === 'true',
        user: process.env.EMAIL_USER,
        password: process.env.EMAIL_PASSWORD,
        from: process.env.EMAIL_FROM
    },
    otp: {
        expiryMs: 60 * 1000,
        resendIntervalMs: 60 * 1000
    },
    redis: {
        url: process.env.REDIS_URL,
        cacheExpiry: {
            products: parseInt(process.env.REDIS_CACHE_PRODUCTS || '3600', 10), // 1 hour default
            categories: parseInt(process.env.REDIS_CACHE_CATEGORIES || '7200', 10), // 2 hours default
            cart: parseInt(process.env.REDIS_CACHE_CART || '86400', 10), // 24 hours default
        }
    },
    adminCreationToken: process.env.ADMIN_CREATION_TOKEN
};
