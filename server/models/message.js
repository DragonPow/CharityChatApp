import { DataTypes } from "sequelize/types";
import sequelize from "../config/mysql";
import User from "./user";

const Message = sequelize.define("Message", {
    id: {
        type: DataTypes.STRING,
        primaryKey: true,
    },
    createTime: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
    content: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "",
    },
    typeContent: {
        type: DataTypes.ENUM("text", "image", "file", "video", "system"),
        allowNull: false,
        defaultValue: "text",
    },
});

Message.hasOne(User,{
    as: 'sender',
})

export default Message;