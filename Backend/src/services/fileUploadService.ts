import { createClient } from '@supabase/supabase-js';
import config from '../config/config';

const supabase = createClient(
  config.supabase.url,
  config.supabase.key
);

/**
 * Upload an image to Supabase Storage
 * @param file The file buffer to upload
 * @param bucket The storage bucket name
 * @param fileName The name to store the file as
 * @returns URL of the uploaded image
 */
export const uploadImage = async (
  file: Buffer,
  bucket: string,
  fileName: string
): Promise<string> => {
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
  } catch (error: any) {
    throw new Error(`Upload failed: ${error.message}`);
  }
};

/**
 * Delete an image from Supabase Storage
 * @param bucket The storage bucket name
 * @param fileName The name of the file to delete
 */
export const deleteImage = async (
  bucket: string,
  fileName: string
): Promise<void> => {
  try {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([fileName]);

    if (error) {
      throw new Error(`Error deleting file: ${error.message}`);
    }
  } catch (error: any) {
    throw new Error(`Delete failed: ${error.message}`);
  }
};

export default {
  uploadImage,
  deleteImage
}; 