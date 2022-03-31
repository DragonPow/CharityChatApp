import express from 'express';
import user from '../controllers/user.js';

const router = express.Router();

router.get("/:startIndex&:number", user.onGetActiveUsersByPage);
router.get("/find/:textMatch", user.onGetUsersByName);
router.get("/:userId", user.onGetUserById);

export default router;