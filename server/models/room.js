import { literal, col, DataTypes, Op, Model } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";
import User from "./user.js";
import config from "../config/index.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";

class Room extends Model {
  static async checkExists(roomId) {
    const rs = await Room.findByPk(roomId, { attributes: ["id"] });
    return rs !== null;
  }
  static async getRoomsByPaging(
    startIndex,
    number,
    userId,
    orderby,
    orderdirection,
    searchby,
    searchvalue
  ) {
    let searchOrderby;
    switch (orderby) {
      case "lastMessage":
        searchOrderby = ["lastMessage", "createTime"];
        break;
      case "name":
        searchOrderby = ["name"];
        break;
      case "timeCreate":
        searchOrderby = ["timeCreate"];
        break;
      default:
        break;
    }
    const userRooms = await Room.findAll({
      where: {
        name: {
          [Op.substring]: searchvalue,
        },
      },
      include: [
        {
          model: Message,
          as: "lastMessage",
          // attributes: [["createTime", "lastMessageTime"]],
          attributes: { exclude: ["roomId"] },
        },
        {
          model: User,
          as: "joiners",
          where: {
            id: userId,
          },
          through: {
            attributes: [],
          },
          attributes: [],
        },
      ],
      attributes: { exclude: ["lastMessageId"] },
      offset: startIndex,
      limit: number,
      order: [[...searchOrderby, orderdirection]],
      // order: [[{ model: Message, as: "lastMessage" }, "createTime", "DESC"]], //another way
    });
    return userRooms.map((i) => i.dataValues);
  }

  /**
   * Get rooms by ids
   * @param {Array} roomsId
   * @returns rooms with last message include
   */
  static async getRoomsById(roomsId) {
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

    return GetDataFromSequelizeObject(rooms);
  }

  /**
   * Find room by 2 user id, if not found, return null
   * @param {string} userId1
   * @param {string} userId2
   * @returns {Room | null} room or null if not exists
   */
  static async findRoomOf2UserId(userId1, userId2) {
    const roomsBeforeCheck = await Room.findAll({
      include: [
        {
          model: User,
          attributes: ["id"],
          as: "joiners",
          where: {
            id: {
              [Op.in]: [userId1, userId2],
            },
          },
          through: {
            attributes: [],
          },
        },
      ],
    });

    const roomsAfterCheck = roomsBeforeCheck
      .filter((room) => room.joiners.length === 2)
      .map((room) => room.id);

    const rooms = await Room.findAll({
      where: {
        id: {
          [Op.in]: roomsAfterCheck,
        },
      },
      include: [
        {
          model: Message,
          as: "lastMessage",
        },
        {
          model: User,
          as: "joiners",
          through: {
            attributes: [],
          },
        },
      ],
    });

    return rooms?.length > 0
      ? rooms.find((room) => room.joiners.length === 2) ?? null
      : null;
  }

  /**
   * Create room
   * @param {string} name name of the room
   * @param {string} avatarUri avatar of the room, directory to server location, it can be null
   * @param {string[]} joinersId list joiners of the room
   */
  static async createRoom(name, avatarUri = null, joinersId) {
    const transaction = await sequelize.transaction();
    try {
      const room = await Room.create(
        {
          name: name,
          avatarId: avatarUri,
        },
        {
          transaction: transaction,
        }
      );

      await UserRoom.bulkCreate(
        [
          ...joinersId.map((userId) => {
            return {
              lastReadMessageId: null,
              userId: userId,
              roomId: room.id,
            };
          }),
        ],
        { transaction: transaction }
      );

      await transaction.commit();

      return room;
    } catch (error) {
      await transaction.rollback();
      if (error.name === "SequelizeForeignKeyConstraintError") {
        throw new Error("The user in list joiner not exists");
      }
      throw error;
    }
  }

  /**
   * find or create room if not found room containt user
   * @param {string[]} joinersId joiners of the room, at least 2
   * @returns {Room} the new or exists room
   * @throws {Error} 'Joiners of the room at least 2'
   */
  static async findOrCreateRoom(joinersId) {
    let room;

    if (joinersId.length < 2) {
      throw new Error("Joiners of the room at least 2");
    }

    // Send message for one people, check room exists
    if (joinersId.length === 2) {
      // Exists room chat of sender and receiver
      room = await Room.findRoomOf2UserId(joinersId[0], joinersId[1]);

      if (!room) {
        // If not exists, create new room
        room = await Room.createRoom("Room no name", null, joinersId);
      }
    } else {
      // Create new room for group user
      room = await Room.createRoom("Group no name", null, joinersId);
    }
    return room;
  }

  static async deleteById(roomId) {
    const rs = await Room.destroy({
      where: {
        id: roomId,
      },
    });
    //TODO: Should or Not delete messages in this room here?
    return rs;
  }

  static async updateRoom(roomId, roomName, imageUrl) {
    const room = await Room.findByPk(roomId, {
      attributes: ["id", "name", "avatarId"],
    });

    roomName && room.set("name", roomName);
    imageUrl && room.set("avatarId", imageUrl);

    return room.save();
  }

  static async checkAndSetLastMessage(roomId, message) {
    const room = await Room.findByPk(roomId, {
      attributes: ["id"],
      include: [
        {
          model: Message,
          as: "lastMessage",
          attributes: ["id", "createTime"],
        },
      ],
    });

    if (!room.lastMessage || room.lastMessage.createTime < message.createTime) {
      room.set({
        lastMessageId: message.id,
      });
      const logResult = { roomId: room.id, messageId: message.id };
      room
        .save()
        .then((rs) => console.log("SET_LAST_MESSAGE_SUCCESS: ", logResult))
        .catch((error) =>
          console.log("SET_LAST_MESSAGE_FAIL: ", { ...logResult, error: error })
        );
    }
  }
}

Room.init(
  {
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
  },
  { sequelize, modelName: "Room" }
);

export default Room;
