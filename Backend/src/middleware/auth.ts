import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';
import config from '../config/config';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from './errorHandler';

// In-memory token blacklist
const tokenBlacklist = new Set<string>();

declare global {
  namespace Express {
    interface Request {
      user?: any;
    }
  }
}

export const authenticate = async (req: Request, _res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'No token provided');
    }

    const token = authHeader.split(' ')[1];
    
    // Check if token is blacklisted
    if (tokenBlacklist.has(token)) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Token has been invalidated');
    }

    if (!config.jwtSecret) {
      throw new AppError(StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
    }

    const decoded = jwt.verify(token, config.jwtSecret) as any;
    
    // Check if token has expired
    if (decoded.exp * 1000 < Date.now()) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Token has expired');
    }

    const user = await User.findById(decoded.userId).select('-password');

    if (!user) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'User not found');
    }

    if (!user.isActive) {
      throw new AppError(StatusCodes.FORBIDDEN, 'User account is deactivated');
    }

    req.user = user;

    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      next(new AppError(StatusCodes.UNAUTHORIZED, 'Invalid token'));
    } else {
      next(error);
    }
  }
};

// Function to blacklist a token
export const blacklistToken = (token: string) => {
  tokenBlacklist.add(token);
};

export const authorize = (roles: string | string[]) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
    }

    // Allow all authenticated users to access cart operations
    if (req.path.includes('/cart')) {
      return next();
    }

    const userRole = req.user.role;
    const allowedRoles = Array.isArray(roles) ? roles : [roles];

    if (!allowedRoles.includes(userRole)) {
      throw new AppError(StatusCodes.FORBIDDEN, 'Not authorized to perform this action');
    }

    next();
  };
}; 