import { DataTypes, Model, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";

class UserRoom extends Model {
  static async changeJoiners(roomId, addIds, removeIds) {
    const transaction = await sequelize.transaction();

    try {
      const added = (await UserRoom.bulkCreate(
        addIds.map((i) => {
          return { userId: i, roomId: roomId };
        }),
        { transaction: transaction }
      )).length;

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
