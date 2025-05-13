import mongoose, { Document, Schema, Types } from 'mongoose';
import bcrypt from 'bcrypt';
import { AppError } from '../middleware/errorHandler';
import { StatusCodes } from '../utils/statusCodes';

export interface IUser extends Document {
  _id: Types.ObjectId;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role: 'user' | 'admin';
  isActive: boolean;
  refreshToken?: string;
  deviceId?: string;
  deviceModel?: string;
  deviceOs?: string;
  lastUsedDeviceId?: string;
  tokenExpiry?: Date;
  createdAt: Date;
  updatedAt: Date;
  comparePassword(candidatePassword: string): Promise<boolean>;
}

const userSchema = new Schema<IUser>({
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    trim: true,
    lowercase: true,
    match: [/^\S+@\S+\.\S+$/, 'Please enter a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [8, 'Password must be at least 8 characters long']
  },
  firstName: {
    type: String,
    required: [true, 'First name is required'],
    trim: true,
    minlength: [2, 'First name must be at least 2 characters long']
  },
  lastName: {
    type: String,
    required: [true, 'Last name is required'],
    trim: true,
    minlength: [2, 'Last name must be at least 2 characters long']
  },
  role: {
    type: String,
    enum: {
      values: ['user', 'admin'],
      message: 'Role must be either user or admin'
    },
    default: 'user'
  },
  isActive: {
    type: Boolean,
    default: true
  },
  refreshToken: {
    type: String,
    select: false
  },
  deviceId: {
    type: String,
    trim: true
  },
  deviceModel: {
    type: String,
    trim: true
  },
  deviceOs: {
    type: String,
    trim: true
  },
  lastUsedDeviceId: {
    type: String,
    trim: true
  },
  tokenExpiry: {
    type: Date
  }
}, {
  timestamps: true,
  toJSON: {
    transform: (_, ret) => {
      delete ret.password;
      delete ret.refreshToken;
      return ret;
    }
  }
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error: any) {
    next(new AppError(
      StatusCodes.INTERNAL_SERVER_ERROR,
      'Error hashing password',
      false
    ));
  }
});

// Compare password method
userSchema.methods.comparePassword = async function(candidatePassword: string): Promise<boolean> {
  try {
    return await bcrypt.compare(candidatePassword, this.password);
  } catch (error) {
    throw new AppError(
      StatusCodes.INTERNAL_SERVER_ERROR,
      'Error comparing passwords',
      false
    );
  }
};

export const User = mongoose.model<IUser>('User', userSchema); 