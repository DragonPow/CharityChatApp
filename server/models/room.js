import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import User from "./user.js";

const Room = sequelize.define("Room", {
    id: {
        type: DataTypes.STRING,
        primaryKey: true,
    },
    timeCreate: {
        type: DataTypes.DATE,
        allowNull: false,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
});

Room.hasMany(Message, { as: "messageContainer", foreignKey: "roomId" });
Room.hasOne(Message, { as: "lastMessage", foreignKey: "lastMessageId" });

export default Room;
