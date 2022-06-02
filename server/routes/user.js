import express from "express";
import user from "../controllers/user.js";
import { checkSchema } from "express-validator";
import { checkInput } from "../utils/middleware/input_validate_service.js";
import { checkToken } from "../utils/middleware/token_service.js";

const router = express.Router();

const getUserInputValidate = checkSchema({
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
      options: [["name", "timeCreate"]],
      errorMessage: "Must be 'name' or 'timeCreate'",
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

router.get("/select", getUserInputValidate, checkInput, user.onGetUserByPaging);
router.get("/active/:startIndex&:number", user.onGetActiveUsersByPage);
// router.get("/find/:textMatch", user.onGetUsersByName);
router.get("/userId=:userId", user.onGetUserById);

export default router;
