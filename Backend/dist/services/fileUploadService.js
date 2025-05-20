"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteImage = exports.uploadImage = void 0;
const supabase_js_1 = require("@supabase/supabase-js");
const config_1 = __importDefault(require("../config/config"));
// Initialize Supabase client with detailed logging
const supabase = (0, supabase_js_1.createClient)(config_1.default.supabase.url, config_1.default.supabase.key, {
    auth: {
        persistSession: false,
        autoRefreshToken: false,
    }
});
// Log Supabase configuration (without revealing full key)
console.log(`Supabase configured with URL: ${config_1.default.supabase.url}`);
console.log(`Supabase key (first 8 chars): ${config_1.default.supabase.key.substring(0, 8)}...`);
console.log(`Configured buckets: `, config_1.default.supabase.buckets);
/**
 * Upload an image to Supabase Storage
 * @param file The file buffer to upload
 * @param bucket The storage bucket name
 * @param fileName The name to store the file as
 * @returns URL of the uploaded image
 */
const uploadImage = async (file, bucket, fileName) => {
    try {
        console.log(`Starting upload to bucket: ${bucket}, fileName: ${fileName}, buffer size: ${file.length} bytes`);
        // Skip bucket verification as it's causing issues
        // Directly attempt the upload
        const { data, error } = await supabase.storage
            .from(bucket)
            .upload(fileName, file, {
            cacheControl: '3600',
            upsert: true,
            contentType: 'image/png',
        });
        if (error) {
            console.error('Error during file upload:', error);
            // Log any available error information that's safe
            console.error('Error details:', {
                message: error.message,
                name: error.name,
                errorType: typeof error
            });
            throw new Error(`Error uploading file: ${error.message}`);
        }
        if (!data || !data.path) {
            console.error('No data returned from upload');
            throw new Error('No data returned from upload');
        }
        console.log('File upload successful, path:', data.path);
        // Get the public URL for the file
        const { data: urlData } = supabase.storage
            .from(bucket)
            .getPublicUrl(data.path);
        if (!urlData || !urlData.publicUrl) {
            console.error('Failed to get public URL');
            throw new Error('Failed to get public URL');
        }
        console.log('Generated public URL:', urlData.publicUrl);
        return urlData.publicUrl;
    }
    catch (error) {
        console.error('Upload failed:', error);
        // Try with a direct URL construction as fallback
        try {
            const directUrl = `${config_1.default.supabase.url}/storage/v1/object/public/${bucket}/${fileName}`;
            console.log('Attempting fallback with direct URL:', directUrl);
            return directUrl;
        }
        catch (fallbackError) {
            console.error('Fallback URL generation also failed:', fallbackError);
            throw new Error(`Upload failed: ${error.message}`);
        }
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
        console.log(`Deleting file from bucket: ${bucket}, fileName: ${fileName}`);
        const { error } = await supabase.storage
            .from(bucket)
            .remove([fileName]);
        if (error) {
            console.error('Error during file deletion:', error);
            throw new Error(`Error deleting file: ${error.message}`);
        }
        console.log('File deleted successfully');
    }
    catch (error) {
        console.error('Delete failed:', error);
        throw new Error(`Delete failed: ${error.message}`);
    }
};
exports.deleteImage = deleteImage;
exports.default = {
    uploadImage: exports.uploadImage,
    deleteImage: exports.deleteImage
};
