import { v4 as uuidV4 } from "uuid";
import path from "path";
import multer from "multer";

const myMulter = (pathStorage, maxFileSize, maxFileReceive) => {
    // Set storage
    const multerStorage = multer.diskStorage({
      destination: function (req, file, cb) {
        cb(null, pathStorage);
      },
      filename: function (req, file, cb) {
        const uniqueSuffix = uuidV4(); // create name
        cb(null, uniqueSuffix + path.extname(file.originalname));
      },
    });

    const uploadMessageFile = multer({
      storage: multerStorage,
      limits: {
        files: maxFileReceive,
        fileSize: maxFileSize,
      },
    });

    return uploadMessageFile;
};

export default myMulter;