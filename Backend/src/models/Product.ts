import mongoose, { Document, Schema } from 'mongoose';

export interface IVariantCombination {
  _id: mongoose.Types.ObjectId;
  variant: string | null;
  color: string | null;
  size: string | null;
  variantIndex?: number;
  colorIndex?: number;
  sizeIndex?: number;
  additionalPrice: number;
  stock: number;
  toObject(): any;
}

export interface IProduct extends Document {
  name: string;
  description: string;
  basePrice: number;
  category: mongoose.Types.ObjectId;
  subcategory: mongoose.Types.ObjectId;
  variants: string[];
  colors: string[];
  sizes: string[];
  variantCombinations: IVariantCombination[];
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

const variantCombinationSchema = new Schema({
  variant: { type: String, default: null },
  color: { type: String, default: null },
  size: { type: String, default: null },
  variantIndex: { type: Number },
  colorIndex: { type: Number },
  sizeIndex: { type: Number },
  additionalPrice: { type: Number, required: true, default: 0 },
  stock: { type: Number, required: true, default: 0 }
});

const productSchema = new Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  basePrice: { type: Number, required: true },
  category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  subcategory: { type: Schema.Types.ObjectId, ref: 'SubCategory', required: true },
  variants: [{ type: String }],
  colors: [{ type: String }],
  sizes: [{ type: String }],
  variantCombinations: [variantCombinationSchema],
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