import RoomModel from "../models/room.js";
import UserModel from "../models/user.js";
import UserRoomModel from "../models/user_room.js";
import Model from "../models/model.js";
import { failResponse, successResponse } from "./index.js";

export default {
  onGetRoomsByPaging: async (req, res, next) => {
    const { userId } = req.query;
    const startIndex = parseInt(req.query.startIndex);
    const number = parseInt(req.query.number);

    console.log(appDir);

    try {
      if (!userId || !startIndex || !number) throw new Error("Invalid input");

      const rooms = await RoomModel.getRoomsByPaging(
        startIndex,
        number,
        userId
      );
      const list = await UserRoomModel.getUsersByRoomsId(
        rooms.map((i) => i.id)
      );
      rooms.forEach((i) => {
        i.joinersId = [
          ...list
            .filter((item) => item.roomId === i.id)
            .map((item) => item.userId),
        ];
      });

      return successResponse(res, { rooms: rooms });
    } catch (error) {
      return failResponse(res, { error: error.message });
    }
  },
  onGetRoomsByName: async (req, res, next) => {
    const { textMatch, userId } = req.query;
    const startIndex = parseInt(req.query.startIndex);
    const number = parseInt(req.query.number);

    try {
      if (textMatch === (undefined | null) || !userId || (startIndex===undefined) || (number===undefined)) throw new Error("Invalid input");
      const rooms = await RoomModel.getRoomsByName(
        textMatch,
        startIndex,
        number,
        userId
      );

      return successResponse(res, rooms);
    } catch (error) {
      return failResponse(res, {error: error.message} );
    }
  },
  onCreateRoom: async (req, res, next) => {
    const { name, joinersId } = req.body;
    // const {avatar} = req.files;
    try {
      res.download(avatar)
      const newRoom = await UserRoomModel.createRoom(name, avatar, joinersId);

      return successResponse(res, { room: newRoom });
    } catch (error) {
      return failResponse(res, { error, description: "Cannot create room" });
    }
  },
  onDeleteRoom: async (req, res, next) => {
    const { roomId } = req.body;
    try {
      const success = await Model.callTransaction(async () => {
        //Delete all message in room
        await Message.deleteMessageInRoom(roomId);
        //Delete room
        await UserRoomModel.deleteByRoomId(roomId);
      });

      return successResponse(res, {
        description: `Room ${roomId} delete success`,
      });
    } catch (error) {
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
