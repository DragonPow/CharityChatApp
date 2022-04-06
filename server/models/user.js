import { DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { v4 as uuidv4 } from "uuid";
import Friend from "./friend.js";

const User = sequelize.define("User", {
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
});

//Method
/**
 * Get user online of logging activity
 * @param {number} startIndex
 * @param {number} number number user need get
 * @param {string} mainUserId userId to find friends
 * @returns List user is friend and in online of mainUserId
 */
User.statics.getActiveUsersByPage = async (startIndex, number, mainUserId) => {
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
};

/**
 * Find user by name text
 * @param {string} textMatch
 * @param {number} startIndex start query at position is $startIndex
 * @param {number} number
 * @returns List user
 */
User.statics.getUsersByName = async (textMatch, startIndex, number) => {
    const users = await User.findAll({
        attributes: ["id", "name", "avatarUri", "gender"],
        where: {
            name: {
                [Op.substring]: textMatch,
            },
        },
        limit: number,
        offset: startIndex,
    });
    return users;
};

User.statics.getUserById = async (userId) => {
    const user = await User.findByPk(userId);
    //Don't show password
    delete user.password;

    return user;
};

export default User;
