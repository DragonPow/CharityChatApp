import { DataTypes } from "sequelize";
import sequelize from "../config/mysql.js";

const User = sequelize.define("User", {
    id: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
    },
    name: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    phone: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    timeCreate: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
    },
    imageUri: {
        type: DataTypes.STRING,
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
    // MEANS: Dont need it
    // friends: {
    //     type: DataTypes.ARRAY,
    //     allowNull: true,
    // },
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
});

const Friend = sequelize.define("Friend");
User.belongsToMany(User, { as: 'id1', through: 'Friend', foreignKey: "id1" });
User.belongsToMany(User, { as: 'id2', through: 'Friend', foreignKey: "id2" });

export default User;