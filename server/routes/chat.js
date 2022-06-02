import express from "express";
import chat from "../controllers/chat.js";
import { checkSchema } from "express-validator";
import {checkInput} from "../utils/middleware/input_validate_service.js";
import { checkToken } from "../utils/middleware/token_service.js";
import {
  CHAT_UPLOAD_DIR,
  MAX_FILE_NUMBER_RECEIVE,
  MAX_FILE_SIZE_RECEIVE,
} from "../config/constant.js";
import { badRequestResponse } from "../controllers/index.js";
import myMulter from "../utils/file/my_multer.js";

const router = express.Router();

const upload = myMulter(
  CHAT_UPLOAD_DIR,
  MAX_FILE_SIZE_RECEIVE,
  MAX_FILE_NUMBER_RECEIVE
).array("files");

class ChatInputValidateBuilder {
  static onGetMessagesInRoom = checkSchema({
    roomId: {
      in: ["query"],
      errorMessage: "Need contain",
      exists: true,
    },
    startIndex: {
      in: ["query"],
      errorMessage: "Must be positive number",
      exists: true,
      isInt: {
        options: {
          min: 0,
        },
        errorMessage: "Larger or equal 0",
      },
      toInt: true,
    },
    number: {
      in: ["query"],
      errorMessage: "Must be positive number",
      exists: true,
      isInt: {
        options: {
          min: 1,
        },
        errorMessage: "Larger or equal 1",
      },
      toInt: true,
    },
    orderby: {
      in: ["query"],
      isIn: {
        options: [["createTime"]],
        errorMessage: "Must be 'createTime'",
      },
      errorMessage: "Not null",
      exists: {
        options: {
          checkFalsy: true, // for 0, '', false, null
        },
      },
    },
    orderdirection: {
      in: ["query"],
      isIn: {
        options: [["asc", "desc"]],
        errorMessage: "Must be 'asc', or 'desc'",
      },
      errorMessage: "Not null",
      exists: {
        options: {
          checkFalsy: true, // for 0, '', false, null
        },
      },
    },
    searchby: {
      in: ["query"],
      isIn: {
        options: [["all", "text", "media", "file"]],
        errorMessage: "Must be 'all', 'text','media' or 'file'",
      },
    },
    searchvalue: {
      in: ["query"],
      trim: true,
    },
  });
  static onGetAllMessages = checkSchema({
    startIndex: {
      in: ["query"],
      errorMessage: "Must be positive number",
      exists: true,
      isInt: {
        options: {
          min: 0,
        },
        errorMessage: "Larger or equal 0",
      },
      toInt: true,
    },
    number: {
      in: ["query"],
      errorMessage: "Must be positive number",
      exists: true,
      isInt: {
        options: {
          min: 1,
        },
        errorMessage: "Larger or equal 1",
      },
      toInt: true,
    },
    orderby: {
      in: ["query"],
      isIn: {
        options: [["createTime"]],
        errorMessage: "Must be 'createTime'",
      },
      errorMessage: "Not null",
      exists: {
        options: {
          checkFalsy: true, // for 0, '', false, null
        },
      },
    },
    orderdirection: {
      in: ["query"],
      isIn: {
        options: [["asc", "desc"]],
        errorMessage: "Must be 'asc', or 'desc'",
      },
      errorMessage: "Not null",
      exists: {
        options: {
          checkFalsy: true, // for 0, '', false, null
        },
      },
    },
    searchby: {
      in: ["query"],
      isIn: {
        options: [["all", "text", "media", "file"]],
        errorMessage: "Must be 'all', 'text','media' or 'file'",
      },
    },
    searchvalue: {
      in: ["query"],
      trim: true,
    },
  });
  static onCreateMessageByRoom = checkSchema({
    token: {
      in: ["headers"],
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide token",
      },
    },
    content: {
      in: ["body"],
      // exists: {
      //   options: {
      //     checkFalsy: true,
      //   },
      // },
    },
    roomId: {
      in: ["body"],
      isString: true,
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide roomId",
      },
    },
  });
  static onCreateMessageByUser = checkSchema({
    token: {
      in: ["headers"],
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide token",
      },
    },
    content: {
      in: ["body"],
      // exists: {
      //   options: {
      //     checkFalsy: true,
      //   },
      // },
    },
    usersId: {
      in: ["body"],
      custom: {
        options: (value) => {
          const list = String(value).split(",");
          return list.length > 0;
        },
        errorMessage: "At least one user to chat",
      },
      customSanitizer: {
        options: (value) => String(value).split(","),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide usersId",
      },
    },
  });
  static onUpdateMessage = checkSchema({
    token: {
      in: ["headers"],
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide token",
      },
    },
    content: {
      in: ["body"],
      // exists: {
      //   options: {
      //     checkFalsy: true,
      //   },
      // },
    },
  });
}

// Route
router.get(
  "/select",
  ChatInputValidateBuilder.onGetMessagesInRoom,
  checkInput,
  checkToken,
  chat.onGetRoomMessages
);

router.get(
  "/selectAll",
  ChatInputValidateBuilder.onGetAllMessages,
  checkInput,
  checkToken,
  chat.onGetAllMessages
);

router.post(
  "/send/byRoomId",
  (req, res, next) =>
    upload(req, res, function (error) {
      if (error) {
        return badRequestResponse(res, {
          error: error.message,
          code: "FILE_INPUT_ERROR",
        });
      }
      return next();
    }),
  ChatInputValidateBuilder.onCreateMessageByRoom,
  checkInput,
  checkToken,
  chat.onCreateMessageByRoomId
);

router.post(
  "/send/byUserId",
  (req, res, next) =>
    upload(req, res, function (error) {
      if (error) {
        return badRequestResponse(res, {
          error: error.message,
          code: "FILE_INPUT_ERROR",
        });
      }
      return next();
    }),
  ChatInputValidateBuilder.onCreateMessageByUser,
  checkInput,
  checkToken,
  chat.onCreateMessageByUserId
);

router.post(
  "/update",
  (req, res, next) =>
    upload(req, res, function (error) {
      if (error) {
        return badRequestResponse(res, {
          error: error.message,
          code: "FILE_INPUT_ERROR",
        });
      }
      return next();
    }),
  ChatInputValidateBuilder.onUpdateMessage,
  checkInput,
  checkToken,
  chat.onUpdateMessage
);

router.delete("/:messageId", chat.onDeleteMessage);

export default router;
