"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteImage = exports.uploadImage = void 0;
const supabase_js_1 = require("@supabase/supabase-js");
const config_1 = __importDefault(require("../config/config"));
const supabase = (0, supabase_js_1.createClient)(config_1.default.supabase.url, config_1.default.supabase.key);
/**
 * Upload an image to Supabase Storage
 * @param file The file buffer to upload
 * @param bucket The storage bucket name
 * @param fileName The name to store the file as
 * @returns URL of the uploaded image
 */
const uploadImage = async (file, bucket, fileName) => {
    try {
        const { data, error } = await supabase.storage
            .from(bucket)
            .upload(fileName, file, {
            cacheControl: '3600',
            upsert: true,
        });
        if (error) {
            throw new Error(`Error uploading file: ${error.message}`);
        }
        // Get the public URL for the file
        const { data: { publicUrl } } = supabase.storage
            .from(bucket)
            .getPublicUrl(data.path);
        return publicUrl;
    }
    catch (error) {
        throw new Error(`Upload failed: ${error.message}`);
    }
};
exports.uploadImage = uploadImage;
/**
 * Delete an image from Supabase Storage
 * @param bucket The storage bucket name
 * @param fileName The name of the file to delete
 */
const deleteImage = async (bucket, fileName) => {
    try {
        const { error } = await supabase.storage
            .from(bucket)
            .remove([fileName]);
        if (error) {
            throw new Error(`Error deleting file: ${error.message}`);
        }
    }
    catch (error) {
        throw new Error(`Delete failed: ${error.message}`);
    }
};
exports.deleteImage = deleteImage;
exports.default = {
    uploadImage: exports.uploadImage,
    deleteImage: exports.deleteImage
};
