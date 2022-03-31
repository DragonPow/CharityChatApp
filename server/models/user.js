import { DataTypes, Op } from "sequelize";
import sequelize from "../config/mysql.js";
import { v4 as uuidv4 } from 'uuid';

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
        type: DataTypes.STRING({binary: true}),
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
 * @returns List user
 */
User.getActiveUsersByPage = async (startIndex, number) => {
    //TODO: Open websocket to check current online user of server of specific user
    try {
    } catch (error) {
        throw error;
    }
};

/**
 * Find user by name text
 * @param {string} textMatch
 * @param {number} startIndex start query at position is $startIndex
 * @param {number} number
 * @returns List user
 */
User.getUsersByName = async (textMatch, startIndex, number) => {
    try {
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
    } catch (error) {
        throw error;
    }
};

User.getUserById = async (userId) => {
    try {
        const user = await User.findByPk(userId);
        return user;
    } catch (error) {
        throw error;
    }
};

export default User;
