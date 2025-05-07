import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../services/authService';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

export class AuthController {
  static async register(req: Request, res: Response, next: NextFunction) {
    try {
      const result = await AuthService.register(req.body);
      res.status(StatusCodes.CREATED).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async login(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password } = req.body;
      const result = await AuthService.login(email, password);
      res.status(StatusCodes.OK).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = req.body;
      const result = await AuthService.refreshTokens(refreshToken);
      res.status(StatusCodes.OK).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async logout(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      await AuthService.logout(req.user._id);
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }

  static async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      const result = await AuthService.updateUser(req.user._id, req.body);
      res.status(StatusCodes.OK).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async deleteAccount(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      await AuthService.deleteUser(req.user._id);
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }
}