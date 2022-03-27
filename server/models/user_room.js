import { DataTypes } from "sequelize";
import sequelize from "../config/mysql";
import Message from "./message";

const UserRoom = sequelize.define("UserRoom", {});

UserRoom.hasOne(Message, { as: "lastReadMessage" });
User.belongsToMany(Room, { through: UserRoom, foreignKey: "roomId" });
Room.belongsToMany(User, { through: UserRoom, foreignKey: "userId" });

export default UserRoom;
