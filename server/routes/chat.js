import express from 'express';
import chat from '../controllers/chat.js';

const router = express.Router();

router.get("/:startIndex&:number", chat.onGetRoomMessages);
router.get("/find/:textMatch&:startIndex&:number", chat.onGetMessagesByContent);
router.get("/img/:startIndex&:number", chat.onGetImages);
router.get("/file/:startIndex&:number", chat.onGetFile);

router.post("/send", chat.onSendMessage);

router.delete("/:messageId", chat.onDeleteMessage);

export default router;