import morgan from 'morgan';
import path from 'path';
import fs from 'fs';
import {fileURLToPath} from 'url';

const __filename = fileURLToPath(import.meta.url);

const logger = morgan('combined', {
    stream: fs.createWriteStream(path.join(path.dirname(__filename) ,'history.log'))
});

export default logger;