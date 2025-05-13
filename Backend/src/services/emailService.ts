import nodemailer from 'nodemailer';
import config from '../config/config';
import { StatusCodes } from '../utils/statusCodes';
import { AppError } from '../middleware/errorHandler';

class EmailService {
  private static transporter = nodemailer.createTransport({
    host: config.email.host,
    port: config.email.port,
    secure: config.email.secure,
    auth: {
      user: config.email.user,
      pass: config.email.password
    }
  });

  static async sendOtpEmail(email: string, otp: string): Promise<void> {
    try {
      const mailOptions = {
        from: config.email.from,
        to: email,
        subject: 'Email Verification OTP',
        html: `
          <h1>Email Verification</h1>
          <p>Your OTP for email verification is: <strong>${otp}</strong></p>
          <p>This OTP will expire in 10 minutes.</p>
          <p>If you didn't request this OTP, please ignore this email.</p>
        `
      };

      await this.transporter.sendMail(mailOptions);
    } catch (error) {
      throw new AppError(
        StatusCodes.INTERNAL_SERVER_ERROR,
        'Failed to send OTP email'
      );
    }
  }
}

export default EmailService; 