const sql = require("mssql");
require("dotenv").config();

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    server: process.env.DB_SERVER,
    port: 1433,
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};

module.exports = config;
