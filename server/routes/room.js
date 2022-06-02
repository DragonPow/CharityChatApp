import express from "express";
import room from "../controllers/room.js";
import { checkSchema } from "express-validator";
import {checkInput} from "../utils/middleware/input_validate_service.js";
import {checkToken} from "../utils/middleware/token_service.js";
import multer from 'multer';
import { ROOM_UPLOAD_DIR } from "../config/constant.js";


const router = express.Router();
const uploadRoomFile = multer({dest: ROOM_UPLOAD_DIR});

class RoomInputValidateBuilder {
  static onGetRoom = checkSchema({
    // tokenSchema, // TODO: fix token here
    userId: {
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
        options: [["name", "lastMessage", "timeCreate"]],
        errorMessage: "Must be 'name', 'lastMessage' or 'timeCreate'",
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
        options: [["name"]],
        errorMessage: "Must be 'name'",
      },
    },
    searchvalue: {
      in: ["query"],
      trim: true,
    },
  });
  static onFindRoom = checkSchema({
    otherUserId: {
      in:['query'],
      isString: true,
      exists: {
        options: {
          checkFalsy: true
        }
      },
      errorMessage: 'userId must be string and not empty',
    }
  })
  static onCreateRoom = checkSchema({
    name: {
      in: ["body"],
      isString: true,
    },
    joinersId: {
      in: ["body"],
      custom: {
        options: (value) => {
          const list = String(value).split(',');
          return list.length > 0;
        },
        errorMessage: "At least one member in room"
      },
      customSanitizer: {
        options: (value) => String(value).split(','),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide joinersId",
      },
    },
  });

}

router.get(
  "/select",
  RoomInputValidateBuilder.onGetRoom,
  checkInput,
  // checkToken,
  room.onGetRoomsByPaging
);

router.get(
  '/find',
  RoomInputValidateBuilder.onFindRoom,
  checkInput,
  checkToken,
  room.onFindRoomByUserId
)

router.post(
  "/create",
  uploadRoomFile.single('image'),
  RoomInputValidateBuilder.onCreateRoom,
  checkInput,
  checkToken,
  room.onCreateRoom
);

router.put(
  "/u/:roomId",
  checkSchema({}),
  checkInput,
  checkToken,
  room.onUpdateRoom
);

// router.put("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete("/d/:roomId", checkInput, checkToken, room.onDeleteRoom);

// TODO: add route addUserToRoom
// TODO: add route removeUserFromRoom

export default router;
