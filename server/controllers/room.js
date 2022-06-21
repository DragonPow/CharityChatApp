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
import { MyNotifySocket } from "../config/websocket.js";

export default {
  onGetRoomsByPaging: async (req, res, next) => {
    const {
      userId,
      orderby,
      orderdirection,
      startIndex,
      number,
      searchby,
      searchvalue,
      searchtype,
    } = req.query;
    try {
      // get room
      const rooms = await RoomModel.getRoomsByPaging(
        startIndex,
        number,
        userId,
        orderby,
        orderdirection,
        searchby,
        searchvalue,
        searchtype
      );

      // get user of room
      const joiners = await UserModel.getJoinersInRoom(rooms.map((i) => i.id));
      rooms.forEach((i) => {
        var list = joiners
          .filter((item) =>
            Array.from(item.container).some((room) => room.id == i.id)
          )
          .map(({ container, ...item }) => {
            const a= [1,2,3];
            a.find(i=>i==1);
            const alias = container.find(small=>small.id === i.id);
            return {...item, nameAlias: alias?.UserRoom.nameAlias ?? null};
          });
        i.joiners = list;
      });

      return successResponse(res, { rooms: rooms });
    } catch (error) {
      return failResponse(res, { error: error.message });
    }
  },

  onFindRoomByUserId: async (req, res, next) => {
    const { otherUserId } = req.query;
    const userId = req.userId;

    try {
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
    const { name, joinersId, typeRoom } = req.body;
    const userId = req.userId;
    const image = req.file;

    try {
      console.log(image);
      if (image && !IsImageFile(image.filename)) {
        return badRequestResponse(res, {
          error: ERROR_CODE.FILE,
          message: "File must be image",
        });
      }

      const avatarUri = image ? TranferFileMulterToString(image) : undefined;
      const joiners =
        userId === config.adminId ? joinersId : [...joinersId, userId]; // If creator is admin, don't add
      const newRoom = await RoomModel.createRoom(
        name,
        avatarUri,
        joiners,
        typeRoom
      );

      MyNotifySocket.RoomUpdate([newRoom.id]);
      
      if (!newRoom) {
        return successResponse(res, { success: false });
      }
      
      const resRoom = await RoomModel.getRoomsById([newRoom.id]);
      return successResponse(res, { success: true, room: resRoom });
    } catch (error) {
      console.log(error);

      // Delete image
      if (image) {
        deleteFiles([TranferFileMulterToString(image)]).catch((error) =>
          console.log("Cannot delete image")
        );
      }

      return failResponse(res, {
        error: error.message,
        description: "Cannot create room",
      });
    }
  },

  onDeleteRoom: async (req, res, next) => {
    const { roomIds } = req.body;
    const userId = req.userId;

    try {
      {
        // Check room exists
        const roomExists = await RoomModel.checkExists(roomIds);
        if (!roomExists) {
          return badRequestResponse(res, {
            code: ERROR_CODE.ROOM_NOT_EXISTS,
            description: "Room is not exists",
          });
        }
      }

      // If is admin, next
      if (userId !== config.adminId) {
        // Check user is joiner of room
        console.log(roomIds);
        const tasks = await Promise.all(
          roomIds.map((roomId) =>
            UserRoomModel.CheckIsJoinerOfRoom(userId, roomId)
          )
        );
        const isJoiner = tasks.every((isJoiner) => isJoiner);

        if (!isJoiner) {
          return badRequestResponse(res, {
            code: ERROR_CODE.ACCESS_DENIED,
            description: "User must be in the joiner of room to delete",
          });
        }
      }

      // Find image Urls
      const rooms = await RoomModel.getRoomsById(roomIds);
      const imageUrls = rooms
        .map((room) => room.avatarId)
        .filter((image) => image !== null);

      //Delete rooms
      await RoomModel.deleteByIds(roomIds);
      //Delete image in rooms
      deleteFiles(imageUrls).catch((error) =>
        console.log("Cannot delete files: ", imageUrls)
      );

      return successResponse(res, {
        success: true,
        description: `Delete success`,
      });
    } catch (error) {
      console.log(error);
      return failResponse(res, {
        error: error.message ?? error,
        description: `Cannot delete rooms: ${roomIds}`,
      });
    }
  },
  onChangeInfo: async (req, res, next) => {
    const { roomId } = req.params;
    const { roomName, typeRoom, aliasJoiners } = req.body;
    const image = req.file;

    console.log('AliasJoiners', JSON.parse(aliasJoiners));

    try {
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
      const room = await RoomModel.updateRoom(
        roomId,
        roomName,
        imageUrl,
        typeRoom,
        JSON.parse(aliasJoiners),
      );

      MyNotifySocket.RoomUpdate([roomId]);

      return successResponse(res, {
        success: true,
        description: `Room ${roomId} update complete`,
        room: room,
      });
    } catch (error) {
      console.log(error);

      // Delete image
      if (image) {
        deleteFiles([TranferFileMulterToString(image)]).catch((error) =>
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
    const { roomId } = req.params;
    const { addedJoiners, deletedJoiners } = req.body;

    try {
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

      MyNotifySocket.RoomUpdate([roomId]);

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
