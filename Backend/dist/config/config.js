"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// src/config.ts
const dotenv_1 = __importDefault(require("dotenv"));
const envFile = process.env.NODE_ENV === 'production' ? '.env.production' : '.env.development';
dotenv_1.default.config({ path: envFile });
if (!process.env.MONGO_URI || !process.env.JWT_SECRET) {
    throw new Error('Required environment variables are missing');
}
exports.default = {
    env: process.env.NODE_ENV || 'development',
    port: process.env.PORT ? parseInt(process.env.PORT, 10) : 5000,
    mongoUri: process.env.MONGO_URI,
    jwtSecret: process.env.JWT_SECRET,
    corsOrigin: process.env.CORS_ORIGIN,
    logLevel: process.env.LOG_LEVEL || 'info',
    rateLimit: {
        windowMs: process.env.RATE_LIMIT_WINDOW_MS ? parseInt(process.env.RATE_LIMIT_WINDOW_MS, 10) : 15 * 60 * 1000,
        max: process.env.RATE_LIMIT_MAX ? parseInt(process.env.RATE_LIMIT_MAX, 10) : 100,
    },
    jwt: {
        accessTokenExpiry: process.env.ACCESS_TOKEN_EXPIRY || '15m',
        refreshTokenExpiry: process.env.REFRESH_TOKEN_EXPIRY || '7d',
    }
};
