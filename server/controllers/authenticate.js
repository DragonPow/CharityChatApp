import UserModel from "../models/user.js";
import { failResponse, successResponse } from "./index.js";
import jwt from "jsonwebtoken";
import config from "../config/index.js";

export default {
  onLogin: async (req, res) => {
    try {
      const { userName, password } = req.body;
      const user = await UserModel.findByUserNameAndPassword(
        userName,
        password
      );

      // check username and pass wrong
      if (!user) {
        return failResponse(res, {
          message: "Username or password is incorrect",
        });
      }

      // create jwt
      var token = jwt.sign(user.id, config.jwt.secretCode, {
        expiresIn: config.jwt.expireTime,
      });

      return successResponse(res, { status: true, user, token });
    } catch (error) {
      return failResponse(res, error);
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
