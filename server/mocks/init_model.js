import sequelize from "../config/mysql.js";

// Import some module to define model
import "../models/index.js";


await sequelize
    .sync({ force: true }) // if force is true, drop all table although exists or not
    .then(async (rs) => {
        console.log("Sequelize", rs);
    })
    .catch((err) => {
        console.log("Sequelize", err);
    });
