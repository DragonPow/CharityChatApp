import http from "http";
import express from "express";
import logger from "./utils/logger/logger_service.js";
import bodyParser from "body-parser";
import { MyWebSocket } from "./config/websocket.js";
import config from "./config/index.js";

import "./models/index.js";

import indexRouter from "./routes/index.js";
import userRouter from "./routes/user.js";
import chatRouter from "./routes/chat.js";
import roomRouter from "./routes/room.js";

const port = config.server.port;

const app = express();
app.set("port", port);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(logger);

// show image and other file in 'public' directory
app.use("/public", express.static("public"));
// app.use('/public',express.static('public/room')); // use localhost:3000/public/...jpg to access public/room/...jpg file

//Router
app.use("/", indexRouter);
app.use("/users", userRouter);
app.use("/rooms", roomRouter);
app.use("/messages", chatRouter);

//Catch 404 and forward to error handler
app.use("*", (req, res) => {
  return res.status(404).json({
    success: false,
    message: "API endpoint does not exist",
  });
});

//Create HTTP server
const httpServer = http.createServer(app);
const socket = MyWebSocket;

//Listen on provided port
httpServer.listen(port);
//Event listener for HTTP server "listening" event
httpServer.on("listening", () => {
  console.log(`Listening on port:: http://localhost:${port}`);
});
