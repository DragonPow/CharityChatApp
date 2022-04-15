import { literal, col, DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";
import User from "./user.js";

const Room = sequelize.define("Room", {
    id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
    },
    timeCreate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    avatarId: {
        type: DataTypes.STRING,
        allowNull: true,
    },
});

//Method
Room.getRoomsByPaging = async (startIndex, number, userId) => {
    try {
        const userRooms = await Room.findAll({
            include: [
                {
                    model: Message,
                    as: "lastMessage",
                    // attributes: [["createTime", "lastMessageTime"]],
                },
                {
                    model: User,
                    as: "container",
                    where: {
                        id: userId,
                    },
                    attributes: [],
                },
            ],
            attributes: { exclude: ['lastMessageId'] },
            offset: startIndex,
            limit: number,
            order: [
                [{ model: Message, as: "lastMessage" }, "createTime", "DESC"],
            ],
        });
        console.log("success");
        return userRooms.map((i) => i.dataValues);
    } catch (e) {
        console.log(e);
        throw e;
    }
};

/**
 * Get rooms by ids
 * @param {Array} roomsId
 * @returns rooms with last message include
 */
Room.getRoomsById = async (roomsId) => {
    const rooms = await Room.findAll({
        where: {
            id: {
                [Op.in]: roomsId,
            },
        },
        include: [
            {
                model: Message,
                as: "lastMessage",
            },
            {
                model: User,
                attributes: ["id"],
                as: "joiners",
                through: {
                    attributes: [],
                },
            },
        ],
    });
    return rooms;
};

/**
 * Get rooms by name and userId
 * @param {String} textMatch
 * @param {Number} startIndex
 * @param {Number} number
 * @param {String} userId
 * @returns room with last message
 */
Room.getRoomsByName = async (textMatch, startIndex, number, userId) => {
    //Order by nearest last message
    const rooms = await Room.findAll({
        where: {
            name: {
                [Op.substring]: textMatch,
            },
            userName: userId,
        },
        include: [
            {
                model: UserRoom,
                attributes: [["userId", "userName"]],
            },
            {
                model: Message,
                as: "lastMessage",
            },
        ],
        order: [sequelize.fn("max", sequelize.col("lastMessageId"))],
        limit: number,
        offset: startIndex,
    });
    return rooms;
};

Room.createRoom = async (room) => {
    const rs = await Room.create(room);
    return rs;
};

Room.deleteById = async (roomId) => {
    const rs = await Room.destroy({
        where: {
            id: roomId,
        },
    });
    //TODO: Should or Not delete messages in this room here?
    return rs;
};

Room.updateRoom = async (room) => {
    const rs = Room.update(room, { where: { id: room.id } });
    return rs;
};

Room.updateAvatarRoom = async (roomId, avatar) => {
    // TODO: remove current avatar of room

    // TODO: add new avatar

    return { success: true, id: "" };
};

export default Room;
