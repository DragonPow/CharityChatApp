import Server from 'socket.io'
import http from "http";
import UserModel from "../models/user.js";
import config from "../config/index.js";
import { parseTokenToObject } from "../utils/middleware/token_service.js";

const port_socket = config.server.port_socket;

async function getRoom(roomId) {
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
        console.log('Login with token: ' + token);
        try {
          const { id } = parseTokenToObject(token);
          if (id) {
            client.join(id);
            this.addUserToActive({ sessionId: client.id, userId: id });
          }
        } catch (error) {
          console.error('Cannot found token: ' + token);
          console.error('Error: ', error);
        }
      });

      client.on('online', (token) => {
        console.log('Online with token: ' + token);
        try {
          const { id } = parseTokenToObject(token);
          if (id) {
            client.join(id);
            this.addUserToActive({ sessionId: client.id, userId: id });
          }
        } catch (error) {
          console.error('Cannot found token: ' + token);
          console.error('Error: ', error);
        }
      });
  
      client.on("logout", (token) => {
        console.log('User is logout, session id: ' + client.id);
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

  addUserToActive(value) {
    if (value && !this.activeUsers.some((i) => i.userId === value.userId)) {
      this.activeUsers.push(value);
      console.log('new active user: ' + JSON.stringify(value))
    }
  }

  removeUserFromActive(sessionId) {
    if (sessionId) {
      let userId = this.activeUsers.find((i) => i.sessionId === sessionId)?.userId;
      if (userId) {
        this.activeUsers = this.activeUsers.filter((i) => i.sessionId !== sessionId);
        console.log('user is remove from active, id: ' + userId);
      }
    }
  }

  /**
   * Get active users
   * @returns {string[]} list user ID
   */
  getActiveUsers() {
    return this.activeUsers.map(i=>i.userId);
  }
}


class NotifySocket {
  constructor(io) {
    this.io = io;
  }

  MessageSent(roomId, message) {
    console.log(roomId, message);
    this.io.to(getRoom(roomId)).emit(SocketEvent.messageSent, message);
  }

  RoomUpdate(room) {
    this.io.to(getRoom(room.id)).emit(SocketEvent.roomUpdate, room);
  }

  ReadMessage(roomId, userId, messageId) {
    this.io.to(getRoom(roomId)).emit(SocketEvent.messageRead, userId, messageId);
  }

  OutRoom(roomId, usersId) {
    this.io.to(getRoom(roomId)).emit(SocketEvent.outRoom, usersId);
  }

  JoinRoom(roomId, usersId) {
    this.io.to(getRoom(roomId)).emit(SocketEvent.joinRoom, usersId);
  }
}


const webSocketSingleton = new WebSocket();
const notifySocketSingleton = new NotifySocket(webSocketSingleton.io);


export {webSocketSingleton as MyWebSocket, notifySocketSingleton as MyNotifySocket};