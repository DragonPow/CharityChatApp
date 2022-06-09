"use_strict";
import Server from "socket.io";
import http from "http";
import UserModel from "../models/user.js";
import config from "../config/index.js";
import { parseTokenToObject } from "../utils/middleware/token_service.js";
import RoomModel from "../models/room.js";
import UserRoomModel from "../models/user_room.js";

const port_socket = config.server.port_socket;

/**
 *
 * @param {String} roomId
 * @returns {Promise<String[]>} joiner id
 */
async function getUsersIdOfRoom(roomId) {
  let joiners = await UserModel.getJoinersInRoom([roomId]);
  console.log(`Joiner of room ${roomId}: `, joiners);
  return joiners.map((user) => user.id);
}

const SocketEvent = {
  messageSent: "messageSent",
  roomUpdate: "roomUpdate",
  messageRead: "messageRead",
  outRoom: "outRoom",
  joinRoom: "jointRoom",
  updateReadMessage: "readMessage",
};

class WebSocket {
  activeUsers = [];
  io = new Server();

  constructor() {
    //Create socket connection
    this.io.listen(port_socket);
    this.io.on("connection", (client) => {
      console.log("User is connected, session id: " + client.id);

      client.on("login", (token) => {
        console.log("Login with token: " + token);
        try {
          // const { id } = parseTokenToObject(token);
          const id = "1";
          if (id) {
            client.join(id);
            this.addUserToActive({ sessionId: client.id, userId: id });
          }
        } catch (error) {
          console.error("Cannot found token: " + token);
          console.error("Error: ", error);
        }
      });

      client.on("join-room", (token) => {
        console.log("User join room with token: ", token);
        try {
          const { id } = parseTokenToObject(token);
          if (id) {
            // Send message to user
            client.join(id);
          } else {
            notifySocketSingleton.LoginRequest(client);
          }
        } catch (error) {
          console.error("Cannot found token: " + token);
          console.error("Error: ", error);
        }
      });

      client.on("online", (token) => {
        console.log("Online with token: " + token);
        try {
          const { id } = parseTokenToObject(token);
          if (id) {
            client.join(id);
            this.addUserToActive({ sessionId: client.id, userId: id });

            // Load missing message
          } else {
            notifySocketSingleton.LoginRequest(client);
          }
        } catch (error) {
          console.error("Cannot found token: " + token);
          console.error("Error: ", error);
        }
      });

      client.on("readMessage", (messageId, userId) => {
        UserRoomModel.SetReadMessage(messageId, userId)
          .then((room) => {
            if (room) {
              notifySocketSingleton.UpdateReadMessage(
                userId,
                messageId,
                room.id
              );
            }
          })
          .catch((error) => {});
      });

      client.on("logout", (token) => {
        console.log("User is logout, session id: " + client.id);
        const sessionId = client.id;
        this.removeUserFromActive(sessionId);
      });

      // Define when user is disconnect with server
      client.on("disconnect", () => {
        console.log("User is disconnected, session id: " + client.id);
        const sessionId = client.id;
        this.removeUserFromActive(sessionId);
      });
    });
  }

  /**
   *
   * @param {String} roomId
   * @returns
   */
  async emitToRoom(roomId, nameEvent, ...args) {
    console.log("Socket emit event: " + nameEvent);
    console.log("args:", args);
    const joinersId = await getUsersIdOfRoom(roomId);
    return joinersId.forEach((userId) =>
      this.io.to(userId).emit(nameEvent, args)
    );
  }

  addUserToActive(value) {
    if (value && !this.activeUsers.some((i) => i.userId === value.userId)) {
      this.activeUsers.push(value);
      console.log("new active user: " + JSON.stringify(value));
    }
  }

  removeUserFromActive(sessionId) {
    if (sessionId) {
      let userId = this.activeUsers.find(
        (i) => i.sessionId === sessionId
      )?.userId;
      if (userId) {
        this.activeUsers = this.activeUsers.filter(
          (i) => i.sessionId !== sessionId
        );
        console.log("user is remove from active, id: " + userId);
      }
    }
  }

  /**
   * Get active users
   * @returns {string[]} list user ID
   */
  getActiveUsers() {
    return this.activeUsers.map((i) => i.userId);
  }
}

class NotifySocket {
  /**
   *
   * @param {WebSocket} websocket
   */
  constructor(websocket) {
    /** @type {WebSocket} */
    this.websocket = websocket;
  }

  LoginRequest(client) {
    console.log("Request login, user session: ", client.id);
    client.emit("request-login");
  }

  UpdateReadMessage(userId, messageId, roomId) {
    console.log("Update read message");
    this.websocket.emitToRoom(roomId, SocketEvent.updateReadMessage, {
      userId: userId,
      messageId: messageId,
      roomId: roomId,
    });
  }

  MessageSent(roomId, messages) {
    console.log("Send message to room: " + roomId, messages);
    this.websocket.emitToRoom(roomId, SocketEvent.messageSent, messages);
  }

  RoomUpdate(roomIds) {
    RoomModel.getRoomsById(roomIds).then((rooms) => {
      rooms.forEach((room) => {
        this.websocket.emitToRoom(room.id, SocketEvent.roomUpdate, room);
      });
    });
  }

  ReadMessage(roomId, userId, messageId) {
    this.websocket.emitToRoom(
      roomId,
      SocketEvent.messageRead,
      userId,
      messageId
    );
  }

  OutRoom(roomId, usersId) {
    this.websocket.emitToRoom(roomId, SocketEvent.outRoom, usersId);
  }

  JoinRoom(roomId, usersId) {
    this.websocket.emitToRoom(roomId, SocketEvent.joinRoom, usersId);
  }
}

const webSocketSingleton = new WebSocket();
const notifySocketSingleton = new NotifySocket(webSocketSingleton);

export {
  webSocketSingleton as MyWebSocket,
  notifySocketSingleton as MyNotifySocket,
};
