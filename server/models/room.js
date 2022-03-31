import { DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import User from "./user.js";
import { v4 as uuidv4 } from 'uuid';

const Room = sequelize.define("Room", {
    id: {
        type: DataTypes.UUID,
        primaryKey: true,
        defaultValue: DataTypes.UUIDV4,
    },
    timeCreate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
});


//Method
Room.getRooms = async (startIndex, number, userId) => {
    try {
        //TODO: Should get room and last message itself?
        const rooms = await Room.findAll({
            where: {},
            limit: number,
            offset: startIndex,
        });
        return rooms;
    } catch (error) {
        throw error;
    }
};

Room.getRoomsByName = async (textMatch, startIndex, number) => {
    try {
        //TODO: Should get room and lastmessage itself?
        //Order by nearest last message
        const rooms = await Room.findAll({
            where: {
                name: {
                    [Op.like]: textMatch,
                },
            },
            limit: number,
            offset: startIndex,
            order: [sequelize.fn("max", sequelize.col("lastMessageId"))],
        });
        return rooms;
    } catch (error) {
        throw error;
    }
};

Room.delete = async (roomId) => {
    try {
        const rowSuccess = await Room.destroy({
            where: {
                id: roomId,
            },
        });
        //TODO: Should or Not delete messages in this room here?
        return rowSuccess;
    } catch (error) {
        throw error;
    }
};

Room.update = async (room) => {
    try {
        const rs = Room.delete(room, {
            where: {
                id: room.id,
            },
        });
        return rs;
    } catch (error) {
        throw error;
    }
};

export default Room;
