const sql = require("mssql");
require("dotenv").config();

async function test() {
    try {
        const pool = await sql.connect({
            user: process.env.DB_USER,
            password: process.env.DB_PASS,
            database: process.env.DB_NAME,
            server: process.env.DB_HOST,  // MUST be string
            port: parseInt(process.env.DB_PORT, 10),
            options: {
                encrypt: false,
                trustServerCertificate: true
            }
        });

        const result = await pool.request()
            .input("value", sql.VarChar, "test@gmail.com")
            .query("SELECT * FROM Users WHERE Email = @value");

        console.log(result.recordset);
    } catch (err) {
        console.error(err);
    }
}

test();
