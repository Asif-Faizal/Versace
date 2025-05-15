import { Request, Response, NextFunction } from 'express';
import redisClient from '../utils/redis';
import config from '../config/config';
import logger from '../utils/logger';

/**
 * Middleware to cache responses
 * @param cacheKey - Key prefix for the cache (e.g., 'products', 'categories')
 * @param ttl - Cache expiry time in seconds (optional, defaults to config value)
 */
export const cacheMiddleware = (cacheKey: keyof typeof config.redis.cacheExpiry) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    // Skip caching for non-GET requests
    if (req.method !== 'GET') {
      return next();
    }

    // Create a unique cache key based on the URL and query parameters
    const fullCacheKey = `${cacheKey}:${req.originalUrl}`;
    
    try {
      // Try to get data from cache
      const cachedData = await redisClient.get(fullCacheKey);
      
      if (cachedData) {
        // If cache exists, send it
        logger.debug(`Cache hit for ${fullCacheKey}`);
        return res.json(JSON.parse(cachedData));
      }
      
      // If no cache, create custom response method to capture and cache the response
      const originalSend = res.json;
      
      // Override res.json with properly typed function
      res.json = function(this: Response, body: any) {
        // Skip caching if the response is an error
        if (res.statusCode >= 400) {
          return originalSend.call(this, body);
        }
        
        // Store the response in Redis cache
        const ttl = config.redis.cacheExpiry[cacheKey];
        redisClient.setex(fullCacheKey, ttl, JSON.stringify(body))
          .catch((err) => logger.error(`Failed to cache ${fullCacheKey}:`, err));
        
        logger.debug(`Cache set for ${fullCacheKey}`);
        return originalSend.call(this, body);
      } as any;
      
      next();
    } catch (err) {
      logger.error(`Redis cache error for ${fullCacheKey}:`, err);
      next(); // Continue without caching on error
    }
  };
};

/**
 * Clear cache by key prefix
 * @param keyPattern - Pattern to match cache keys to invalidate (e.g., 'products:*')
 */
export const clearCache = async (keyPattern: string): Promise<void> => {
  try {
    const keys = await redisClient.keys(keyPattern);
    
    if (keys.length > 0) {
      await redisClient.del(...keys);
      logger.debug(`Cleared cache for pattern ${keyPattern}, ${keys.length} keys removed`);
    }
  } catch (err) {
    logger.error(`Failed to clear cache for pattern ${keyPattern}:`, err);
  }
}; 