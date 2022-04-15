import RoomModel from "../models/room.js";
import UserModel from "../models/user.js";
import UserRoomModel from "../models/user_room.js";
import Model from "../models/model.js";

export default {
    onGetRoomsByPaging: async (req, res, next) => {
        const { userId } = req.params;
        const startIndex = Number(req.params.startIndex);
        const number = Number(req.params.number);

        try {
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

            return res.status(200).json({
                success: true,
                rooms,
            });
        } catch (error) {
            return res.status(500).json({ success: "false ne", error: error });
        }
    },
    onGetRoomsByName: async (req, res, next) => {
        const { textMatch, userId } = req.params;
        const { startIndex, number } = req.body;
        try {
            const rooms = await RoomModel.getRoomsByName(
                textMatch,
                startIndex,
                number,
                userId
            );

            return res.status(200).json({
                success: true,
                rooms,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onCreateRoom: async (req, res, next) => {
        const { roomInfo, listUsersId } = req.body;
        try {
            const newRoom = await UserRoomModel.createRoom(
                roomInfo,
                listUsersId
            );

            return res.status(200).json({
                success: true,
                description: `Room ${newRoom.id} create success`,
                room: newRoom,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: `Room cannot create`,
            });
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

            return res.status(200).json({
                success,
                description: `Room ${roomId} delete ${
                    success ? "success" : "fail"
                }`,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error,
                description: `Room ${roomId} cannot delete`,
            });
        }
    },
    onUpdateRoom: async (req, res, next) => {
        const { room } = req.body;
        try {
            await RoomModel.updateRoom(room);

            return res.status(200).json({
                success: true,
                description: `Room update success:\n${room}`,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
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

            return res.status(200).json({
                success: true,
                description: `Avatar room update complete`,
                avatarId: rs.id,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: `Avatar room cannot update`,
            });
        }
    },
};
