import { TypeMessage } from "../models/message.js";
import MessageModel from "../models/message.js";
import { NUMBER_MESSAGE_PER_LOAD } from "../config/constant.js";
import {
  failResponse,
  successResponse,
  unAuthorizedResponse,
} from "./index.js";
import UserModel from "../models/user.js";
import config from "../config/index.js";
import RoomModel from "../models/room.js";

export default {
  onGetRoomMessages: async (req, res, next) => {
    const {
      roomId,
      startIndex,
      number,
      orderby,
      orderdirection,
      searchby,
      searchvalue,
    } = req.query;

    const userId = req.userId;
    console.log("ID", userId);
    // If is admin, next
    if (userId !== config.adminId) {
      const joinerInRoom = await UserModel.getJoinersInRoom([roomId]);
      console.log(joinerInRoom);
      // If is not joiner, can not access
      if (!joinerInRoom.some((joiner) => joiner.id === userId)) {
        return unAuthorizedResponse(res);
      }
    }

    try {
      // const { startIndex, number } = req.body;
      const messages = await MessageModel.getMessagesByRoomId(
        roomId,
        startIndex,
        number,
        orderby,
        orderdirection,
        searchby,
        searchvalue
      );

      return successResponse(res, { messages: messages });
    } catch (error) {
      return failResponse(res, { error: error });
    }
  },

  onCreateMessageByRoomId: async (req, res, next) => {
    const { content, roomId } = req.body;
    const senderId = req.userId;
    const files = req.files;

    try {
      let value;
      if (content) {
        value = content;
      } else if (files) {
        value = files;
      } else {
        throw new Error("One of the Content and Files must not empty");
      }

      const newMessage = await MessageModel.createMessage(
        value,
        roomId,
        senderId
      );

      // Set last message for room model
      RoomModel.setLastMessage(roomId, newMessage.id);

      return successResponse(res, {
        success: true,
        message: newMessage,
      });
    } catch (error) {
      // TODO: if fail, delete files from server
      return failResponse(res, {
        error,
        description: "Message cannot send",
      });
    }
  },

  onCreateMessageByUserId: async (req, res, next) => {
    const { content, usersId } = req.body;
    const senderId = req.userId;
    const files = req.files;

    try {
      let value;
      if (content) {
        value = content;
      } else if (files) {
        value = files;
      } else {
        throw new Error("One of the Content and Files must not empty");
      }

      let roomId;
      // Send message for one people, check room exists
      if (usersId.length === 1) {
        // Exists room chat of sender and receiver
        const room = await RoomModel.findRoomByUserId(senderId, usersId[0]);
        if (room) {
          roomId = room.id;
        }
        else {
          // If not exists, create new room
          roomId = await RoomModel.createRoom(
            "Room no name",
            null,
            [senderId, ...usersId],
          );
        }
      } else {
        // Create new room for group user
        roomId = await RoomModel.createRoom(
          "Group no name",
          null,
          [senderId, ...usersId],
        );
      }

      const newMessage = await MessageModel.createMessage(
        value,
        roomId,
        senderId
      );

      // Set last message for room model
      RoomModel.setLastMessage(roomId, newMessage.id);

      return successResponse(res, {
        success: true,
        message: newMessage,
      });
    } catch (error) {
      // TODO: if fail, delete files from server
      return failResponse(res, {
        error,
        description: "Message cannot send",
      });
    }
  },

  onSendImage: async (req, res, next) => {
    const { content, roomId } = req.body;

    try {
      await MessageModel.send(content, "image", roomId);
      return successResponse(res);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onSendFile: async (req, res, next) => {
    const { content, roomId } = req.body;

    try {
      await MessageModel.send(content, "file", roomId);
      return successResponse(res);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onDeleteMessage: async (req, res, next) => {
    const { messageId, roomId } = req.body;

    try {
      if (messageId) {
        await MessageModel.deleteMessageById(messageId, TypeMessage.key);
      } else {
        await MessageModel.deleteMessageInRoom(roomId);
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
      const images = await MessageModel.getImages(startIndex, number, roomId);

      return successResponse(res, images);
    } catch (error) {
      return failResponse(res, error);
    }
  },
  onGetFile: async (req, res, next) => {
    // const { startIndex, number } = req.body;
    const { roomId, startIndex, number } = req.query;

    try {
      const files = await MessageModel.getFiles(startIndex, number, roomId);

      return successResponse(res, files);
    } catch (error) {
      return failResponse(res, error);
    }
  },
};
