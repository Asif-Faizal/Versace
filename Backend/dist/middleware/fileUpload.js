"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateFileName = exports.handleUploadErrors = exports.upload = void 0;
const multer_1 = __importDefault(require("multer"));
const path_1 = __importDefault(require("path"));
// Set up in-memory storage
const storage = multer_1.default.memoryStorage();
// File filter to accept only images
const fileFilter = (req, file, cb) => {
    // Accept only image files
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    }
    else {
        cb(new Error('Only image files are allowed'));
    }
};
// Create multer upload instance
exports.upload = (0, multer_1.default)({
    storage,
    fileFilter,
    limits: {
        fileSize: 5 * 1024 * 1024, // 5MB
    },
});
// Middleware to handle file upload errors
const handleUploadErrors = (err, req, res, next) => {
    if (err instanceof multer_1.default.MulterError) {
        if (err.code === 'LIMIT_FILE_SIZE') {
            return res.status(400).json({
                success: false,
                message: 'File too large. Maximum size is 5MB',
            });
        }
        return res.status(400).json({
            success: false,
            message: `Upload error: ${err.message}`,
        });
    }
    if (err) {
        return res.status(400).json({
            success: false,
            message: err.message,
        });
    }
    next();
};
exports.handleUploadErrors = handleUploadErrors;
// Generate a unique filename for uploaded files
const generateFileName = (file, prefix) => {
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    const fileExt = path_1.default.extname(file.originalname).toLowerCase();
    return `${prefix}-${uniqueSuffix}${fileExt}`;
};
exports.generateFileName = generateFileName;
exports.default = {
    upload: exports.upload,
    handleUploadErrors: exports.handleUploadErrors,
    generateFileName: exports.generateFileName,
};
