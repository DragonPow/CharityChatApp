import express from "express";
import room from "../controllers/room.js";
import { check, checkSchema } from "express-validator";
import { checkInput } from "../utils/middleware/input_validate_service.js";
import { checkToken } from "../utils/middleware/token_service.js";
import MyMulter from "../utils/file/my_multer.js";
import { ROOM_UPLOAD_DIR } from "../config/constant.js";

const router = express.Router();
const uploadRoomFile = MyMulter(ROOM_UPLOAD_DIR);

class RoomInputValidateBuilder {
  static onGetRoom = checkSchema({
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
    searchtype: {
      in: ["query"],
      isIn: {
        options: [["all",'private','group']],
        errorMessage: "Must be 'all', 'private' or 'group'",
      },
    },
  });

  static onFindRoom = checkSchema({
    otherUserId: {
      in: ["query"],
      isString: true,
      exists: {
        options: {
          checkFalsy: true,
        },
      },
      errorMessage: "userId must be string and not empty",
    },
  });

  static onCreateRoom = checkSchema({
    name: {
      in: ["body"],
      isString: true,
      errorMessage: "Must be not null",
    },
    joinersId: {
      in: ["body"],
      custom: {
        options: (value) => {
          const list = String(value).split(",");
          return list.length > 0;
        },
        errorMessage: "At least one member in room",
      },
      customSanitizer: {
        options: (value) => String(value).split(","),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Must provide joinersId",
      },
    },
    typeRoom: {
      in: ["body"],
      isIn: {
        options: [["private", "group"]],
        errorMessage: "Must be 'private' or 'group'",
      },
      optional: true,
    },
  });

  static onChangeInfo = checkSchema({
    roomName: {
      in: ["body"],
      isString: true,
      optional: true,
      errorMessage: "Room name must be string",
    },
    typeRoom: {
      in: ["body"],
      isIn: {
        options: [["private", "group"]],
        errorMessage: "Must be 'private' or 'group'",
      },
      optional: true,
    },
  });

  static onChangeJoiners = checkSchema({
    addedJoiners: {
      in: ["body"],
      // custom: {
      //   options: (value) => {
      //     const list = String(value).split(',');
      //     return list.length > 0;
      //   },
      //   errorMessage: "At least one member in room"
      // },
      customSanitizer: {
        options: (value) => (value.trim() ? String(value).split(",") : []),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Added user must provide id",
      },
    },
    deletedJoiners: {
      in: ["body"],
      // custom: {
      //   options: (value) => {
      //     const list = String(value).split(',');
      //     return list.length > 0;
      //   },
      //   errorMessage: "At least one member in room"
      // },
      customSanitizer: {
        options: (value) => (value.trim() ? String(value).split(",") : []),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Deleted user must provide id",
      },
    },
  });

  static onDeleteRoom = checkSchema({
    roomIds: {
      in: ["body"],
      custom: {
        options: (value) => {
          const list = String(value).trim().split(",");
          return list.length > 0;
        },
        errorMessage: "At least one member in room",
      },
      customSanitizer: {
        options: (value) => (value.trim() ? String(value).trim().split(",") : []),
      },
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Is required",
      },
    },
  });
}

router.get(
  "/select",
  RoomInputValidateBuilder.onGetRoom,
  checkInput,
  checkToken,
  room.onGetRoomsByPaging
);

router.get(
  "/find",
  RoomInputValidateBuilder.onFindRoom,
  checkInput,
  checkToken,
  room.onFindRoomByUserId
);

router.post(
  "/create",
  uploadRoomFile.single("image"),
  RoomInputValidateBuilder.onCreateRoom,
  checkInput,
  checkToken,
  room.onCreateRoom
);

router.put(
  "/u/:roomId/info",
  uploadRoomFile.single("image"),
  RoomInputValidateBuilder.onChangeInfo,
  checkInput,
  checkToken,
  room.onChangeInfo
);

router.put(
  "/u/:roomId/joiners",
  RoomInputValidateBuilder.onChangeJoiners,
  checkInput,
  checkToken,
  room.onJoinersChange
);

// router.put("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete(
  "/delete",
  RoomInputValidateBuilder.onDeleteRoom,
  checkInput,
  checkToken,
  room.onDeleteRoom
);

export default router;
