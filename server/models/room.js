import { DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";

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
    }
});

//Method
Room.prototype.getRoomsByPaging = async (startIndex, number, userId) => {
    try {
        const rooms = await Room.findAll({
            where: {},
            include: {
                model: Message,
                as: "lastMessage",
            },
            limit: number,
            offset: startIndex,
        });
        return rooms;
    } catch (error) {
        throw error;
    }
};

/**
 * Get rooms by ids
 * @param {Array} roomsId
 * @returns rooms with last message include
 */
Room.prototype.getRoomsById = async (roomsId) => {
    const rooms = await Room.findAll({
        where: {
            id: {
                [Op.in]: roomsId,
            },
        },
        include: {
            model: Message,
            as: "lastMessage",
        },
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
Room.prototype.getRoomsByName = async (textMatch, startIndex, number, userId) => {
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

Room.prototype.createRoom = async (room) => {
    const rs = await Room.create(room);
    return rs;
};

Room.prototype.deleteById = async (roomId) => {
    const rs = await Room.destroy({
        where: {
            id: roomId,
        },
    });
    //TODO: Should or Not delete messages in this room here?
    return rs;
};

Room.prototype.updateRoom = async (room) => {
    const rs = Room.update(room, { where: { id: room.id } });
    return rs;
};

Room.prototype.updateAvatarRoom = async (roomId, avatar) => {
    // TODO: remove current avatar of room

    // TODO: add new avatar

    return {success: true, id: ""};
}

export default Room;
