import http from "http";
import express from "express";
import indexRouter from "./routes/index.js";
import userRouter from "./routes/user.js";
import roomRouter from "./routes/room.js";
import { Server } from "socket.io";

const app = express();

const port = process.env.PORT || "3000";
app.set("port", port);

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

//Navigator to another
app.use("/", indexRouter);
app.use("/users", userRouter);
app.use("/rooms", roomRouter);

//Catch 404 and forward to error handler
app.use("*", (req, res) => {
    return res.status(404).json({
        success: false,
        message: "API endpoint does not exist",
    });
});

//Create HTTP server
const httpServer = http.createServer(app);
//Create socket connection
//TODO: make socket listen from server
const io = new Server(httpServer);
io.on("connection", (socket) => {
    console.log(`Socket: ${socket}`);
});

//Listen on provided port
httpServer.listen(port);
//Event listener for HTTP server "listening" event
httpServer.on("listening", () => {
    console.log(`Listening on port:: http://localhost:${port}`);
});
