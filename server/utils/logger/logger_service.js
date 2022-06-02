import morgan from "morgan";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const fileLog = path.join(path.dirname(__filename), "history.log");

const logger = morgan("combined", {
  stream: fs.createWriteStream(
    fileLog,
    { flags: "a" } // open and append tag
  ),
});

// const addLog = (content) => {
//   fs.writeFile(fileLog, content, { flags: "a" });
// };

export default logger;
