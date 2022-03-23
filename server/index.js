import http from "http";
import express from "express";
import sequelize from "./config/mysql.js";
import indexRouter from "./routes/index.js";

const app = express();

const port = process.env.PORT | "3000";
app.set("port", port);

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

//Navigator to another
app.use("/", indexRouter);

//Catch 404 and forward to error handler
app.use("*", (req, res) => {
    return res.status(404).json({
        success: false,
        message: "API endpoint does not exist",
    });
});

try {
    console.log('before authen');
    await sequelize.authenticate();
    console.log('test success');
} catch (error) {
    console.error('unable to connect database', error);    
}

//Create HTTP server
const server = http.createServer(app);
//Create socket connection
//TODO: make socket listen from server
//Listen on provided port
server.listen(port);
//Event listener for HTTP server "listening" event
server.on("listening", () => {
    console.log(`Listening on port:: http://localhost:${port}`);
});
