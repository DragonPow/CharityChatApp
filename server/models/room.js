import { literal, col, DataTypes, Op, Model } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";
import UserRoom from "./user_room.js";
import User from "./user.js";
import config from "../config/index.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";
import { deleteFiles } from "../utils/file/file_service.js";

const TypeRoom = DataTypes.ENUM(["group", "private"]);
class Room extends Model {
  static async checkExists(roomIds) {
    const rs = await Room.count({
      where: {
        id: {
          [Op.in]: roomIds,
        },
      },
    });
    return rs === roomIds.length;
  }
  static async getRoomsByPaging(
    startIndex,
    number,
    userId,
    orderby,
    orderdirection,
    searchby,
    searchvalue,
    searchtype
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

    let searchTypeRoom;
    switch (searchtype) {
      case "all":
        searchTypeRoom = ["private", "group"];
        break;
      case "private":
        searchTypeRoom = ["private"];
        break;
      case "group":
        searchTypeRoom = ["group"];
        break;
      default:
        break;
    }

    const userRooms = await Room.findAll({
      where: {
        name: {
          [Op.substring]: searchvalue,
        },
        typeRoom: {
          [Op.in]: searchTypeRoom,
        },
      },
      include: [
        {
          model: Message,
          as: "lastMessage",
          // attributes: [["createTime", "lastMessageTime"]],
          attributes: { exclude: ["roomId"] },
          include: {
            model: User,
            as: "sender",
            attributes: ["id", "name", "email", "imageUri", "gender"],
          },
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
   * @param {string[]} roomsId
   * @returns {Promise<Room[]>} rooms with last message include
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
          include: [
            {
              model: User,
              as: "sender",
              attributes: ["id", "name", "imageUri"],
            },
          ],
        },
        {
          model: User,
          attributes: [
            "id",
            "name",
            "email",
            "phone",
            "imageUri",
            "timeCreate",
          ],
          as: "joiners",
          through: {
            attributes: ["nameAlias"],
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
      .filter(
        (room) => room.joiners.length === 2 && room.typeRoom === "private"
      )
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
   * @param {'group'|'private'} typeRoom type of the room
   */
  static async createRoom(
    name,
    avatarUri = null,
    joinersId,
    typeRoom = undefined
  ) {
    const transaction = await sequelize.transaction();
    if (!typeRoom) {
      typeRoom = joinersId.length === 2 ? "private" : "group";
    }
    try {
      const room = await Room.create(
        {
          name: name,
          avatarId: avatarUri,
          typeRoom: typeRoom,
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
        room = await Room.createRoom(
          "Room no name",
          null,
          joinersId,
          "private"
        );
      }
    } else {
      // Create new room for group user
      room = await Room.createRoom("Group no name", null, joinersId, "group");
    }
    return room;
  }

  /**
   *
   * @param {string[]} roomIds
   * @returns
   */
  static async deleteByIds(roomIds) {
    // Auto delete all message in room
    const rs = await Room.destroy({
      where: {
        id: {
          [Op.in]: roomIds,
        },
      },
    });
    return rs;
  }

  /**
   * Update information of the room
   * @param {string} roomId
   * @param {string} roomName
   * @param {string} imageUrl
   * @param {'private'|'group'} typeRoom
   * @returns
   */
  static async updateRoom(
    roomId,
    roomName,
    imageUrl,
    typeRoom = undefined,
    aliasJoiners
  ) {
    const transaction = await sequelize.transaction();
    const room = await Room.findByPk(roomId, {
      // attributes: ["id", "name", "avatarId"],
    });
    const previousImageUrl = room.avatarId;

    roomName && room.set("name", roomName);
    imageUrl && room.set("avatarId", imageUrl);
    typeRoom && room.set("typeRoom", typeRoom);

    aliasJoiners.forEach((joiner) => {
      console.log('Change name alias', joiner);
      UserRoom.update(
        { nameAlias: joiner.nameAlias },
        { where: { roomId: roomId, userId: joiner.id } }
      );
    });

    return room.save().then((rs) => {
      if (imageUrl) {
        deleteFiles([previousImageUrl]).catch((error) =>
          console.log(
            `Delete image of room ${room.id} fail, name: ${previousImageUrl}`,
            error
          )
        );
      }
      return rs;
    });
  }

  static async resetLastMessage(roomId) {
    // Find last message
    const lastMessages = await Message.getMessagesByRoomId(
      roomId,
      0,
      1,
      "createTime",
      "desc",
      "all",
      ""
    );

    const newLastMessageId = lastMessages.length ? lastMessages[0].id : null;

    const { affectedCount } = await Room.update(
      {
        lastMessageId: newLastMessageId,
      },
      {
        where: {
          id: roomId,
        },
      }
    );

    console.log(`New last message of room ${roomId} is: ${newLastMessageId}`);
    return affectedCount === 1;
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
      await room
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
    typeRoom: {
      type: TypeRoom,
      allowNull: false,
      defaultValue: "private",
    },
  },
  { sequelize, modelName: "Room" }
);

export default Room;
