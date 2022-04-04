import express from 'express';
import room from '../controllers/room.js';

const router = express.Router();

router.get("/:lastRoomId&:number", room.onGetRoomsByPaging);
router.get("/find/:textMatch", room.onGetRoomsByName);

router.post("/u/:roomId", room.onUpdateRoom);

router.delete("/:roomId", room.onDeleteRoom);

export default router;