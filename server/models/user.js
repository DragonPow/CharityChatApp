import { DataTypes, Model, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { v4 as uuidv4 } from "uuid";
import Friend from "./friend.js";
import Room from "./room.js";
import UserRoom from "./user_room.js";
import {GetDataFromSequelizeObject} from '../config/helper.js';

class User extends Model {
  static _getBasicAttributes = ['id','name','email','phone','imageUri','timeCreate'];
  static _getAllAttributes = undefined;
  /**
   * Get user online of logging activity
   * @param {number} startIndex
   * @param {number} number number user need get
   * @param {string} mainUserId userId to find friends
   * @returns List user is friend and in online of mainUserId
   */
  static async getActiveUsersByPage(startIndex, number, mainUserId) {
    //TODO: Open websocket to check current online user of server of specific user
    const users = await User.findAll({
      where: {
        id: mainUserId,
      },
      include: {
        model: Friend,
      },
      limit: number,
      offset: startIndex,
    });

    return users;
  }

  /**
   * Get user in database
   * @param {number} startIndex
   * @param {number} number number user need get
   * @param {string} mainUserId userId to find friends
   * @returns List user is friend and in online of mainUserId
   */
   static async getUserByPaging(orderby, orderdirection, startIndex, number, searchby, searchvalue, ) {
    let searchOrderby;
    switch (orderby) {
      case "name":
        searchOrderby = ["name"];
        break;
      case "timeCreate":
        searchOrderby = ["timeCreate"];
        break;
      default:
        break;
    }

    const users = await User.findAll({
      where: {
        name: {
          [Op.substring]: searchvalue,
        },
      },
      // include: {
      //   model: Friend,
      // },
      attributes: { exclude: ["lastMessageId"] },
      offset: startIndex,
      limit: number,
      order: [[...searchOrderby, orderdirection]],
    });

    return GetDataFromSequelizeObject(users);
  }

  static async checkExists(usersId) {
    const userNumber = await User.count({
      where: {
        id: {
          [Op.in]: usersId
        }
      },
    });

    return userNumber === usersId.length;
  }

  static async getUserById(userId) {
    const user = await User.findByPk(userId);
    //Don't show password
    delete user.dataValues.password;

    return user;
  }

  /**
   * Get information of user in a room
   * @param {string[]} roomsId must be array string
   * @returns {User[]} Full information of joiner in room
   */
  static async getJoinersInRoom(roomsId) {
    const list = await User.findAll({
      attributes: User._getBasicAttributes,
      include: [
        {
          model: Room,
          as: "container",
          attributes: ['id'],
          through: {
            attributes: [],
            where: {
              roomId: { [Op.in]: roomsId },
            },
          },
        },
      ],
    });
    return GetDataFromSequelizeObject(list);
  }

  static async findByUserNameAndPassword(username, password) {
    const user = await User.findOne({
      where: {
        username: username,
        password: password,
      }
    });

    return GetDataFromSequelizeObject(user);
  }
}

User.init(
  {
    id: {
      type: DataTypes.UUID,
      primaryKey: true,
      defaultValue: DataTypes.UUIDV4,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    phone: {
      type: DataTypes.CHAR(12),
      allowNull: true,
    },
    timeCreate: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    imageUri: {
      type: DataTypes.STRING({ binary: true }),
      allowNull: true,
    },
    birthday: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    gender: {
      type: DataTypes.TINYINT,
      allowNull: false,
      defaultValue: 0,
      comment: "0 if not define, 1 is male, 2 is female",
    },
    address: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    //Not use usually
    numberEvent: {
      type: DataTypes.SMALLINT,
      allowNull: false,
      defaultValue: 0,
    },
    numberFollower: {
      type: DataTypes.SMALLINT,
      allowNull: false,
      defaultValue: 0,
    },
  },
  {
    sequelize,
    modelName: "User",
    defaultScope: {
      attributes: {exclude: ['password']}
    }
  }
);

export default User;
