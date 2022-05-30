import express from "express";
import chat from "../controllers/chat.js";
import { checkSchema } from "express-validator";
import checkInput from "../utils/middleware/check_input.js";
import checkToken from "../utils/middleware/check_token.js";

const router = express.Router();
const getMessagesInRoomInputValidate = checkSchema({
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
const sendMessageInputValidate = checkSchema({
  token: {
    in: ['headers'],
    exists: {
      options: {
        checkFalsy: true,
      },
      errorMessage: "Must provide token",
    }
  },
  content: {
    // in: ["body"],
    exists: {
      options: {
        checkFalsy: true,
      }
    }
  },
  roomId: {
    in: ['body'],
    isString: true,
    exists: {
      options: {
        checkFalsy: true,
      },
      errorMessage: "Must provide roomId",
    },
  }
})

router.get(
  "/select",
  getMessagesInRoomInputValidate,
  checkInput,
  checkToken,
  chat.onGetRoomMessages
);
// router.get("/img/:startIndex&:number", chat.onGetImages);
// router.get("/file/:startIndex&:number", chat.onGetFile);

router.post("/send", chat.onSendMessage);

router.delete("/:messageId", chat.onDeleteMessage);

export default router;
