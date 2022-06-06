import { Model } from "sequelize";
import sequelize from "../config/mysql.js";

class Friend extends Model {}

Friend.init({}, { sequelize: sequelize, modelName: "Friend" });

export default Friend;
