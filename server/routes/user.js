import express from "express";
import user from "../controllers/user.js";
import { checkSchema } from "express-validator";
import { checkInput } from "../utils/middleware/input_validate_service.js";
import { checkToken } from "../utils/middleware/token_service.js";
import myMulter from "../utils/file/my_multer.js";
import { USER_UPLOAD_DIR } from "../config/constant.js";

const router = express.Router();

const uploadUserFile = myMulter(USER_UPLOAD_DIR);

class UserInputValidateBuilder {
  static getActiveUser = checkSchema({
    token: {
      in: ["headers"],
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Token is required",
      },
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
        options: [["name"]],
        errorMessage: "Must be 'name'",
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
  });

  static getUser = checkSchema({
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

  static createUser = checkSchema({
    name: {
      in: ["body"],
      isString: true,
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Name is required",
      },
    },
    email: {
      in: ["body"],
      isString: true,
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Email is required",
      },
    },
    password: {
      in: ["body"],
      isString: true,
      exists: {
        options: {
          checkFalsy: true,
        },
        errorMessage: "Password is required",
      },
    },
    phone: {
      in: ["body"],
      isString: true,
      optional: true,
    },
    birthday: {
      in: ["body"],
      isString: true,
      optional: true,
    },
    gender: {
      in: ["body"],
      isIn: {
        options: [[0,1,2]],
        errorMessage: 'Gender is in 0,1,2',
      },
      optional: true,
      default: 0,
    },
    address: {
      in: ["body"],
      isString: true,
      optional: true,
    },
    description: {
      in: ["body"],
      isString: true,
      optional: true,
    },
  });
}

router.get(
  "/select",
  UserInputValidateBuilder.getUser,
  checkInput,
  user.onGetUserByPaging
);

router.get(
  "/friend",
  UserInputValidateBuilder.getUser,
  checkInput,
  checkToken,
  user.onGetFriends
);

router.get(
  "/active",
  UserInputValidateBuilder.getActiveUser,
  checkInput,
  checkToken,
  user.onGetActiveUsersByPage
);

// router.get("/findById", user.onGetUserById);

router.post(
  "/create",
  uploadUserFile.single('image'),
  UserInputValidateBuilder.createUser,
  checkInput,
  checkToken,
  user.onCreateUser
);

export default router;
