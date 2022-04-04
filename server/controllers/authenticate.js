import UserModel from "../models/user.js";

export default {
    onLogin: async (req, res) => {
        try {
            const { userName, password } = req.body;
            const user = await UserModel.logIn(userName, password);

            return res.status(200).json({ success: true, user });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },

    onLogout: async (req, res) => {
        try {
            const { userName } = req.query;
            await UserModel.logOut(userName);

            return res.status(200).json({ super: true });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },
};
