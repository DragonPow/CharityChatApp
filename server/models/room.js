import { literal, col, DataTypes, Op, Model } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";
import User from "./user.js";
import config from "../config/index.js";

class Room extends Model {
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
    return rooms;
  }

  static async createRoom(creatorId, name, avatarUri, joinersId) {
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

  static async deleteById(roomId) {
    const rs = await Room.destroy({
      where: {
        id: roomId,
      },
    });
    //TODO: Should or Not delete messages in this room here?
    return rs;
  }

  static async updateRoom(room) {
    const rs = Room.update(room, { where: { id: room.id } });
    return rs;
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
