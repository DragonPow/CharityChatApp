import express from 'express';
import room from '../controllers/roomchat.js';

const router = express.Router();

router.get("/", room.onGetRoomMessage);
router.post("/:text", room.onFindContent);

export default router;