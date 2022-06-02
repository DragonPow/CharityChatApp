import path from "path";

export const GetDataFromSequelizeObject = (record) => {
  return JSON.parse(JSON.stringify(record, null, 4));
};

export const TranferFileMulterToString = (file) => {
  return file.destination + "/" + file.filename;
};

export const CheckIsImageFile = (fileName) => {
  console.log(path.extname(fileName));
  return [".jpeg", ".png", ".gif", ".tiff", ".jpg"].includes(
    path.extname(fileName)
  );
};
