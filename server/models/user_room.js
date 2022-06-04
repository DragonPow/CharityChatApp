import { DataTypes, Model } from "sequelize";
import sequelize from "../config/mysql.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";

class UserRoom extends Model {
  static async changeJoiners(roomId, addIds, removeIds) {
    const transaction = await sequelize.transaction();

    try {
      // const userRooms = await UserRoom.findAll({
      //   where: { roomId: roomId },
      //   attributes: ["userId"],
      // });

      await UserRoom.bulkCreate(
        addIds.map((i) => {
          return { userId: i, roomId: roomId };
        }),
        { transaction: transaction }
      );

      await UserRoom.destroy(
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
    } catch (error) {
      transaction.callback();
      throw error;
    }
  }

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
