import jwt, { SignOptions } from 'jsonwebtoken';
import { User, IUser } from '../models/User';
import config from '../config/config';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

interface TokenPayload {
  userId: string;
  email: string;
  role: string;
}

interface AuthResponse {
  user: {
    _id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: string;
  };
  accessToken: string;
  refreshToken: string;
}

export class AuthService {
  private static generateTokens(user: IUser): { accessToken: string; refreshToken: string } {
    if (!config.jwtSecret) {
      throw new AppError(StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
    }

    const payload: TokenPayload = {
      userId: user._id.toString(),
      email: user.email,
      role: user.role
    };

    const signOptions: SignOptions = {
      expiresIn: config.jwt.accessTokenExpiry as jwt.SignOptions['expiresIn']
    };

    const accessToken = jwt.sign(payload, config.jwtSecret as jwt.Secret, signOptions);

    const refreshSignOptions: SignOptions = {
      expiresIn: config.jwt.refreshTokenExpiry as jwt.SignOptions['expiresIn']
    };

    const refreshToken = jwt.sign(payload, config.jwtSecret as jwt.Secret, refreshSignOptions);

    return { accessToken, refreshToken };
  }

  static async register(userData: {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
  }): Promise<AuthResponse> {
    const existingUser = await User.findOne({ email: userData.email });
    if (existingUser) {
      throw new AppError(StatusCodes.CONFLICT, 'Email already registered');
    }

    const user = await User.create(userData);
    const tokens = this.generateTokens(user);

    user.refreshToken = tokens.refreshToken;
    await user.save();

    return {
      user: {
        _id: user._id.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role
      },
      ...tokens
    };
  }

  static async login(email: string, password: string): Promise<AuthResponse> {
    const user = await User.findOne({ email });
    if (!user) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid credentials');
    }

    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid credentials');
    }

    const tokens = this.generateTokens(user);

    user.refreshToken = tokens.refreshToken;
    await user.save();

    return {
      user: {
        _id: user._id.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role
      },
      ...tokens
    };
  }

  static async refreshTokens(refreshToken: string): Promise<AuthResponse> {
    if (!config.jwtSecret) {
      throw new AppError(StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
    }

    try {
      const decoded = jwt.verify(refreshToken, config.jwtSecret) as TokenPayload;
      const user = await User.findById(decoded.userId);

      if (!user || user.refreshToken !== refreshToken) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
      }

      const tokens = this.generateTokens(user);

      user.refreshToken = tokens.refreshToken;
      await user.save();

      return {
        user: {
          _id: user._id.toString(),
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          role: user.role
        },
        ...tokens
      };
    } catch (error) {
      if (error instanceof jwt.JsonWebTokenError) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
      }
      throw error;
    }
  }

  static async logout(userId: string): Promise<void> {
    const user = await User.findByIdAndUpdate(userId, { refreshToken: null });
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }
  }

  static async updateUser(userId: string, updateData: Partial<IUser>): Promise<AuthResponse> {
    const user = await User.findById(userId);
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    // Prevent updating sensitive fields
    const { password, role, refreshToken, ...safeUpdateData } = updateData;
    Object.assign(user, safeUpdateData);
    await user.save();

    const tokens = this.generateTokens(user);

    return {
      user: {
        _id: user._id.toString(),
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role
      },
      ...tokens
    };
  }

  static async deleteUser(userId: string): Promise<void> {
    const result = await User.findByIdAndDelete(userId);
    if (!result) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }
  }
} 