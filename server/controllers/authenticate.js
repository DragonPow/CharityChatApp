import UserModel from "../models/user.js";
import { badRequestResponse, failResponse, successResponse } from "./index.js";
import jwt from "jsonwebtoken";
import config from "../config/index.js";
import { buildToken } from "../utils/middleware/token_service.js";
import { MyWebSocket } from "../config/websocket.js";

export default {
  onLogin: async (req, res) => {
    const { username, password } = req.query;
    try {
      const user = await UserModel.findByUserNameAndPassword(
        username,
        password
      );

      // check username and pass wrong
      if (!user) {
        return badRequestResponse(res, {
          code: 'USER_NAME_OR_PASS_WRONG',
          error: "Username or password is incorrect",
        });
      }

      // create jwt
      var token = buildToken({id: user.id});

      return successResponse(res, { success: true, user: user, token: token });
    } catch (error) {
      console.log(error);
      return failResponse(res, {error: error.message ?? error, description: 'Login fail'});
    }
  },

  onLogout: async (req, res) => {
    const userId = req.userId;
    try {
      await UserModel.logOut(userName);

      return res.status(200).json({ super: true });
    } catch (error) {
      return res.status(500).json({ success: false, error: error });
    }
  },
};
