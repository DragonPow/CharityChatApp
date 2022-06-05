import RoomModel from "../models/room.js";
import UserModel from "../models/user.js";
import MessageModel from "../models/message.js";
import Model from "../models/model.js";
import {
  badRequestResponse,
  failResponse,
  notFoundResponse,
  successResponse,
} from "./index.js";
import config from "../config/index.js";
import UserRoomModel from "../models/user_room.js";
import { deleteFiles } from "../utils/file/file_service.js";
import { IsImageFile, TranferFileMulterToString } from "../config/helper.js";
import { ERROR_CODE } from "../config/constant.js";

export default {
  onGetRoomsByPaging: async (req, res, next) => {
    try {
    const {
      userId,
      orderby,
      orderdirection,
      startIndex,
      number,
      searchby,
      searchvalue,
    } = req.query;
      // get room
      const rooms = await RoomModel.getRoomsByPaging(
        startIndex,
        number,
        userId,
        orderby,
        orderdirection,
        searchby,
        searchvalue
      );

      // get user of room
      const joiners = await UserModel.getJoinersInRoom(rooms.map((i) => i.id));
      rooms.forEach((i) => {
        var list = joiners
          .filter((item) =>
            Array.from(item.container).some((room) => room.id == i.id)
          )
          .map(({ container, ...item }) => item);
        i.joiners = list;
      });

      return successResponse(res, { rooms: rooms });
    } catch (error) {
      return failResponse(res, { error: error.message });
    }
  },

  onFindRoomByUserId: async (req, res, next) => {
    try {
    const { otherUserId } = req.query;
    const userId = req.userId;
      const isUsersExists = await UserModel.checkExists([userId, otherUserId]);

      if (!isUsersExists) {
        return badRequestResponse(res, { error: "The user not exists" });
      }

      const room = await RoomModel.findRoomOf2UserId(userId, otherUserId);

      if (!room) {
        return notFoundResponse(res, { message: "The room not found" });
      }
      return successResponse(res, { room: room });
    } catch (error) {
      console.log(error);
      return failResponse(res, {
        error: error.message,
        description: "Cannot find room",
      });
    }
  },

  onCreateRoom: async (req, res, next) => {
    try {
    const { name, joinersId } = req.body;
    const userId = req.userId;
    const avatarUri = req.file?.path ?? null;
      const joiners =
        userId === config.adminId ? joinersId : [...joinersId, userId]; // If creator is admin, don't add
      const newRoom = await RoomModel.createRoom(name, avatarUri, joiners);

      if (!newRoom) {
        return successResponse(res, { success: false });
      }

      return successResponse(res, { success: true, room: newRoom });
    } catch (error) {
      console.log(error);
      return failResponse(res, {
        error: error.message,
        description: "Cannot create room",
      });
    }
  },

  onDeleteRoom: async (req, res, next) => {
    try {
    const { roomId } = req.body;
    const userId = req.userId;

      const success = await Model.callTransaction(async () => {
        //Delete all message in room
        await MessageModel.deleteMessageInRoom(roomId);
        //Delete room
        await UserRoomModel.deleteByRoomId(roomId);
      });

      return successResponse(res, {
        description: `Room ${roomId} delete success`,
      });
    } catch (error) {
      //TODO: trace back transaction
      return failResponse(res, {
        error,
        description: `Room ${roomId} cannot delete`,
      });
    }
  },
  onChangeInfo: async (req, res, next) => {
    try {
    const { roomId } = req.params;
    const { roomName } = req.body;
    const image = req.file;

    // Check file is image
    if (image && !IsImageFile(image.filename)) {
      return badRequestResponse(res, {
        code: ERROR_CODE,
        error: "Must be image file",
      });
    }

      // Get string url
      const imageUrl = image ? TranferFileMulterToString(image) : undefined;

      // Update
      const room = await RoomModel.updateRoom(roomId, roomName, imageUrl);

      return successResponse(res, {
        success: true,
        description: `Room ${roomId} update complete`,
        room: room,
      });
    } catch (error) {
      console.log(error);

      // Delete image
      if (image) {
        deleteFiles(TranferFileMulterToString(image)).catch((error) =>
          console.log("DELETE_FILE_FAIL", error)
        );
      }

      return failResponse(res, {
        error: error.message ?? error,
        description: `Room cannot update: ${roomId}`,
      });
    }
  },

  onJoinersChange: async (req, res, next) => {
    try {
    const { roomId } = req.params;
    const { addedJoiners, deletedJoiners } = req.body;

    // Check user added is exists
    if (addedJoiners && addedJoiners.length) {
      const userExists = await UserModel.checkExists(addedJoiners);
      if (!userExists) {
        return badRequestResponse(res, {
          code: ERROR_CODE.USER_NOT_EXISTS,
          error: "User added not exists",
        });
      }
    }

    // Check user added is exists
    if (deletedJoiners && deletedJoiners.length) {
      const userExists = await UserModel.checkExists(deletedJoiners);
      if (!userExists) {
        return badRequestResponse(res, {
          code: ERROR_CODE.USER_NOT_EXISTS,
          error: "User deleted not exists",
        });
      }
    }

      await UserRoomModel.changeJoiners(roomId, addedJoiners, deletedJoiners);
      return successResponse(res, {
        success: true,
        description: `Room ${roomId} change joiners success`,
      });
    } catch (error) {
      console.log(error);
      return failResponse(res, {
        error: error.message ?? error,
        description: `Room cannot change joiners: ${roomId}`,
      });
    }
  },
};
