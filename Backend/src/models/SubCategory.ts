import mongoose, { Document, Schema, Types } from 'mongoose';
import { ICategory } from './Category';

export interface ISubCategory extends Document {
  name: string;
  description: string;
  image: string; // URL to the image in Supabase
  category: Types.ObjectId | ICategory;
  createdAt: Date;
  updatedAt: Date;
}

const subCategorySchema = new Schema<ISubCategory>({
  name: {
    type: String,
    required: [true, 'SubCategory name is required'],
    trim: true
  },
  description: {
    type: String,
    required: [true, 'SubCategory description is required'],
    trim: true
  },
  image: {
    type: String,
    default: ''
  },
  category: {
    type: Schema.Types.ObjectId,
    ref: 'Category',
    required: [true, 'Category reference is required']
  }
}, {
  timestamps: true
});

// Compound index to ensure unique subcategory names within a category
subCategorySchema.index({ category: 1, name: 1 }, { unique: true });

export const SubCategory = mongoose.model<ISubCategory>('SubCategory', subCategorySchema); 