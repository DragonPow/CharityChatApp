import { DataTypes, Model, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import User from "./user.js";

const TypeMessage = DataTypes.ENUM("text", "image", "file", "video", "system");

class Message extends Model {
  /**
   * When message is send to database
   * @param {String} content content of message
   * @param {TypeMessage} typeContent type of message
   * @param {String} roomId
   * @param {String} sender
   * @returns new message
   */
  static async createMessage(value, roomId, senderId) {
    const typeContent = Array.isArray(value) ? 'content' : 'file';
    const content = Array.isArray(value) ? value.join(', ') : value; // if is list file, join with ','

    const message = await Message.create({
      content,
      typeContent,
      senderId,
      roomId,
    });
    return message;
  }

  static async sendImage(content, typeContent, roomId, senderId) {
    const message = await Message.create({
      content,
      typeContent: "image",
      senderId,
      roomId,
    });
    //TODO: upload image to db
    return message;
  }

  static async sendFile(content, typeContent, roomId, senderId) {
    const message = await Message.create({
      content,
      typeContent: "file",
      senderId,
      roomId,
    });
    //TODO: upload file to db
    return message;
  }

  static async getMessagesByRoomId(
    roomId,
    startIndex,
    number,
    orderby,
    orderdirection,
    searchby,
    searchvalue
  ) {
    var searchOrderby;
    var searchTypeBy;

    switch (orderby) {
      case "createTime":
        searchOrderby = ["createTime"];
        break;
      default:
        break;
    }

    switch (searchby) {
      case "all":
        searchTypeBy = TypeMessage.values;
        break;
      case "text":
        searchTypeBy = ["text"];
        break;
      case "media":
        searchTypeBy = ["image", "video"];
        break;
      case "file":
        searchTypeBy = ["file"];
        break;
      default:
        break;
    }

    const messages = await Message.findAll({
      where: {
        roomId: roomId,
        content: {
          [Op.substring]: searchvalue,
        },
        typeContent: { [Op.in]: searchTypeBy },
      },
      attributes: {
        exclude: ['roomId','senderId']
      },
      include: {
        model: User, //Get sender data
        as: "sender",
        attributes: {
          exclude: ['numberEvent','numberFollower']
        }
      },
      limit: number,
      offset: startIndex,
      order: [[...searchOrderby, orderdirection]],
    });
    return messages;
  }

  static async getLastMessageInRoom(roomId) {
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
  }

  static async getMessagesByContent(textMatch, roomId, startIndex, number) {
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
  }

  static async deleteMessageInRoom(roomId) {
    const rs = await Message.destroy({
      where: {
        roomId: roomId,
      },
    });
    return rs;
  }

  static async deleteMessageById(messageId, TypeMessage) {
    // TODO: delete and remove some relation object (file, image)
  }

  static async getImages(startIndex, number, roomId) {
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
  }

  static async getFiles(startIndex, number, roomId) {
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
  }
}

Message.init(
  {
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
  },
  {
    sequelize,
    modelName: "Message",
  }
);

export default Message;
export { TypeMessage };
