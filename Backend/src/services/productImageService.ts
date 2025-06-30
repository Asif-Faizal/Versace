import { Product, IProduct, IProductImage } from '../models/Product';
import { AppError } from '../middleware/errorHandler';
import { StatusCodes } from '../utils/statusCodes';
import fileUploadService from './fileUploadService';
import config from '../config/config';
import { generateFileName } from '../middleware/fileUpload';

export class ProductImageService {
  /**
   * Upload images for a specific product variant combination
   * @param productId Product ID
   * @param variantCombinationId Variant combination ID
   * @param imageFiles Object containing image files (main, thumbnail, detail1, detail2)
   */
  static async uploadVariantImages(
    productId: string,
    variantCombinationId: string,
    imageFiles: {
      main?: Express.Multer.File,
      thumbnail?: Express.Multer.File,
      detail1?: Express.Multer.File,
      detail2?: Express.Multer.File
    }
  ): Promise<IProductImage> {
    // Start with debugging information
    console.log(`Uploading images for product ${productId}, variant ${variantCombinationId}`);
    console.log('Image files received:', Object.keys(imageFiles).filter(key => !!imageFiles[key as keyof typeof imageFiles]));

    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Find the variant combination
    const variantCombination = product.variantCombinations.find(
      vc => vc._id.toString() === variantCombinationId
    );
    if (!variantCombination) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant combination not found');
    }

    // Current images for the variant (if any)
    const currentImages = variantCombination.images || {};
    const updatedImages: IProductImage = {
      main: currentImages.main || '',
      thumbnail: currentImages.thumbnail || '',
      detail1: currentImages.detail1 || '',
      detail2: currentImages.detail2 || ''
    };
    
    // Upload each provided image
    for (const [imageType, file] of Object.entries(imageFiles)) {
      if (!file) {
        console.log(`No file provided for ${imageType}, skipping`);
        continue;
      }

      try {
        console.log(`Processing ${imageType} image: ${file.originalname}, size: ${file.size} bytes`);

        // Generate a unique name for the image
        const variant = variantCombination.variant || 'default';
        const color = variantCombination.color || 'default';
        const fileName = generateFileName(
          file, 
          `product-${productId}-${variant}-${color}-${imageType}`
        );
        console.log(`Generated filename: ${fileName}`);

        // Delete existing image if there is one
        if (currentImages[imageType as keyof IProductImage]) {
          try {
            const oldFileName = currentImages[imageType as keyof IProductImage].split('/').pop();
            if (oldFileName) {
              console.log(`Deleting old image: ${oldFileName}`);
              await fileUploadService.deleteImage(
                config.supabase.buckets.products,
                oldFileName
              );
            }
          } catch (error) {
            console.error(`Error deleting old ${imageType} image:`, error);
            // Continue with the upload even if deletion fails
          }
        }

        // Upload the new image
        console.log(`Uploading to bucket: ${config.supabase.buckets.products}`);
        const imageUrl = await fileUploadService.uploadImage(
          file.buffer,
          config.supabase.buckets.products,
          fileName
        );

        console.log(`Upload successful, URL: ${imageUrl}`);

        // Update the image URL
        updatedImages[imageType as keyof IProductImage] = imageUrl;
      } catch (error) {
        console.error(`Error processing ${imageType} image:`, error);
        // Continue with other images even if one fails
      }
    }

    console.log('Final image URLs:', updatedImages);

    // Update the product in the database
    await Product.updateOne(
      { _id: productId, 'variantCombinations._id': variantCombinationId },
      { $set: { 'variantCombinations.$.images': updatedImages } }
    );

    console.log('Database updated successfully');
    return updatedImages;
  }

  /**
   * Delete all images for a specific product variant combination
   * @param productId Product ID
   * @param variantCombinationId Variant combination ID
   */
  static async deleteVariantImages(
    productId: string,
    variantCombinationId: string
  ): Promise<void> {
    const product = await Product.findById(productId);
    if (!product) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Product not found');
    }

    // Find the variant combination
    const variantCombination = product.variantCombinations.find(
      vc => vc._id.toString() === variantCombinationId
    );
    if (!variantCombination) {
      throw new AppError(StatusCodes.NOT_FOUND, 'Variant combination not found');
    }

    // Delete all images from Supabase
    const images = variantCombination.images;
    if (!images) return;

    const imageTypes: (keyof IProductImage)[] = ['main', 'thumbnail', 'detail1', 'detail2'];
    
    for (const imageType of imageTypes) {
      if (images[imageType]) {
        try {
          const fileName = images[imageType].split('/').pop();
          if (fileName) {
            await fileUploadService.deleteImage(
              config.supabase.buckets.products,
              fileName
            );
          }
        } catch (error) {
          console.error(`Error deleting ${imageType} image:`, error);
          // Continue with other deletions even if one fails
        }
      }
    }

    // Clear the images in the database
    await Product.updateOne(
      { _id: productId, 'variantCombinations._id': variantCombinationId },
      { $set: { 'variantCombinations.$.images': {} } }
    );
  }
}

export default ProductImageService; 