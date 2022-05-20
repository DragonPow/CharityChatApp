const config = {
    db: {
        database: "my_db",
        host: "charityapp-mysqlserver.mysql.database.azure.com",
        username: "VuNgocThach",
        password: "Thach4162311",
        port: 3306,
        cert_url: "./DigiCertGlobalRootCA.crt.pem",
    },
    testing_db: {
        database: "mocks",
        host: "localhost",
        port: 3306,
    },
    jwt: {
        expireTime: 24, //24 hours
        secretCode: 'SECRETE',
    }
};

export default config;
