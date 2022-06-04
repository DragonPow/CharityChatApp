const config = {
    db: {
        database: "my_db",
        host: "charityapp-mysqlserver.mysql.database.azure.com",
        username: "VuNgocThach",
        password: "Thach4162311",
        port: 3306,
    },
    cert_url: "./DigiCertGlobalRootCA.crt.pem",
    testing_db: {
        database: "charityapp",
        host: "localhost",
        username: 'root',
        password: 'ngocthach',
        port: 3306,
    },
    jwt: {
        expireTime: 24, //24 hours
        secretCode: 'SECRETE',
        tokenAdmin: 'ADMIN_TOKEN',
        tokenExample: 'EXAMPLE_TOKEN',
    },
    adminId: 'ADMIN_ID',
    exampleId: '1',
    server: {
        port: process.env.port || 3000,
        port_socket: process.env.port_socket || 3001,
    }
};

export default config;
