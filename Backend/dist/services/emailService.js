"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const nodemailer_1 = __importDefault(require("nodemailer"));
const config_1 = __importDefault(require("../config/config"));
const statusCodes_1 = require("../utils/statusCodes");
const errorHandler_1 = require("../middleware/errorHandler");
class EmailService {
    static async sendOtpEmail(email, otp) {
        try {
            const mailOptions = {
                from: config_1.default.email.from,
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
        }
        catch (error) {
            throw new errorHandler_1.AppError(statusCodes_1.StatusCodes.INTERNAL_SERVER_ERROR, 'Failed to send OTP email');
        }
    }
}
EmailService.transporter = nodemailer_1.default.createTransport({
    host: config_1.default.email.host,
    port: config_1.default.email.port,
    secure: config_1.default.email.secure,
    auth: {
        user: config_1.default.email.user,
        pass: config_1.default.email.password
    }
});
exports.default = EmailService;
