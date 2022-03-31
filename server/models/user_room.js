import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";
import Message from "./message.js";

const UserRoom = sequelize.define("UserRoom", {});

export default UserRoom;
