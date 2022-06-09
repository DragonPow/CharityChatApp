import { DataTypes, Model, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";
import MessageModel from "./message.js";

class UserRoom extends Model {
  static async changeJoiners(roomId, addIds, removeIds) {
    const transaction = await sequelize.transaction();

    try {
      const added = (
        await UserRoom.bulkCreate(
          addIds.map((i) => {
            return { userId: i, roomId: roomId };
          }),
          { transaction: transaction }
        )
      ).length;

      const deleted = await UserRoom.destroy(
        {
          where: {
            roomId: roomId,
            userId: {
              [Op.in]: removeIds,
            },
          },
        },
        { transaction: transaction }
      );

      await transaction.commit();
      return added + deleted;
    } catch (error) {
      await transaction.rollback();
      throw error;
    }
  }

  /**
   * Check if user Id is the joiner of the room
   * @param {string} joinerId
   * @param {string} roomId
   * @returns
   */
  static async CheckIsJoinerOfRoom(joinerId, roomId) {
    const count = await UserRoom.count({
      where: {
        userId: joinerId,
        roomId: roomId,
      },
    });

    return count === 1;
  }

  static async SetReadMessage(messageId, userId) {
    const newMessage = await MessageModel.findByPk(messageId, {
      // attributes: ["roomId"],
    });

    if (!newMessage) throw Error("Cannot find message");

    const relation = await UserRoom.findOne({
      where: {
        roomId: newMessage.roomId,
        userId: userId,
      },
    });

    if (!relation) throw Error('Cannot find room');

    const oldMessage = await MessageModel.findByPk(relation.lastReadMessageId);

    if (!oldMessage || oldMessage.createTime < newMessage.createTime) {
      relation.set('lastReadMessageId', newMessage);
      return await relation.save();
    }
  }
}

UserRoom.init(
  {
    nameAlias: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  { sequelize, modelName: "UserRoom" }
);

export default UserRoom;
