import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";
import Room from "./room.js";

const UserRoom = sequelize.define("UserRoom", {});

UserRoom.prototype.getRoomsIdByPaging = async (startIndex, number, userId) => {
    const rooms = await UserRoom.findAll({
        where: {},
        attributes: ["roomId"],
        limit: number,
        offset: startIndex,
    });
    return rooms.map((i) => i.roomId);
};

UserRoom.prototype.createRoom = async (roomInfo, listUsersId) => {
    const room = await Room.createRoom(roomInfo);
    await UserRoom.bulkCreate(
        listUsersId.map((userId) => {
            return { roomId: room.id, userId };
        })
    );

    return room;
};

UserRoom.prototype.deleteByRoomId = async (roomId) => {
    try {
        const rs = await UserRoom.destroy({
            where: {
                roomId: roomId,
            },
        });
        //TODO: Should or Not delete messages in this room here?
        return rs;
    } catch (error) {
        throw error;
    }
};

export default UserRoom;
