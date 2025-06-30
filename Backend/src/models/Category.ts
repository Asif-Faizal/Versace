import mongoose, { Document, Schema } from 'mongoose';

export interface ICategory extends Document {
  name: string;
  description: string;
  image: string; // URL to the image in Supabase
  createdAt: Date;
  updatedAt: Date;
}

const categorySchema = new Schema<ICategory>({
  name: {
    type: String,
    required: [true, 'Category name is required'],
    unique: true,
    trim: true
  },
  description: {
    type: String,
    required: [true, 'Category description is required'],
    trim: true
  },
  image: {
    type: String,
    default: ''
  }
}, {
  timestamps: true
});

export const Category = mongoose.model<ICategory>('Category', categorySchema); 