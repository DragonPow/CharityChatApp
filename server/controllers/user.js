import { TranferFileMulterToString } from "../config/helper.js";
import { MyWebSocket } from "../config/websocket.js";
import UserModel from "../models/user.js";
import { failResponse, successResponse } from "./index.js";
import { deleteFiles } from "../utils/file/file_service.js";

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

  onGetFriends: async (req, res) => {
    const {
      orderby,
      orderdirection,
      startIndex,
      number,
      searchby,
      searchvalue,
    } = req.query;
    const userId = req.userId;
    try {
      const users = await UserModel.getFriends(
        userId,
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
    const { startIndex, number, orderby, orderdirection } = req.query;
    const userId = req.userId;

    try {
      // const usersActiveId = ["2", "3", "4"]; // mock data
      const usersActiveId = MyWebSocket.getActiveUsers();
      console.log("active user: ", usersActiveId);
      const users = await UserModel.FindFriendInUserIds(
        userId,
        usersActiveId,
        startIndex,
        number,
        orderby,
        orderdirection
      );

      return res.status(200).json({ success: true, users });
    } catch (error) {
      return res.status(500).json({ success: false, error: error.message });
    }
  },

  // onGetUserById: async (req, res) => {
  //   try {
  //     const { userId } = req.params;
  //     console.log("onGetUserById");
  //     const user = await UserModel.getUserById(userId);

  //     return res.status(200).json({ super: true, user: user });
  //   } catch (error) {
  //     return res.status(500).json({ success: false, error: error });
  //   }
  // },

  onCreateUser: async (req, res, next) => {
    const {
      name,
      email,
      password,
      phone,
      birthday,
      gender,
      address,
      description,
    } = req.body;
    const image = req.file;

    try {
      const user = await UserModel.createUser(
        name,
        image ? TranferFileMulterToString(image) : undefined,
        email,
        password,
        phone,
        birthday,
        gender,
        address,
        description
      );

      return successResponse(res, { success: true, user: user });
    } catch (error) {
      console.log(error);

      // Delete image
      if (image) {
        deleteFiles([TranferFileMulterToString(image)]).catch((error) =>
          console.log("DELETE_FILE_FAIL", error)
        );
      }

      return failResponse(res, {
        error: error.message ?? error,
        description: `Cannot create user`,
      });
    }
  },
};
