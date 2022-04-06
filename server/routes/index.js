import express from "express";
import authenticate from "../controllers/authenticate.js";

const router = express.Router();

router
    .get("/", (req, res, next) => {
        return res
            .status(200)
            .json({ success: true, message: "Main home page" });
    })
    .post("/login/", authenticate.onLogin)
    .post("/logout/", authenticate.onLogin);

export default router;
