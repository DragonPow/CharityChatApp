import { DataTypes } from 'sequelize/types';
import sequelize from '../config/mysql';
import Message from './message';

const UserRoom = sequelize.define('UserRoom',{
    
});

UserRoom.hasOne(Message, {as: 'lastReadMessage'});
User.belongsToMany(Room, {through: UserRoom});
Room.belongsToMany(User, {through: UserRoom});

export default UserRoom;