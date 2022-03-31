"user_strict";

import config from "./index.js";
import Sequelize from "sequelize";
import { default as path, dirname } from "path";
import { fileURLToPath } from "url";
import fs from "fs";

const connection_url = config.db.host;
const username = config.db.username;
const password = config.db.password;
const port = config.db.port;
const database = config.db.database;

//get current dir
const __dirname = dirname(fileURLToPath(import.meta.url));

//read cert
const rdsCert = fs.readFileSync(path.join(__dirname, config.db.cert_url));

//define sequelize
const sequelize = new Sequelize({
    database: database,
    username: username,
    password: password,
    port: port,
    host: connection_url,
    dialect: "mysql",
    dialectOptions: {
        ssl: {
            cert: rdsCert,
        },
    },
    hooks: {
        afterConnect: () => {
            console.log("afterConnect:", "DB connection success");
        },
    },
    define: {
        charset: 'utf8',
        timestamps: false, //Not create createAt and updateAt column in table
    }
});

export default sequelize;
