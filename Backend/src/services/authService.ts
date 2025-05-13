import jwt, { SignOptions } from 'jsonwebtoken';
import { User, IUser } from '../models/User';
import config from '../config/config';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';
import { blacklistToken } from '../middleware/auth';
import EmailService from './emailService';

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

interface DeviceInfo {
  deviceId?: string;
  deviceModel?: string;
  deviceOs?: string;
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

  private static validateDevice(user: IUser, deviceInfo?: DeviceInfo): void {
    if (!deviceInfo?.deviceId) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Device ID is required');
    }

    if (user.lastUsedDeviceId && user.lastUsedDeviceId !== deviceInfo.deviceId) {
      throw new AppError(StatusCodes.FORBIDDEN, 'Access denied: Device mismatch');
    }
  }

  static async register(userData: {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    deviceId?: string;
    deviceModel?: string;
    deviceOs?: string;
  }): Promise<AuthResponse> {
    const existingUser = await User.findOne({ email: userData.email });
    if (existingUser) {
      throw new AppError(StatusCodes.CONFLICT, 'Email already registered');
    }

    const user = await User.create(userData);
    const tokens = this.generateTokens(user);

    user.refreshToken = tokens.refreshToken;
    user.lastUsedDeviceId = userData.deviceId;
    user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
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

  static async login(email: string, password: string, deviceInfo?: DeviceInfo): Promise<AuthResponse> {
    const user = await User.findOne({ email });
    if (!user) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid credentials');
    }

    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid credentials');
    }

    this.validateDevice(user, deviceInfo);

    // Update device information if provided
    if (deviceInfo) {
      user.deviceId = deviceInfo.deviceId;
      user.deviceModel = deviceInfo.deviceModel;
      user.deviceOs = deviceInfo.deviceOs;
      user.lastUsedDeviceId = deviceInfo.deviceId;
    }

    const tokens = this.generateTokens(user);

    user.refreshToken = tokens.refreshToken;
    user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
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

  static async refreshTokens(refreshToken: string, deviceInfo?: DeviceInfo): Promise<AuthResponse> {
    if (!config.jwtSecret) {
      throw new AppError(StatusCodes.INTERNAL_SERVER_ERROR, 'JWT secret is not configured');
    }

    try {
      const decoded = jwt.verify(refreshToken, config.jwtSecret) as TokenPayload;
      const user = await User.findById(decoded.userId).select('+refreshToken');

      if (!user || user.refreshToken !== refreshToken) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid refresh token');
      }

      // Check if token has expired
      if (user.tokenExpiry && user.tokenExpiry < new Date()) {
        throw new AppError(StatusCodes.UNAUTHORIZED, 'Token has expired');
      }

      this.validateDevice(user, deviceInfo);

      // Update device information if provided
      if (deviceInfo) {
        user.deviceId = deviceInfo.deviceId;
        user.deviceModel = deviceInfo.deviceModel;
        user.deviceOs = deviceInfo.deviceOs;
        user.lastUsedDeviceId = deviceInfo.deviceId;
      }

      const tokens = this.generateTokens(user);

      user.refreshToken = tokens.refreshToken;
      user.tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours from now
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

  static async logout(userId: string, deviceInfo?: DeviceInfo, accessToken?: string): Promise<void> {
    const user = await User.findById(userId);
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    this.validateDevice(user, deviceInfo);

    // Update device information if provided
    if (deviceInfo) {
      user.deviceId = deviceInfo.deviceId;
      user.deviceModel = deviceInfo.deviceModel;
      user.deviceOs = deviceInfo.deviceOs;
    }

    // Invalidate tokens
    user.refreshToken = undefined;
    user.tokenExpiry = new Date(0); // Set to epoch time to ensure token is expired
    
    // Blacklist the access token if provided
    if (accessToken) {
      blacklistToken(accessToken);
    }

    await user.save();
  }

  static async updateUser(userId: string, updateData: Partial<IUser>, deviceInfo?: DeviceInfo): Promise<AuthResponse> {
    const user = await User.findById(userId);
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    this.validateDevice(user, deviceInfo);

    // Prevent updating sensitive fields
    const { password, role, refreshToken, ...safeUpdateData } = updateData;
    Object.assign(user, safeUpdateData);

    // Update device information if provided
    if (deviceInfo) {
      user.deviceId = deviceInfo.deviceId;
      user.deviceModel = deviceInfo.deviceModel;
      user.deviceOs = deviceInfo.deviceOs;
      user.lastUsedDeviceId = deviceInfo.deviceId;
    }

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

  static async deleteUser(
    userId: string, 
    password: string, 
    deviceInfo?: DeviceInfo, 
    accessToken?: string
  ): Promise<void> {
    const user = await User.findById(userId).select('+password');
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    // Verify password
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      throw new AppError(StatusCodes.UNAUTHORIZED, 'Invalid password');
    }

    // Validate device
    this.validateDevice(user, deviceInfo);

    // Log device information before deletion if provided
    if (deviceInfo) {
      console.log(`User deleted from device: ${deviceInfo.deviceId}, Model: ${deviceInfo.deviceModel}, OS: ${deviceInfo.deviceOs}`);
    }

    // Blacklist the access token if provided
    if (accessToken) {
      blacklistToken(accessToken);
    }

    await User.findByIdAndDelete(userId);
  }

  private static generateOtp(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  static async sendOtp(email: string): Promise<void> {
    const user = await User.findOne({ email });
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    if (user.isEmailVerified) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Email is already verified');
    }

    const otp = this.generateOtp();
    const otpExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

    user.emailOtp = otp;
    user.emailOtpExpiry = otpExpiry;
    await user.save();

    await EmailService.sendOtpEmail(email, otp);
  }

  static async verifyOtp(email: string, otp: string): Promise<void> {
    const user = await User.findOne({ email }).select('+emailOtp +emailOtpExpiry');
    if (!user) {
      throw new AppError(StatusCodes.NOT_FOUND, 'User not found');
    }

    if (user.isEmailVerified) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Email is already verified');
    }

    if (!user.emailOtp || !user.emailOtpExpiry) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'No OTP found. Please request a new OTP');
    }

    if (user.emailOtpExpiry < new Date()) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'OTP has expired. Please request a new OTP');
    }

    if (user.emailOtp !== otp) {
      throw new AppError(StatusCodes.BAD_REQUEST, 'Invalid OTP');
    }

    user.isEmailVerified = true;
    user.emailOtp = undefined;
    user.emailOtpExpiry = undefined;
    await user.save();
  }
} 