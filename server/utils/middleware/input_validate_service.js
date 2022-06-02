import express from "express";
import { validationResult } from "express-validator";
import { INVALID_INPUT_MESSAGE } from "../../config/constant.js";
import { badRequestResponse } from "../../controllers/index.js";

const router = express.Router();

const myValidationResult = validationResult.withDefaults({
  formatter: (error) => {
    return error.msg;
  },
});

router.use((req, res, next) => {
  try {
    validationResult(req).throw();
    next();
  } catch (error) {
    return badRequestResponse(res, {
      message: INVALID_INPUT_MESSAGE,
      errors: myValidationResult(req).mapped(),
    });
  }
});

export {router as checkInput};
