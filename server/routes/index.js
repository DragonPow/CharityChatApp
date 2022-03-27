import express from "express";

const router = express.Router();

router
    .get("/", (req, res, next) => {
        return res
            .status(200)
            .json({ success: true, message: "Main home page" });
    })
    .post("/login/:userId", (req, res, next) => {
        //TODO: check user auth
        return res
            .status(200)
            .json({ success: true, message: "This is homepage" });
    });

export default router;
