import express from "express";

const router = express.Router();

router.get('/', (req, res, next) => {
    return res
        .status(200)
        .json({ success: true, message: "Connect to server success" });
}).get('/home', (req, res, next) => {
    return res
    .status(200)
    .json({ success: true, message: "Go to home page success" });
});

export default router;
