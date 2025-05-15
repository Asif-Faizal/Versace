"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.clearCache = exports.cacheMiddleware = void 0;
const redis_1 = __importDefault(require("../utils/redis"));
const config_1 = __importDefault(require("../config/config"));
const logger_1 = __importDefault(require("../utils/logger"));
/**
 * Middleware to cache responses
 * @param cacheKey - Key prefix for the cache (e.g., 'products', 'categories')
 * @param ttl - Cache expiry time in seconds (optional, defaults to config value)
 */
const cacheMiddleware = (cacheKey) => {
    return async (req, res, next) => {
        // Skip caching for non-GET requests
        if (req.method !== 'GET') {
            return next();
        }
        // Create a unique cache key based on the URL and query parameters
        const fullCacheKey = `${cacheKey}:${req.originalUrl}`;
        try {
            // Try to get data from cache
            const cachedData = await redis_1.default.get(fullCacheKey);
            if (cachedData) {
                // If cache exists, send it
                logger_1.default.debug(`Cache hit for ${fullCacheKey}`);
                return res.json(JSON.parse(cachedData));
            }
            // If no cache, create custom response method to capture and cache the response
            const originalSend = res.json;
            // Override res.json with properly typed function
            res.json = function (body) {
                // Skip caching if the response is an error
                if (res.statusCode >= 400) {
                    return originalSend.call(this, body);
                }
                // Store the response in Redis cache
                const ttl = config_1.default.redis.cacheExpiry[cacheKey];
                redis_1.default.setex(fullCacheKey, ttl, JSON.stringify(body))
                    .catch((err) => logger_1.default.error(`Failed to cache ${fullCacheKey}:`, err));
                logger_1.default.debug(`Cache set for ${fullCacheKey}`);
                return originalSend.call(this, body);
            };
            next();
        }
        catch (err) {
            logger_1.default.error(`Redis cache error for ${fullCacheKey}:`, err);
            next(); // Continue without caching on error
        }
    };
};
exports.cacheMiddleware = cacheMiddleware;
/**
 * Clear cache by key prefix
 * @param keyPattern - Pattern to match cache keys to invalidate (e.g., 'products:*')
 */
const clearCache = async (keyPattern) => {
    try {
        const keys = await redis_1.default.keys(keyPattern);
        if (keys.length > 0) {
            await redis_1.default.del(...keys);
            logger_1.default.debug(`Cleared cache for pattern ${keyPattern}, ${keys.length} keys removed`);
        }
    }
    catch (err) {
        logger_1.default.error(`Failed to clear cache for pattern ${keyPattern}:`, err);
    }
};
exports.clearCache = clearCache;
