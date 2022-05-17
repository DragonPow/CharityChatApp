import Room from "./room.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";
import User from "./user.js";
import Friend from "./friend.js";

//Room contain many message
Room.hasMany(Message, {
    as: "messageContainer",
    foreignKey: { name: "roomId", allowNull: false },
});
// Message.belongsTo(Room, { as: "messageContainer", foreignKey: "roomId" });

//Last message in room
Room.belongsTo(Message, {
    as: "lastMessage",
    foreignKey: "lastMessageId",
    constraints: false, //set constraints = false to avoid cyclic with "messageContainer"
});
// Message.hasOne(Room, { as: "lastMessage", foreignKey: {name: "lastMessageId", allowNull: true}, });

//Message is send by user
Message.belongsTo(User, {
    as: "sender",
    foreignKey: { name: "senderId", allowNull: false },
});
// User.hasOne(Message, {
//     as: "sender",
//     foreignKey: "senderId",
// });

//The last message the user read in room
UserRoom.belongsTo(Message, { as: "lastReadMessage" });
// Message.hasOne(UserRoom, {as: "lastReadMessage"});

//Room have users, and the users have rooms
User.belongsToMany(Room, { as:'container', through: UserRoom, foreignKey: "userId" });
Room.belongsToMany(User, { as:'joiners', through: UserRoom, foreignKey: "roomId" });

//User have friends
User.belongsToMany(User, { as: "id1", through: Friend, foreignKey: "id1" });
User.belongsToMany(User, { as: "id2", through: Friend, foreignKey: "id2" });

export {
    Room,
    Message,
    UserRoom,
    User,
    Friend,
};