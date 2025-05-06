export default {
  env: 'development',
  port: process.env.PORT || 5000,
  mongoUri: process.env.MONGO_URI || 'mongodb://localhost:27017/versace-dev',
  jwtSecret: process.env.JWT_SECRET || 'dev-secret-key',
  corsOrigin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  logLevel: 'debug',
  rateLimit: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // limit each IP to 100 requests per windowMs
  }
}; 