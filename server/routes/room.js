import express from 'express';
import room from '../controllers/room.js';

const router = express.Router();

router.get("/select", room.onGetRoomsByPaging);
router.get("/roomName", room.onGetRoomsByName);

router.post("/c/", room.onCreateRoom);
router.put("/u/:roomId", room.onUpdateRoom);
// router.put("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete("/d/:roomId", room.onDeleteRoom);

// TODO: add route addUserToRoom
// TODO: add route removeUserFromRoom

export default router;