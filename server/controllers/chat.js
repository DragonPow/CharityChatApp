import { TypeMessage } from "../models/message.js";
import Message from "../models/room.js";
import { NUMBER_MESSAGE_PER_LOAD } from "../config/constant.js";
import { failResponse, successResponse } from "./index.js";

export default {
  onGetRoomMessages: async (req, res, next) => {
    const { roomId, startIndex, number } = req.query;

    try {
      // const { startIndex, number } = req.body;
      const messages = await Message.getRoomMessages(
        roomId,
        startIndex ?? 0,
        number ?? NUMBER_MESSAGE_PER_LOAD
      );

      return successResponse(res, messages);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onGetMessagesByContent: async (req, res, next) => {
    // const { roomId } = req.body;
    const { textMatch, roomId, startIndex, number } = req.query;

    try {
      const messages = await Message.getMessagesByContent(
        textMatch,
        roomId,
        startIndex ?? 0,
        number ?? NUMBER_MESSAGE_PER_LOAD
      );

      return successResponse(res, messages);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onSendMessage: async (req, res, next) => {
    const { content, senderId, typeContent } = req.body;
    const { roomId } = req.query;

    try {
      const newMessage = await Message.sendMessage(
        content,
        typeContent,
        roomId,
        senderId
      );
      const id = newMessage.id;

      return successResponse(res, {
        description: `Message send success:\n${(content, typeContent, roomId)}`,
        messageId: id,
      });
    } catch (error) {
      return failResponse(res, {
        error,
        description: "Message cannot send",
      });
    }
  },
  onSendImage: async (req, res, next) => {
    const { content, roomId } = req.body;

    try {
      await Message.send(content, "image", roomId);
      return successResponse(res);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onSendFile: async (req, res, next) => {
    const { content, roomId } = req.body;

    try {
      await Message.send(content, "file", roomId);
      return successResponse(res);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onDeleteMessage: async (req, res, next) => {
    const { messageId, roomId } = req.body;

    try {
      if (messageId) {
        await Message.deleteMessageById(messageId, TypeMessage.key);
      } else {
        await Message.deleteMessageInRoom(roomId);
      }

      return successResponse(res, { description: "Message delete success" });
    } catch (error) {
      return failResponse(res, { error, description: "Message cannot delete" });
    }
  },
  onGetImages: async (req, res, next) => {
    // const { startIndex, number } = req.body;
    const { roomId, startIndex, number } = req.query;

    try {
      const images = await Message.getImages(startIndex, number, roomId);

      return successResponse(res, images);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onGetFile: async (req, res, next) => {
    // const { startIndex, number } = req.body;
    const { roomId, startIndex, number } = req.query;

    try {
      const files = await Message.getFiles(startIndex, number, roomId);

      return successResponse(res, files);
    } catch (error) {
      return failResponse(res, error);
    }
  },
};
