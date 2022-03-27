import Message from "../models/room.js";

export default {
    onGetRoomMessage: async (req, res, next) => {
        try {
            return res.status(200).json({
                success: true,
                content: {
                    text: "Connect to room chat success",
                },
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
    onFindContent: async (req, res, next) => {
        try {
            
        } catch (error) {
            
        }
    },
};
