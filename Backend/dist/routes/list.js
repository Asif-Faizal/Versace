"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const listController_1 = require("../controllers/listController");
const cache_1 = require("../middleware/cache");
const auth_1 = require("../middleware/auth");
const router = (0, express_1.Router)();
// Protected route with authentication and caching
router.get('/', auth_1.authenticate, (0, cache_1.cacheMiddleware)('categories'), listController_1.ListController.getAllLists);
exports.default = router;
