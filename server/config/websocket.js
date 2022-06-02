import { Server } from "socket.io";
import http from "http";
import UserModel from "../models/user.js";
import config from "../config/index.js";
import { parseTokenToObject } from "../utils/middleware/token_service.js";

const port_socket = config.server.port_socket;

const socketEvent = {
  messageSent: "messageSent",
  roomUpdate: "roomUpdate",
  messageRead: "messageRead",
  outRoom: "outRoom",
  jointRoom: "jointRoom",
};

class WebSocket {
  activeUsers = [];

  emitMessageSent(roomId, message) {
    io.on(getRoom(roomId)).emit(socketEvent.messageSent, message);
  }

  emitRoomUpdate(room) {
    io.on(getRoom(room.id)).emit(socketEvent.roomUpdate, room);
  }

  emitReadMessage(roomId, userId, messageId) {
    io.on(getRoom(roomId)).emit(socketEvent.messageRead, userId, messageId);
  }

  emitOutRoom(roomId, usersId) {
    io.on(getRoom(roomId)).emit(socketEvent.outRoom, usersId);
  }

  emitJoinRoom(roomId, usersId) {
    io.on(getRoom(roomId)).emit(socketEvent.jointRoom, usersId);
  }

  addUser(value) {
    if (value && this.activeUsers.some((i) => i.userId === value.userId)) {
      this.activeUsers.push(value);
    }
  }

  removeUser(sessionId) {
    if (sessionId && this.activeUsers.some((i) => i.sessionId === sessionId)) {
      this.activeUsers = this.activeUsers.filter((i) => i !== value);
    }
  }

  connection(client) {
    console.log("User is connected");

    client.on("login", (token) => {
      const { id } = parseTokenToObject(token);
      this.addUser({ sessionId: client.id, userId: id });
    });

    client.on("logout", () => {
      const sessionId = client.id;
      this.removeUser(sessionId);
    });

    // Define when user is disconnect with server
    client.on("disconnect", () => {
      console.log("User is disconnected");
      const sessionId = client.id;
      this.removeUser(sessionId);
    });
  }
}

async function getRoom(roomId) {
  let joiners = await UserModel.getJoinersInRoom(roomId);
  return joiners.map((user) => user.id);
}

const webSocketSingleton = new WebSocket();

//Create socket connection
const io = new Server();
io.listen(port_socket);
io.on("connection", webSocketSingleton.connection);
io.engine.on("connection_error", (err) => {
  console.log(err.req); // the request object
  console.log(err.code); // the error code, for example 1
  console.log(err.message); // the error message, for example "Session ID unknown"
  console.log(err.context); // some additional error context
});

export default webSocketSingleton;
