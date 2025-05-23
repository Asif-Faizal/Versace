import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../services/authService';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

export class AuthController {
  private static getDeviceInfo(req: Request) {
    return {
      deviceId: req.headers['deviceid'] as string,
      deviceModel: req.headers['devicemodel'] as string,
      deviceOs: req.headers['deviceos'] as string
    };
  }

  static async register(req: Request, res: Response, next: NextFunction) {
    try {
      const deviceInfo = AuthController.getDeviceInfo(req);
      const result = await AuthService.register({
        ...req.body,
        ...deviceInfo
      });
      res.status(StatusCodes.CREATED).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async login(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, password } = req.body;
      const deviceInfo = AuthController.getDeviceInfo(req);
      const result = await AuthService.login(email, password, deviceInfo);
      res.status(StatusCodes.OK).json(result);
    } catch (error) {
      next(error);
    }
  }

  static async refreshToken(req: Request, res: Response, next: NextFunction) {
    try {
      const { refreshToken } = req.body;
      const deviceInfo = AuthController.getDeviceInfo(req);
      const result = await AuthService.refreshTokens(refreshToken, deviceInfo);
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
      const deviceInfo = AuthController.getDeviceInfo(req);
      const accessToken = req.headers.authorization?.split(' ')[1];
      await AuthService.logout(req.user._id, deviceInfo, accessToken);
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
      const deviceInfo = AuthController.getDeviceInfo(req);
      const result = await AuthService.updateUser(req.user._id, req.body, deviceInfo);
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
      const { password } = req.body;
      if (!password) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Password is required for account deletion');
      }
      const deviceInfo = AuthController.getDeviceInfo(req);
      const accessToken = req.headers.authorization?.split(' ')[1];
      await AuthService.deleteUser(req.user._id, password, deviceInfo, accessToken);
      res.status(StatusCodes.NO_CONTENT).send();
    } catch (error) {
      next(error);
    }
  }

  static async sendOtp(req: Request, res: Response, next: NextFunction) {
    try {
      const { email } = req.body;
      await AuthService.sendOtp(email);
      res.status(StatusCodes.OK).json({ message: 'OTP sent successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async verifyOtp(req: Request, res: Response, next: NextFunction) {
    try {
      const { email, otp } = req.body;
      await AuthService.verifyOtp(email, otp);
      res.status(StatusCodes.OK).json({ message: 'Email verified successfully' });
    } catch (error) {
      next(error);
    }
  }

  static async getUserDetails(req: Request, res: Response, next: NextFunction) {
    try {
      if (!req.user?._id) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Not authenticated');
      }
      // Get device info from headers
      const deviceInfo = AuthController.getDeviceInfo(req);
      if (!deviceInfo.deviceId) {
        throw new AppError(StatusCodes.BAD_REQUEST, 'Device ID header is required');
      }
      // Fetch user details from DB
      const { User } = await import('../models/User');
      const user = await User.findById(req.user._id).select('-password -refreshToken');
      if (!user) {
        throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
      }
      // Check for deviceId mismatch
      if (user.lastUsedDeviceId && user.lastUsedDeviceId !== deviceInfo.deviceId) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Device ID mismatch');
      }
      res.status(StatusCodes.OK).json({
        _id: user._id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        isActive: user.isActive,
        isEmailVerified: user.isEmailVerified,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      });
    } catch (error) {
      next(error);
    }
  }

  static async createAdmin(req: Request, res: Response, next: NextFunction) {
    try {
      const { adminCreationToken, ...userData } = req.body;
      const result = await AuthService.createAdmin(userData, adminCreationToken);
      res.status(StatusCodes.CREATED).json(result);
    } catch (error) {
      next(error);
    }
  }
}