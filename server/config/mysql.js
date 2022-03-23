"user_strict";

import config from "./index.js";
import Sequelize from "sequelize";
import {dirname} from 'path';
import {fileURLToPath} from 'url'


const CONNECTION_URL = config.db.host;
let username = config.db.username;
let password = config.db.password;
let port = config.db.port;
let database = config.db.database;

//get current dir
let __dirname = dirname(fileURLToPath(import.meta.url));

//read cert
import fs from 'fs';
const rdsCert = fs.readFileSync(__dirname + "/DigiCertGlobalRootCA.crt.pem");

const sequelize = new Sequelize({
    db: database,
    username: username,
    password: password,
    port: port,
    host: CONNECTION_URL,
    dialect: "mysql",
    dialectOptions: {
        ssl: {
            cert: rdsCert,
        }
    },
    hooks: {
        afterConnect: () => {
            console.log("afterConnect:", "connection success");
        },
    },
});

sequelize;

export default sequelize;
