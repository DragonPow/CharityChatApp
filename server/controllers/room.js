import Room from "../models/room.js";
import Message from "../models/message.js";

export default {
    onGetRooms: async (req, res, next) => {
        try {
            const { startIndex, number } = req.body;
            const { userId } = req.params;
            const rooms = await Room.getRooms(startIndex, number, userId);

            return res.status(200).json({
                success: true,
                rooms,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onGetRoomsByName: async (req, res, next) => {
        try {
            const { textMatch, startIndex, number } = req.params;
            const rooms = await Room.getRoomsByName(
                textMatch,
                startIndex,
                number
            );

            return res.status(200).json({
                success: true,
                rooms,
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onDeleteRoom: async (req, res, next) => {
        try {
            const { roomId } = req.body;
            //Delete room
            await Room.delete(roomId);

            //Delete all message in room
            //TODO: delete message of room

            return res.status(200).json({
                success: true,
                description: `Room ${roomId} delete success`,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: `Room ${roomId} cannot delete`,
            });
        }
    },
    onUpdateRoom: async (req, res, next) => {
        try {
            const { room } = req.body;
            await Room.update(room);

            return res.status(200).json({
                success: true,
                description: `Room update success:\n{room}`,
            });
        } catch (error) {
            return res.status(500).json({
                success: false,
                error: error,
                description: `Room cannot update:\n${room}`,
            });
        }
    },
};
