import express from 'express';
import room from '../controllers/room.js';

const router = express.Router();

router.get("/:lastRoomId&:number", room.onGetRoomsByPaging);
router.get("/find/:textMatch", room.onGetRoomsByName);

router.post("/c/", room.onCreateRoom);
router.post("/u/:roomId", room.onUpdateRoom);
router.post("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete("/d/:roomId", room.onDeleteRoom);

// TODO: add route addUserToRoom
// TODO: add route removeUserFromRoom

export default router;