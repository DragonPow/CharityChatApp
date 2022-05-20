import express from "express";
import room from "../controllers/room.js";
import { checkSchema, param } from "express-validator";
import { INVALID_INPUT_MESSAGE } from "../config/constant.js";
import validateInputRoute from "./invalid_input.js";

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
  }),
  validateInputRoute,
  room.onGetRoomsByPaging
);
router.get("/roomName", room.onGetRoomsByName);

router.post("/c/", room.onCreateRoom);
router.put("/u/:roomId", room.onUpdateRoom);
// router.put("/u/avatar/:roomId", room.onUpdateAvatarRoom);
router.delete("/d/:roomId", room.onDeleteRoom);

// TODO: add route addUserToRoom
// TODO: add route removeUserFromRoom

export default router;
