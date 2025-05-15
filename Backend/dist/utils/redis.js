"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ioredis_1 = require("ioredis");
const config_1 = __importDefault(require("../config/config"));
const logger_1 = __importDefault(require("./logger"));
// Create Redis client
const redisClient = new ioredis_1.Redis(config_1.default.redis.url, {
    retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
    }
});
// Events
redisClient.on('connect', () => {
    logger_1.default.info('✅ Redis connected');
});
redisClient.on('error', (err) => {
    logger_1.default.error('❌ Redis error:', err);
});
exports.default = redisClient;
