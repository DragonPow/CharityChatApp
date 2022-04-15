import room from "../controllers/room.js";
import user from "../controllers/user.js";

class WebSocket {
    activeUsers = [];
    connection(client) {
        console.log("User is connected");

        //Define when user is disconnect with server
        client.on("disconnect", () => {
            console.log("User is disconnected");
            this.activeUsers = this.activeUsers.filter(
                (user) => user.socketId !== client.id
            );
        });

        //Register user to activeUsers
        client.on("identity", (userId) => {
            this.user.push({
                socketId: client.id,
                userId: userId,
            });
        });

        //Register to room
        client.on("register", (room) => {
            client.join(room);
        });

        //UnRegister to room
        client.on("unRegister", (room) => {
            client.leave(room);
        });

        //Fired when message is send
        client.on("messageSent", (room, message) => {
            socket.to(room).emit(message);
        });
    }
}

export default new WebSocket();
