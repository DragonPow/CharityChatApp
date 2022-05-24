import UserModel from "../models/user.js";
import { failResponse, successResponse } from "./index.js";

export default {
  onGetUserByPaging: async (req, res) => {
    const {
      orderby,
      orderdirection,
      startIndex,
      number,
      searchby,
      searchvalue,
    } = req.query;
    try {
        console.log('test')
      const users = await UserModel.getUserByPaging(
        orderby,
        orderdirection,
        startIndex,
        number,
        searchby,
        searchvalue
      );
      return successResponse(res, { users: users });
    } catch (error) {
      return failResponse(res, { error: error.message });
    }
  },
  onGetActiveUsersByPage: async (req, res) => {
    try {
      const { startIndex, number } = req.params;
      const users = await UserModel.getActiveUsersByPage(startIndex, number);

      return res.status(200).json({ success: true, users });
    } catch (error) {
      return res.status(500).json({ success: false, error: error });
    }
  },

  onGetUsersByName: async (req, res) => {
    try {
      const { textMatch, startIndex, number } = req.params;
      const users = await UserModel.getUsersByName(
        textMatch,
        startIndex,
        number
      );

      return res.status(200).json({ super: true, users });
    } catch (error) {
      return res.status(500).json({ success: false, error: error });
    }
  },

  onGetUserById: async (req, res) => {
    try {
      const { userId } = req.params;
      console.log("onGetUserById");
      const user = await UserModel.getUserById(userId);

      return res.status(200).json({ super: true, user: user });
    } catch (error) {
      return res.status(500).json({ success: false, error: error });
    }
  },
};
