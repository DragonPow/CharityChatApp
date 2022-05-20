import http from "http";
import express from "express";
import logger from './utils/logger/logger_service.js';
import bodyParser from 'body-parser';
import { Server } from "socket.io";
import WebSocket from "./config/websocket.js";

import './models/index.js';

import indexRouter from "./routes/index.js";
import userRouter from "./routes/user.js";
import chatRouter from "./routes/chat.js";
import roomRouter from "./routes/room.js";


const app = express();

const port = process.env.PORT || "3000";
app.set("port", port);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(logger);

//Router
app.use("/", indexRouter);
app.use("/users", userRouter);
app.use("/rooms", roomRouter);
app.use("/:roomId", chatRouter);

// import("./models/relationship.js");
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
io.on("connection", WebSocket.connection);

//Listen on provided port
httpServer.listen(port);
//Event listener for HTTP server "listening" event
httpServer.on("listening", () => {
    console.log(`Listening on port:: http://localhost:${port}`);
});