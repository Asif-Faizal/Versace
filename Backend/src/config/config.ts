// src/config.ts
import dotenv from 'dotenv';

const envFile = process.env.NODE_ENV === 'production' ? '.env.production' : '.env.development';
dotenv.config({ path: envFile });

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
];

// Check for missing variables
requiredEnvVars.forEach((name) => {
  if (!process.env[name]) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
});

export default {
  env: process.env.NODE_ENV,
  port: parseInt(process.env.PORT!, 10),
  mongoUri: process.env.MONGO_URI!,
  jwtSecret: process.env.JWT_SECRET!,
  corsOrigin: process.env.CORS_ORIGIN!,
  logLevel: process.env.LOG_LEVEL!,
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS!, 10),
    max: parseInt(process.env.RATE_LIMIT_MAX!, 10),
  },
  jwt: {
    accessTokenExpiry: process.env.ACCESS_TOKEN_EXPIRY!,
    refreshTokenExpiry: process.env.REFRESH_TOKEN_EXPIRY!,
  },
} as const;
