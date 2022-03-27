import UserModel from "../models/user.js";

export default {
    onGetActiveUsersByPage: async (req, res) => {
        try {
            const { startIndex, number } = req.body;
            const users = UserModel.GetActiveUsersByPage(startIndex, number);

            return res.status(200).json({ success: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },

    onGetUsersByName: async (req, res) => {
        try {
            const { nameMatch } = req.params;
            const users = UserModel.GetUsersByName(nameMatch);

            return res.status(200).json({ super: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
};
