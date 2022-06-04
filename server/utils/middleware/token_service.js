import express from "express";
import jwt from "jsonwebtoken";
import config from "../../config/index.js";
import {
  successResponse,
  unAuthorizedResponse,
} from "../../controllers/index.js";

const router = express.Router();

function parseTokenToObject(token) {
  let decoded = jwt.verify(token, config.jwt.secretCode);
  return decoded;
}

/**
 * 
 * @param {{id: string, [key in string]: any}} object 
 * @returns 
 */
function buildToken(object) {
  return jwt.sign(object, config.jwt.secretCode, {
    expiresIn: config.jwt.expireTime,
  });
}

router.use((req, res, next) => {
  const token = req.headers.token;
  if (token) {
    // Check is admin
    if (token === config.jwt.tokenAdmin) {
      console.log("TOKEN_CHECK_SUCCESS:", "Token is admin");
      req.userId = config.adminId;
      return next();
    }

    // ? Can delete it if not needed
    if (token === config.jwt.tokenExample) {
      console.log("TOKEN_CHECK_SUCCESS:", "Token is example");
      req.userId = config.exampleId;
      return next();
    }

    // Check is user
    try {
      const { id } = parseTokenToObject(token);
      console.log("TOKEN_CHECK_SUCCESS:", "Token is user: " + id);
      req.userId = id;
      return next();
    } catch (error) {
      return unAuthorizedResponse(res, { message: "Invalid token" });
    }
    // jwt.verify(token, config.jwt.secretCode, (error, decoded) => {
    //   if (error) {
    //     return successResponse(res, { message: "Invalid token" });
    //   } else {
    //     console.log("TOKEN_CHECK_SUCCESS:", "Token is user: " + decoded.id);
    //     req.userId = decoded.id;
    //     return next();
    //   }
    // });
  } else {
    return unAuthorizedResponse(res, { message: "No token provided" });
  }
});

// const tokenSchema = {
//   token: {
//     in: ["headers"],
//     exists: {
//       options: {
//         checkFalsy: true,
//       },
//       errorMessage: "Must provide token",
//     },
//   },
// };

export { router as checkToken, buildToken, parseTokenToObject };
