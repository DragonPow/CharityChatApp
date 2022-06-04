import config from "./index.js";
import Sequelize from "sequelize";
import { default as path, dirname } from "path";
import { fileURLToPath } from "url";
import fs from "fs";

// const connection = config.db; // remote database
const connection = config.testing_db; // localhost database

const connection_url = connection.host;
const username = connection.username;
const password = connection.password;
const port = connection.port;
const database = connection.database;

//get current dir
const __dirname = dirname(fileURLToPath(import.meta.url));

//read cert
const rdsCert = fs.readFileSync(path.join(__dirname, config.cert_url));

//define sequelize
const sequelize = new Sequelize({
  database: database,
  username: username,
  password: password,
  port: port,
  host: connection_url,
  dialect: "mysql",
  logging: (...msg) => console.log(msg),
  dialectOptions:
    connection !== config.db // set cert if is db
      ? undefined
      : {
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
    charset: "utf8",
    timestamps: false, //Not create createAt and updateAt column in table
  },
});

export default sequelize;
