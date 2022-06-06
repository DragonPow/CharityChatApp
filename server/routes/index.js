import express from "express";
import { checkSchema } from "express-validator";
import authenticate from "../controllers/authenticate.js";
import { checkInput } from "../utils/middleware/input_validate_service.js";

const router = express.Router();

class AuthenticateInputValidate {
    static login = checkSchema({
        username:{
            in:['query'],
            isString: true,
            exists: {
                options: {
                    checkFalsy: true
                }
            },
            errorMessage: 'Is required'
        },
        password:{
            in:['query'],
            isString: true,
            exists: {
                options: {
                    checkFalsy: true
                }
            },
            errorMessage: 'Is required'
        }
    })
}

router.get("/", (req, res, next) => {
  return res.status(200).json({ success: true, message: "Main home page" });
});
router.get("/login", AuthenticateInputValidate.login, checkInput, authenticate.onLogin);
router.get("/logout", authenticate.onLogout);

export default router;
