import { Request, Response, NextFunction } from 'express';
import { StatusCodes, StatusCode } from '../utils/statusCodes';
import logger from '../utils/logger';

export class AppError extends Error {
  constructor(
    public status: StatusCode,
    message: string,
    public isOperational = true
  ) {
    super(message);
    this.name = 'AppError';
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  err: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  // Default error values
  let status: StatusCode = StatusCodes.INTERNAL_SERVER_ERROR;
  let message = 'Something went wrong!';
  let isOperational = true;

  // Handle AppError instances
  if (err instanceof AppError) {
    status = err.status;
    message = err.message;
    isOperational = err.isOperational;
  }

  // Handle Mongoose validation errors
  if (err.name === 'ValidationError') {
    status = StatusCodes.BAD_REQUEST;
    message = Object.values((err as any).errors).map((val: any) => val.message).join(', ');
  }

  // Handle Mongoose duplicate key errors
  if (err.name === 'MongoError' && (err as any).code === 11000) {
    status = StatusCodes.CONFLICT;
    message = 'Duplicate field value entered';
  }

  // Handle JWT errors
  if (err.name === 'JsonWebTokenError') {
    status = StatusCodes.UNAUTHORIZED;
    message = 'Invalid token';
  }

  if (err.name === 'TokenExpiredError') {
    status = StatusCodes.UNAUTHORIZED;
    message = 'Token expired';
  }

  // Log error
  logger.error('Error occurred:', {
    error: err.message,
    stack: err.stack,
    status,
    path: req.path,
    method: req.method,
    body: req.body,
    query: req.query,
    params: req.params,
    user: req.user,
    isOperational
  });

  // Send error response
  res.status(status).json({
    error: {
      message,
      status,
      path: req.path,
      timestamp: new Date().toISOString(),
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    }
  });
}; 