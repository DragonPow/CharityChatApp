import express from "express";
import room from "../controllers/room.js";
import { checkSchema } from "express-validator";
import checkInput from '../utils/middleware/check_input.js';
import checkToken from '../utils/middleware/check_token.js';

const router = express.Router();

router.get(
  "/select",
  checkSchema({
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
        errorMessage: 'Larger or equal 0'
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
          errorMessage: 'Larger or equal 1'
      },
      toInt: true,
    },
    orderby: {
      in: ["query"],
      isIn: {
        options: [["name", "lastMessage", "createTime"]],
        errorMessage: "Must be 'name', 'lastMessage' or 'createTime'",
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
  }),
  checkInput,
  room.onGetRoomsByPaging
);
// router.get("/roomName", room.onGetRoomsByName);

router.post("/create", checkSchema({
  token: {
    in: ['headers'],
    exists: {
      options: {
        checkFalsy: true,
      },
      errorMessage: 'Must provide token'
    },
  },
  name: {
    in: ['body'],
  },
  joinersId: {
    in: ['body'],
    isArray: {
      options: {
        min: 1
      },
      errorMessage: 'At least one member in room'
    },
  }
}), checkInput, checkToken, room.onCreateRoom);
router.put("/u/:roomId", checkSchema({
  
}), checkInput, checkToken, room.onUpdateRoom);
// router.put("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete("/d/:roomId", checkInput, checkToken, room.onDeleteRoom);

// TODO: add route addUserToRoom
// TODO: add route removeUserFromRoom

export default router;
