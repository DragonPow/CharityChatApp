export const GetDataFromSequelizeObject = (record) => {
    return JSON.parse(JSON.stringify(record,null,4));
}