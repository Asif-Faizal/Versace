import express from 'express';
import mongoose from 'mongoose';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import config from './config';
import logger, { requestLogger, errorLogger } from './utils/logger';

const app = express();

// Security middleware
app.use(helmet());
app.use(compression());

// Rate limiting
app.use(rateLimit(config.rateLimit));

// Request logging middleware
app.use(requestLogger);

// Basic middleware
app.use(express.json());
app.use(cookieParser());
app.use(cors({
  origin: config.corsOrigin,
  credentials: true
}));

// Health check route
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Error handling middleware
app.use(errorLogger);
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  res.status(500).json({ error: 'Something went wrong!' });
});

// Connect to MongoDB and start server
const startServer = async () => {
  try {
    if (!config.mongoUri) {
      throw new Error('MongoDB URI is not defined');
    }
    await mongoose.connect(config.mongoUri);
    logger.info('✅ MongoDB connected');

    app.listen(config.port, () => {
      logger.info(`🚀 Server running in ${config.env} mode on port ${config.port}`);
    });
  } catch (err) {
    logger.error('❌ Failed to connect to MongoDB:', err);
    process.exit(1);
  }
};

// Handle unhandled promise rejections
process.on('unhandledRejection', (err: Error) => {
  logger.error('Unhandled Promise Rejection:', err);
  process.exit(1);
});

startServer(); 