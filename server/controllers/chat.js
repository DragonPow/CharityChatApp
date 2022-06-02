import { TypeMessage } from "../models/message.js";
import MessageModel from "../models/message.js";
import { NUMBER_MESSAGE_PER_LOAD } from "../config/constant.js";
import { deleteFiles } from "../utils/file/file_service.js";
import {
  badRequestResponse,
  failResponse,
  successResponse,
  unAuthorizedResponse,
} from "./index.js";
import UserModel from "../models/user.js";
import config from "../config/index.js";
import RoomModel from "../models/room.js";
import { CheckIsImageFile, TranferFileMulterToString } from "../config/helper.js";

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
      return failResponse(res, { error: error.message });
    }
  },

  onGetAllMessages: async (req, res, next) => {
    const {
      startIndex,
      number,
      orderby,
      orderdirection,
      searchby,
      searchvalue,
    } = req.query;

    const userId = req.userId;
    // If is admin, next
    if (userId !== config.adminId) {
      return unAuthorizedResponse(res, "Only admin can access this route");
    }

    try {
      // const { startIndex, number } = req.body;
      const messages = await MessageModel.getAllMessages(
        startIndex,
        number,
        orderby,
        orderdirection,
        searchby,
        searchvalue
      );

      return successResponse(res, { messages: messages });
    } catch (error) {
      return failResponse(res, { error: error.message });
    }
  },

  onCreateMessageByRoomId: async (req, res, next) => {
    const { content, roomId } = req.body;
    const senderId = req.userId;
    const files = req.files;

    try {
      let value;
      // Check content or file is nto empty
      if (content) {
        value = content;
      } else if (files && files.length) {
        value = files;
      } else {
        return badRequestResponse(res, {
          errorCode: "CONTENT_OR_FILE_NOT_EMPTY",
          error: "One of the Content and Files must not empty",
        });
      }

      // Check room exists
      const roomsCheck = await RoomModel.getRoomsById([roomId]);
      if (!roomsCheck || roomsCheck.length !== 1) {
        return badRequestResponse(res, {code: 'ROOM_NOT_EXISTS', error: 'Room is not exists'});
      }
      else {
        if (!roomsCheck[0].joiners.some(user => user.id === senderId)) {
          return unAuthorizedResponse(res);
        }
      }

      // Create message
      const newMessage = await MessageModel.createMessage(
        value,
        roomId,
        senderId
      );

      // Set last message for room model
      RoomModel.checkAndSetLastMessage(roomId, newMessage);

      return successResponse(res, {
        success: true,
        message: newMessage,
      });
    } catch (error) {
      console.log('ERROR', error);
      // Delete all file in request
      if (files) {
        deleteFiles(files.map((file) => TranferFileMulterToString(file))).catch(
          (error) => {
            console.log("DELETE_FILE_FAIL:", error);
          }
        );
      }

      return failResponse(res, {
        error: error?.message ?? error,
        description: "Message cannot send",
      });
    }
  },

  onCreateMessageByUserId: async (req, res, next) => {
    const { content, usersId } = req.body;
    const senderId = req.userId;
    const files = req.files;

    const isExists = await UserModel.checkExists([...usersId, senderId]);
    if (!isExists)
      return badRequestResponse(res, {
        errorCode: "USER_NOT_FOUND",
        error: "The user is not exists",
      });

    try {
      let value;
      // Check content or file is nto empty
      if (content) {
        value = content;
      } else if (files && files.length) {
        value = files;
      } else {
        return badRequestResponse(res, {
          errorCode: "CONTENT_NOT_EMPTY",
          error: "One of the Content and Files must not empty",
        });
      }

      // Find or create new room by usersId
      const room = await RoomModel.findOrCreateRoom([...usersId, senderId]);

      // Create message
      const newMessage = await MessageModel.createMessage(
        value,
        room.id,
        senderId
      );

      // Set last message for room model
      RoomModel.checkAndSetLastMessage(room.id, newMessage);

      return successResponse(res, {
        success: true,
        message: newMessage,
      });
    } catch (error) {
      // Delete all file in request
      if (files) {
        deleteFiles(files).catch((error) => {
          console.log("DELETE_FILE_FAIL:", error);
        });
      }

      return failResponse(res, {
        error: error?.message ?? error,
        description: "Message cannot send",
      });
    }
  },

  onUpdateMessage: async (req, res, next) => {
    const {} = req.body;
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
  // onGetImages: async (req, res, next) => {
  //   // const { startIndex, number } = req.body;
  //   const { roomId, startIndex, number } = req.query;

  //   try {
  //     const images = await MessageModel.getImages(startIndex, number, roomId);

  //     return successResponse(res, images);
  //   } catch (error) {
  //     return failResponse(res, error);
  //   }
  // },
  // onGetFile: async (req, res, next) => {
  //   // const { startIndex, number } = req.body;
  //   const { roomId, startIndex, number } = req.query;

  //   try {
  //     const files = await MessageModel.getFiles(startIndex, number, roomId);

  //     return successResponse(res, files);
  //   } catch (error) {
  //     return failResponse(res, error);
  //   }
  // },
};
