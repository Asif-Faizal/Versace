"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ListController = void 0;
const Category_1 = require("../models/Category");
const SubCategory_1 = require("../models/SubCategory");
const Product_1 = require("../models/Product");
const statusCodes_1 = require("../utils/statusCodes");
class ListController {
    /**
     * @desc    Get all categories, subcategories, and products with just name and id in a single list
     * @route   GET /api/list
     * @access  Private
     */
    static async getAllLists(req, res, next) {
        try {
            const { name } = req.query;
            const nameFilter = name ? { name: { $regex: name, $options: 'i' } } : {};
            // Get categories with just name and _id
            const categories = await Category_1.Category.find(nameFilter, 'name _id').lean();
            // Get subcategories with just name, _id, and category
            const subcategories = await SubCategory_1.SubCategory.find(nameFilter, 'name _id category').lean();
            // Get products with just name, _id, category, and subcategory
            const products = await Product_1.Product.find(nameFilter, 'name _id category subcategory').lean();
            // Combine all items into a single array
            const allItems = [
                ...categories,
                ...subcategories,
                ...products
            ];
            res.status(statusCodes_1.StatusCodes.OK).json({
                success: true,
                data: {
                    categories: allItems
                }
            });
        }
        catch (error) {
            next(error);
        }
    }
}
exports.ListController = ListController;
