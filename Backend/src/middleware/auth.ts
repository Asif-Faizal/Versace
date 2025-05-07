import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';
import config from '../config/config';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from './errorHandler';

interface JwtPayload {
  userId: string;
  email: string;
  role: string;
}

declare global {
  namespace Express {
    interface Request {
      user?: {
        _id: string;
        email: string;
        role: string;
      };
    }
  }
}

export const authenticate = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'No token provided');
    }

    const token = authHeader.split(' ')[1];
    if (!config.jwtSecret) {
      throw new AppError(StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
    }

    const decoded = jwt.verify(token, config.jwtSecret) as JwtPayload;
    const user = await User.findById(decoded.userId).select('-password -refreshToken');

    if (!user) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'User not found');
    }

    req.user = {
      _id: user._id.toString(),
      email: user.email,
      role: user.role
    };

    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      next(new AppError(StatusCodes.UNAUTHORIZED, 'Invalid token'));
    } else {
      next(error);
    }
  }
};

export const authorize = (...roles: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user) {
      return next(new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated'));
    }

    if (!roles.includes(req.user.role)) {
      return next(new AppError(StatusCodes.FORBIDDEN, 'Not authorized'));
    }

    next();
  };
}; 