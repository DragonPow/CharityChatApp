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
    const { name, joinersId } = req.body;
    const userId = req.userId;
    const avatarUri = req.file?.path ?? null;
    try {
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
    const { roomId } = req.body;
    const userId = req.userId;

    try {
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
  onUpdateRoom: async (req, res, next) => {
    const { room } = req.body;
    try {
      await RoomModel.updateRoom(room);

      return successResponse(res, {
        description: `Room ${room.id} update success`,
      });
    } catch (error) {
      return failResponse(res, {
        error,
        description: `Room cannot update:\n${room}`,
      });
    }
  },
  onUpdateAvatarRoom: async (req, res, next) => {
    const { avatar } = req.body;
    const { roomId } = req.params;

    try {
      const rs = await RoomModel.updateAvatarRoom(roomId, avatar);
      if (rs.error) throw rs.error;

      return successResponse(res, {
        description: `Avatar room ${roomId} update success`,
        avatarId: rs.id,
      });
    } catch (error) {
      return failResponse(res, {
        error,
        description: `Avatar room cannot update`,
      });
    }
  },
};
