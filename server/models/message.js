import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";
import User from "./user.js";
import { v4 as uuidv4 } from 'uuid';

const TypeMessage = DataTypes.ENUM("text", "image", "file", "video", "system");

const Message = sequelize.define("Message", {
    id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
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


//Method
/**
 * When message is send to database
 * @param {String} content content of message
 * @param {TypeMessage} typeContent type of message
 * @param {String} roomId
 * @param {String} sender
 */
Message.send = async (content, typeContent, roomId, senderId) => {
    try {
        //? how to check if is true senderId?
        const message = await Message.build({
            content,
            typeContent,
            senderId,
            roomId,
        });
        return message;
    } catch (error) {
        throw error;
    }
};

Message.getRoomMessages = async (roomId, startIndex, number) => {
    try {
        //? Should get message and sender data?
        const messages = await Message.findAll({
            where: { roomId: roomId },
            limit: number,
            offset: startIndex,
        });
        return messages;
    } catch (error) {
        throw error;
    }
};

Message.getMessagesByContent = async (textMatch, roomId, startIndex, number) => {
    try {
        //? Should get message and sender data?
        const messages = await Message.findAll({
            where: { roomId: roomId },
            limit: number,
            offset: startIndex,
        });
        return messages;
    } catch (error) {
        throw error;
    }
};

Message.delete = async (messageId, TypeMessage) => {};

Message.getImages = async (startIndex, number, roomId) => {};

Message.getFiles = async (startIndex, number, roomId) => {};

export default Message;
export { TypeMessage };
