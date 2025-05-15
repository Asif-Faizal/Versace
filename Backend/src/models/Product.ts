import mongoose, { Document, Schema } from 'mongoose';

export interface IVariant {
  _id: mongoose.Types.ObjectId;
  name: string;
  price: number;
  stock: number;
  toObject(): any;
}

export interface IProduct extends Document {
  name: string;
  description: string;
  basePrice: number;
  category: mongoose.Types.ObjectId;
  subcategory: mongoose.Types.ObjectId;
  variants: IVariant[];
  wishlist: mongoose.Types.ObjectId[];
  cart: mongoose.Types.ObjectId[];
  rating: number;
  isNewProduct: boolean;
  isTrending: boolean;
  isInWishlist: boolean;
  isInCart: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const variantSchema = new Schema({
  name: { type: String, required: true },
  price: { type: Number, required: true },
  stock: { type: Number, required: true, default: 0 }
});

const productSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  basePrice: { type: Number, required: true },
  category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  subcategory: { type: Schema.Types.ObjectId, ref: 'SubCategory', required: true },
  variants: [variantSchema],
  wishlist: [{ type: Schema.Types.ObjectId, ref: 'User' }],
  cart: [{ type: Schema.Types.ObjectId, ref: 'User' }],
  rating: { type: Number, default: 0, min: 0, max: 5 },
  isNewProduct: { type: Boolean, default: true },
  isTrending: { type: Boolean, default: false },
  isInWishlist: { type: Boolean, default: false },
  isInCart: { type: Boolean, default: false }
}, {
  timestamps: true
});

// Add text index for search functionality
productSchema.index({ name: 'text', description: 'text' });

export const Product = mongoose.model<IProduct>('Product', productSchema); 