# Redis Implementation Guide

This document provides an overview of how Redis is implemented in the Versace Backend API for caching.

## Overview

Redis is used for caching frequently accessed data to improve performance and reduce database load. The implementation includes:

1. Caching for product endpoints
2. Caching for category endpoints
3. Cache invalidation on data modifications
4. Configurable cache expiry times

## Configuration

Redis configuration is stored in `.env` file:

```bash
# Redis Configuration
REDIS_URL=redis://localhost:6379
REDIS_CACHE_PRODUCTS=3600     # 1 hour (in seconds)
REDIS_CACHE_CATEGORIES=7200   # 2 hours (in seconds)
REDIS_CACHE_CART=86400        # 24 hours (in seconds)
```

## Implementation Details

### Redis Connection

A Redis connection is established in `utils/redis.ts` using the ioredis library. The connection is imported and initialized in `server.ts`.

### Caching Middleware

The `middleware/cache.ts` file provides:

1. `cacheMiddleware`: A middleware that caches GET requests and serves them from cache when available
2. `clearCache`: A utility function to invalidate cache by pattern

### Routes with Caching

The following routes use caching:

```typescript
// Product routes
router.get('/', authenticate, queryValidation, cacheMiddleware('products'), ProductController.getAllProducts);
router.get('/new', authenticate, queryValidation, cacheMiddleware('products'), ProductController.getNewProducts);
router.get('/trending', authenticate, queryValidation, cacheMiddleware('products'), ProductController.getTrendingProducts);
router.get('/category/:categoryId', authenticate, cacheMiddleware('products'), ProductController.getProductsByCategory);
router.get('/subcategory/:subCategoryId', authenticate, cacheMiddleware('products'), ProductController.getProductsBySubCategory);
router.get('/:id', authenticate, cacheMiddleware('products'), ProductController.getProduct);

// Category routes
router.get('/', authenticate, cacheMiddleware('categories'), CategoryController.getAllCategories);
router.get('/:id', authenticate, cacheMiddleware('categories'), CategoryController.getCategory);
```

### Cache Invalidation

Cache is invalidated in the controllers when data is modified:

1. Product cache is cleared when products are created, updated, or deleted
2. Category cache is cleared when categories are created, updated, or deleted
3. Cart cache for a specific user is cleared when their cart is modified

## Extending Cache Support

To add caching for other routes:

1. Import the cache middleware: `import { cacheMiddleware } from '../middleware/cache';`
2. Add the middleware to the route: `router.get('/path', cacheMiddleware('cacheKeyName'), Controller.method);`
3. Add the cache expiry time to the config:

   ```typescript
   redis: {
     cacheExpiry: {
       // Add your new cache key here
       newCacheKey: parseInt(process.env.REDIS_CACHE_NEWKEY || '3600', 10),
     }
   }
   ```

4. Implement cache invalidation in the relevant controllers

## Best Practices

1. Use cache only for read-heavy data that doesn't change frequently
2. Always invalidate cache when the underlying data changes
3. Set appropriate expiry times based on data volatility
4. Monitor Redis memory usage in production
