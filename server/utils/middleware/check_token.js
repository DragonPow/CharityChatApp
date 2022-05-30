import express from "express";
import jwt from "jsonwebtoken";
import config from "../../config/index.js";
import { successResponse } from "../../controllers/index.js";
import { checkSchema } from "express-validator";

const router = express.Router();

router.use((req, res, next) => {
  const token = req.headers.token;
  if (token) {
    // Check is admin
    if (token === config.jwt.tokenAdmin) {
      console.log("TOKEN_CHECK_SUCCESS:", "Token is admin");
      req.userId = config.adminId;
      return next();
    }

    // Check is user
    jwt.verify(token, config.jwt.secretCode, (error, decoded) => {
      if (error) {
        return successResponse(res, { message: "Invalid token" });
      } else {
        console.log("TOKEN_CHECK_SUCCESS:", "Token is user: " + decoded.id);
        req.userId = decoded.id;
        return next();
      }
    });
  } else {
    return successResponse(res, { message: "No token provided" });
  }
});

const tokenSchema = {
  token: {
    in: ["headers"],
    exists: {
      options: {
        checkFalsy: true,
      },
      errorMessage: "Must provide token",
    },
  },
};

export default router;
export { tokenSchema };
