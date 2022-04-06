import sequelize from "../config/mysql.js";
class Model {
    static async callTransaction(startAction, callbackAction) {
        if (startAction) throw new Error("StartAction of transaction is not null");
        const t = await sequelize.transaction();
        let rs = false;
        try {
            await startFunction();
            await t.commit();
            rs = true;
        }
        catch (error) {
            console.log("TRANSACTION", error);
            await t.rollback();
            if (callbackAction) await callbackAction();
        }
        
        return rs;
    }
}

export default Model;