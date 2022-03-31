import UserModel from "../models/user.js";

export default {
    onGetActiveUsersByPage: async (req, res) => {
        try {
            const { startIndex, number } = req.params;
            const users = await UserModel.statics.getActiveUsersByPage(startIndex, number);

            return res.status(200).json({ success: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },

    onGetUsersByName: async (req, res) => {
        try {
            const { textMatch, startIndex, number } = req.params;
            const users = await UserModel.getUsersByName(textMatch, startIndex, number);

            return res.status(200).json({ super: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },

    onGetUserById: async (req, res) => {
        try {
            const { userId } = req.params;
            const users = await UserModel.getUserById(userId);

            return res.status(200).json({ super: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
};
