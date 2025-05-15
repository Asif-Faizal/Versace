import { Redis } from 'ioredis';
import config from '../config/config';
import logger from './logger';

// Create Redis client
const redisClient = new Redis(config.redis.url, {
  retryStrategy: (times) => {
    const delay = Math.min(times * 50, 2000);
    return delay;
  }
});

// Events
redisClient.on('connect', () => {
  logger.info('✅ Redis connected');
});

redisClient.on('error', (err) => {
  logger.error('❌ Redis error:', err);
});

export default redisClient; 