import { TypeMessage } from "../models/message.js";
import Message from "../models/room.js";
import { NUMBER_MESSAGE_PER_LOAD } from "../config/constant.js";

export default {
    onGetRoomMessages: async (req, res, next) => {
        try {
            // const { startIndex, number } = req.body;
            const { roomId, startIndex, number } = req.query;
            const messages = await Message.getRoomMessages(
                roomId,
                startIndex ?? 0,
                number ?? NUMBER_MESSAGE_PER_LOAD,
            );

            return res.status(200).json({
                success: true,
                messages,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onGetMessagesByContent: async (req, res, next) => {
        try {
            // const { roomId } = req.body;
            const { textMatch, roomId, startIndex, number } = req.query;
            const messages = await Message.getMessagesByContent(
                textMatch,
                roomId,
                startIndex ?? 0,
                number ?? NUMBER_MESSAGE_PER_LOAD
            );

            return res.status(200).json({
                success: true,
                messages,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onSendMessage: async (req, res, next) => {
        try {
            const { content, senderId } = req.body;
            const { roomId } = req.query;
            await Message.send(content, "text", roomId, senderId);

            return res.status(200).json({
                success: true,
                description: `Message send success:\n${
                    (content, typeContent, roomId)
                }`,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: "Message cannot send",
            });
        }
    },
    onSendImage: async (req, res, next) => {
        try {
            const { content, roomId } = req.body;
            await Message.send(content, "image", roomId);
            return res.status(200).json({
                success: true,
            });
        } catch (error) {
            return res
                .status(500)
                .json({
                    success: false,
                    error: error,
                });
        }
    },
    onSendFile: async (req, res, next) => {
        try {
            const { content, roomId } = req.body;
            await Message.send(content, "file", roomId);
            return res.status(200).json({
                success: true,
            });
        } catch (error) {
            return res
                .status(500)
                .json({
                    success: false,
                    error: error,
                });
        }
    },
    onDeleteMessage: async (req, res, next) => {
        try {
            const { messageId } = req.body;
            await Message.delete(messageId, TypeMessage.key);

            return res.status(200).json({
                success: true,
                description: "Message delete success",
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: "Message cannot delete",
            });
        }
    },
    onGetImages: async (req, res, next) => {
        try {
            // const { startIndex, number } = req.body;
            const { roomId, startIndex, number } = req.query;
            const images = await Message.getImages(startIndex, number, roomId);

            return res.status(200).json({
                success: true,
                images,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
            });
        }
    },
    onGetFile: async (req, res, next) => {
        try {
            // const { startIndex, number } = req.body;
            const { roomId, startIndex, number } = req.query;
            const files = await Message.getFiles(startIndex, number, roomId);

            return res.status(200).json({
                success: true,
                files,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
            });
        }
    },
};
