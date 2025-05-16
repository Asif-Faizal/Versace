import { Router } from 'express';
import { ListController } from '../controllers/listController';
import { cacheMiddleware } from '../middleware/cache';
import { authenticate } from '../middleware/auth';

const router = Router();

// Protected route with authentication and caching
router.get('/', authenticate, cacheMiddleware('categories'), ListController.getAllLists);

export default router; 