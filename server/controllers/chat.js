import { TypeMessage } from "../models/message.js";
import MessageModel from "../models/message.js";
import { ERROR_CODE, NUMBER_MESSAGE_PER_LOAD } from "../config/constant.js";
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
import { IsImageFile, TranferFileMulterToString } from "../config/helper.js";
import UserRoomModel from "../models/user_room.js";
import { MyNotifySocket } from "../config/websocket.js";

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

    try {
      // If is admin, next
      if (userId !== config.adminId) {
        // Check joiner is in room
        const isJoinerRoom = await UserRoomModel.CheckIsJoinerOfRoom(
          userId,
          roomId
        );
        if (!isJoinerRoom) {
          console.log("Get room message fail, userId is:", userId);
          return unAuthorizedResponse(res, "Must be joiner of the room");
        }
        // const joinerInRoom = await UserModel.getJoinersInRoom([roomId]);
        // console.log('JOINERS IN ROOM:', joinerInRoom);
        // // If is not joiner, can not access
        // if (!joinerInRoom.some((joiner) => joiner.id === userId)) {
        //   return unAuthorizedResponse(res);
        // }
      }

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
    try {
      // If is admin, next
      if (userId !== config.adminId) {
        return unAuthorizedResponse(res, "Only admin can access this route");
      }

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
    const privateCode = req.headers.privateCode;
    const files = req.files;

    try {
      // Check content or file is not empty
      if (!content && (!files || files.length == 0)) {
        return badRequestResponse(res, {
          errorCode: "CONTENT_NOT_EMPTY",
          error: "One of the Content and Files must not empty",
        });
      }

      // Check room exists
      const roomsCheck = await RoomModel.getRoomsById([roomId]);
      if (!roomsCheck || roomsCheck.length !== 1) {
        return badRequestResponse(res, {
          code: "ROOM_NOT_EXISTS",
          error: "Room is not exists",
        });
      } else {
        if (!roomsCheck[0].joiners.some((user) => user.id === senderId)) {
          return unAuthorizedResponse(res);
        }
      }

      const typeContent = content
        ? "text"
        : IsImageFile(files[0].filename)
        ? "image"
        : "file";
      const value = typeContent == "text" ? content : files;

      // Create message
      const newMessage = await MessageModel.createMessage(
        value,
        roomId,
        senderId,
        typeContent
      );

      // Set last message for room model
      RoomModel.checkAndSetLastMessage(roomId, newMessage).then(() => {
        MyNotifySocket.RoomUpdate([roomId]);
      });

      MessageModel.getMessageByIds([newMessage.id]).then((messages) =>
        MyNotifySocket.MessageSent(roomId, messages)
      );

      return successResponse(res, {
        success: true,
        message: newMessage,
      });
    } catch (error) {
      console.log("ERROR", error);
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
    const privateCode = req.headers.privateCode;
    const files = req.files;

    try {
      const isExists = await UserModel.checkExists([...usersId, senderId]);
      if (!isExists)
        return badRequestResponse(res, {
          errorCode: "USER_NOT_FOUND",
          error: "The user is not exists",
        });

      // Check content or file is not empty
      if (!content && (!files || files.length == 0)) {
        return badRequestResponse(res, {
          errorCode: "CONTENT_NOT_EMPTY",
          error: "One of the Content and Files must not empty",
        });
      }

      const typeContent = content
        ? "text"
        : IsImageFile(files[0].filename)
        ? "image"
        : "file";
      const value = typeContent == "text" ? content : files;

      // Find or create new room by usersId
      const room = await RoomModel.findOrCreateRoom([...usersId, senderId]);

      // Create message
      const newMessage = await MessageModel.createMessage(
        value,
        room.id,
        senderId,
        typeContent
      );

      // Set last message for room model
      RoomModel.checkAndSetLastMessage(room.id, newMessage).then(() => {
        MyNotifySocket.RoomUpdate([room.id]);
      });

      MessageModel.getMessageByIds([newMessage.id]).then((messages) =>
        MyNotifySocket.MessageSent(room.id, messages)
      );

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
    const { messageIds } = req.body;
    const userId = req.userId;

    try {
      // If is admin, next
      if (userId !== config.adminId) {
        const isSender = await MessageModel.checkIsSender(messageIds);
        if (!isSender) {
          return badRequestResponse(res, {
            error: ERROR_CODE.ACCESS_DENIED,
            description: "Must be sender to delete message",
          });
        }
      }

      const messages = await MessageModel.getMessageByIds(messageIds);
      const setRoomIds = new Set(messages.map((i) => i.roomId));
      const previousFile = messages
        .filter((i) => ["image", "file", "video"].includes(i.typeContent))
        .map((i) => i.content);

      console.log("File previous delete", previousFile);

      // Delete message
      const number = await MessageModel.deleteMessageById(messageIds);

      // Set last message in room
      setRoomIds.forEach((roomId) => RoomModel.resetLastMessage(roomId));

      // Delete file and image
      deleteFiles(previousFile, true).catch((error) =>
        console.log("Cannot delete files " + previousFile, error)
      );

      return successResponse(res, {
        success: true,
        description: "Message delete success",
      });
    } catch (error) {
      console.log(error);
      return failResponse(res, {
        error: error.message ?? error,
        description: "Message cannot delete",
      });
    }
  },
};
