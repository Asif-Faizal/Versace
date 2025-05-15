"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.Product = void 0;
const mongoose_1 = __importStar(require("mongoose"));
const variantCombinationSchema = new mongoose_1.Schema({
    variant: { type: String, default: null },
    color: { type: String, default: null },
    size: { type: String, default: null },
    variantIndex: { type: Number },
    colorIndex: { type: Number },
    sizeIndex: { type: Number },
    additionalPrice: { type: Number, required: true, default: 0 },
    stock: { type: Number, required: true, default: 0 }
});
const productSchema = new mongoose_1.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    basePrice: { type: Number, required: true },
    category: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Category', required: true },
    subcategory: { type: mongoose_1.Schema.Types.ObjectId, ref: 'SubCategory', required: true },
    variants: [{ type: String }],
    colors: [{ type: String }],
    sizes: [{ type: String }],
    variantCombinations: [variantCombinationSchema],
    wishlist: [{ type: mongoose_1.Schema.Types.ObjectId, ref: 'User' }],
    cart: [{ type: mongoose_1.Schema.Types.ObjectId, ref: 'User' }],
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
exports.Product = mongoose_1.default.model('Product', productSchema);
