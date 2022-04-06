import { DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import User from "./user.js";

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
 * @returns new message
 */
Message.statics.sendMessage = async (
    content,
    typeContent,
    roomId,
    senderId
) => {
    const message = await Message.build({
        content,
        typeContent,
        senderId,
        roomId,
    });
    return message;
};

Message.statics.sendImage = async (content, typeContent, roomId, senderId) => {
    const message = await Message.build({
        content,
        typeContent: "image",
        senderId,
        roomId,
    });
    //TODO: upload image to db
    return message;
};

Message.statics.sendFile = async (content, typeContent, roomId, senderId) => {
    const message = await Message.build({
        content,
        typeContent: "file",
        senderId,
        roomId,
    });
    //TODO: upload file to db
    return message;
};

Message.statics.getRoomMessages = async (roomId, startIndex, number) => {
    const messages = await Message.findAll({
        where: { roomId: roomId },
        order: [["timeCreate", "DESC"]],
        include: {
            model: User, //Get sender data
            as: "sender",
            attribute: [
                ["id", "senderId"],
                ["name", "senderName"],
                ["imageUri", "senderImageUri"],
            ],
        },
        limit: number,
        offset: startIndex,
    });
    return messages;
};

Message.statics.getLastMessageInRoom = async (roomId) => {
    try {
        //? Should get message and sender data?
        const message = await Message.findOne({
            where: { roomId: roomId },
            order: [["timeCreate", "DESC"]],
            include: {
                model: User, //Get sender data
                as: "sender",
                attribute: [
                    ["id", "senderId"],
                    ["name", "senderName"],
                    ["imageUri", "senderImageUri"],
                ],
            },
        });
        return message;
    } catch (error) {
        throw error;
    }
};

Message.statics.getMessagesByContent = async (
    textMatch,
    roomId,
    startIndex,
    number
) => {
    //Just find text message
    const { count, rows: messages } = await Message.findAndCountAll({
        where: {
            roomId: roomId,
            typeContent: "text",
            content: {
                [Op.substring]: textMatch,
            },
        },
        order: [["timeCreate", "DESC"]],
        include: {
            model: User, //Get sender data
            as: "sender",
            attribute: [
                ["id", "senderId"],
                ["name", "senderName"],
                ["imageUri", "senderImageUri"],
            ],
        },
        limit: number,
        offset: startIndex,
    });
    return { messages, count };
};

Message.statics.deleteMessageInRoom = async (roomId) => {
    const rs = await Message.destroy({
        where: {
            roomId: roomId,
        },
    });
    return rs;
};

Message.delete = async (messageId, TypeMessage) => {};

Message.statics.getImages = async (startIndex, number, roomId) => {
    const messages = await Message.findAll({
        where: { roomId: roomId, typeContent: "image" },
        order: [["timeCreate", "DESC"]],
        // include: {
        //     model: User, //Get sender data
        //     as: "sender",
        //     attribute: [
        //         ["id", "senderId"],
        //         ["name", "senderName"],
        //         ["imageUri", "senderImageUri"],
        //     ],
        // },
        limit: number,
        offset: startIndex,
    });
    return messages;
};

Message.statics.getFiles = async (startIndex, number, roomId) => {
    const messages = await Message.findAll({
        where: { roomId: roomId, typeContent: "file" },
        order: [["timeCreate", "DESC"]],
        // include: {
        //     model: User, //Get sender data
        //     as: "sender",
        //     attribute: [
        //         ["id", "senderId"],
        //         ["name", "senderName"],
        //         ["imageUri", "senderImageUri"],
        //     ],
        // },
        limit: number,
        offset: startIndex,
    });
    return messages;
};

export default Message;
export { TypeMessage };
