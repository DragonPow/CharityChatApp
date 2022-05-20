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
Message.sendMessage = async (
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

Message.sendImage = async (content, typeContent, roomId, senderId) => {
    const message = await Message.build({
        content,
        typeContent: "image",
        senderId,
        roomId,
    });
    //TODO: upload image to db
    return message;
};

Message.sendFile = async (content, typeContent, roomId, senderId) => {
    const message = await Message.build({
        content,
        typeContent: "file",
        senderId,
        roomId,
    });
    //TODO: upload file to db
    return message;
};

Message.getRoomMessages = async (roomId, startIndex, number) => {
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

Message.getLastMessageInRoom = async (roomId) => {
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

Message.getMessagesByContent = async (
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

Message.deleteMessageInRoom = async (roomId) => {
    const rs = await Message.destroy({
        where: {
            roomId: roomId,
        },
    });
    return rs;
};

Message.deleteMessageById = async (messageId, TypeMessage) => {
    // TODO: delete and remove some relation object (file, image)
};

Message.getImages = async (startIndex, number, roomId) => {
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

Message.getFiles = async (startIndex, number, roomId) => {
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
