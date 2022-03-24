import { DataTypes } from "sequelize/types";
import sequelize from "../config/mysql";
import Message from "./message";
import User from "./user";

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

Room.hasMany(Message, { as: "messageContainer" });
Room.hasOne(Message, {as: "lastMessage"});

export default Room;
