import { DataTypes, Model, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { GetDataFromSequelizeObject } from "../config/helper.js";

class UserRoom extends Model {}

UserRoom.init("UserRoom", { sequelize });

// UserRoom.getRoomsIdByPaging = async (startIndex, number, userId) => {
//     const userRooms = await Room.findAll({
//         include: [
//             {
//                 model: User,
//                 as: "container",
//                 where: {
//                     userId: userId,
//                 },
//                 attributes: [],
//             },
//             {
//                 model: Message,
//                 as: "lastMessage",
//                 attributes: [["timeCreate", "lastMessageTime"]],
//             },
//         ],
//         attributes: ["id"],
//         offset: startIndex,
//         limit: number,
//         // order: [["lastMessageTime", "DESC"]],
//     });

//     return GetDataFromSequelizeObject(userRooms).map((i) => i.roomId);
// };

// UserRoom.getUsersByRoomId = async (roomId) => {
//     const userRooms = await UserRoom.findAll({
//         where: { roomId: roomId },
//         attributes: ["userId"],
//     });
//     return userRooms.map((i) => i.userId);
// };

// UserRoom.getUsersByRoomsId = async (roomsId) => {
//     const list = await UserRoom.findAll({
//         where: {
//             roomId: {
//                 [Op.in]: roomsId
//             }
//         }
//     });

//     return list;
// }

// UserRoom.createRoom = async (roomInfo, listUsersId) => {
//     const room = await Room.createRoom(roomInfo);
//     await UserRoom.bulkCreate(
//         listUsersId.map((userId) => {
//             return { roomId: room.id, userId };
//         })
//     );

//     return room;
// };

// UserRoom.deleteByRoomId = async (roomId) => {
//     try {
//         const rs = await UserRoom.destroy({
//             where: {
//                 roomId: roomId,
//             },
//         });
//         //TODO: Should or Not delete messages in this room here?
//         return rs;
//     } catch (error) {
//         throw error;
//     }
// };

export default UserRoom;
