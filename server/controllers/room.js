import RoomModel from "../models/room.js";
import UserRoomModel from "../models/user_room.js";
import Model from "../models/model.js";

export default {
    onGetRoomsByPaging: async (req, res, next) => {
        const { startIndex, number } = req.body;
        const { userId } = req.query;
        try {
            const roomsId = await UserRoomModel.getRoomsByPaging(
                startIndex,
                number,
                userId
            );
            const rooms = await RoomModel.getRoomsById(roomsId);
            // const rooms = await RoomModel.getRoomsByPaging(startIndex, number, userId);

            return res.status(200).json({
                success: true,
                rooms,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onGetRoomsByName: async (req, res, next) => {
        const { textMatch, userId } = req.query;
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
        const { roomId } = req.query;

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
