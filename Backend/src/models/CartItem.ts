import mongoose, { Document, Schema } from 'mongoose';

export interface ICartItem extends Document {
  user: mongoose.Types.ObjectId;
  product: mongoose.Types.ObjectId;
  variantCombinationId: mongoose.Types.ObjectId;
  quantity: number;
  price: number;
  createdAt: Date;
  updatedAt: Date;
}

const cartItemSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  product: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
  variantCombinationId: { type: Schema.Types.ObjectId, required: true },
  quantity: { type: Number, required: true, min: 1, default: 1 },
  price: { type: Number, required: true }
}, {
  timestamps: true
});

// Only use the new compound index
cartItemSchema.index({ user: 1, product: 1, variantCombinationId: 1 }, { unique: true });

export const CartItem = mongoose.model<ICartItem>('CartItem', cartItemSchema); 