import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";
import User from "./user.js";

const TypeMessage = DataTypes.ENUM("text", "image", "file", "video", "system");

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
        type: TypeMessage,
        allowNull: false,
        defaultValue: "text",
    },
});

Message.hasOne(User, {
    as: "sender",
    foreignKey: "senderId",
});

//Method
/**
 * When message is send to database
 * @param {String} content content of message
 * @param {TypeMessage} typeContent type of message
 * @param {String} roomId 
 * @param {String} sender 
 */
Message.create = async (content, typeContent, roomId, senderId) => {
    const message = this.create({ content, typeContent, senderId });
};

export default Message;
export { TypeMessage };
