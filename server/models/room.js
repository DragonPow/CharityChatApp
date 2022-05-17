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
  const userRooms = await Room.findAll({
    include: [
      {
        model: Message,
        as: "lastMessage",
        // attributes: [["createTime", "lastMessageTime"]],
        attributes: {exclude: ['roomId']}
      },
      {
        model: User,
        as: "joiners",
        where: {
          id: userId,
        },
        attributes: [],
      },
    ],
    attributes: { exclude: ["lastMessageId"] },
    offset: startIndex,
    limit: number,
    order: [['lastMessage','createTime','DESC']]
    // order: [[{ model: Message, as: "lastMessage" }, "createTime", "DESC"]], //another way
  });
  return userRooms.map((i) => i.dataValues);
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
        [Op.substring]: ' ',
      },
    },
    include: [
      {
        model: User,
        as: 'joiners',
        // attributes: [["userId", "userName"]],
        through: {
          attributes: []
        }
      },
      // UserRoom,
      {
        model: Message,
        as: "lastMessage",
        attributes: { exclude: ['roomId']}
      },
    ],
    order: [['lastMessage', 'content','DESC']],
    offset: startIndex,
    limit: number,
  });
  return rooms;
};

Room.createRoom = async (name, avatar, joinersId) => {
  const rs = await Room.create({
    name: name,
    
  });
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
