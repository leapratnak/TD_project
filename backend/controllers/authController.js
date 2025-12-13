const sql = require("mssql");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const dbConfig = require("../db");

const JWT_SECRET = process.env.JWT_SECRET || "replace-me";
const OTP_EXPIRY_MIN = parseInt(process.env.OTP_EXPIRY_MIN || "15");

async function getPool() {
    return await sql.connect(dbConfig);
}

// ================= Signup =================
async function signup(req, res) {
    const { email, username, password } = req.body;
    if (!email || !username || !password)
        return res.status(400).json({ error: "Missing fields" });

    try {
        const pool = await getPool();

        const exists = await pool.request()
            .input("email", sql.VarChar, email)
            .input("username", sql.VarChar, username)
            .query("SELECT * FROM Users WHERE Email=@email OR Username=@username");

        if (exists.recordset.length) 
            return res.status(409).json({ error: "User already exists" });

        const hash = await bcrypt.hash(password, 10);

        await pool.request()
            .input("email", sql.VarChar, email)
            .input("username", sql.VarChar, username)
            .input("password", sql.VarChar, hash)
            .query("INSERT INTO Users (Email, Username, PasswordHash) VALUES (@email, @username, @password)");

        res.status(201).json({ message: "Account created" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
}

// ================= Login =================
async function login(req, res) {
    const { emailOrUsername, password } = req.body;
    if (!emailOrUsername || !password)
        return res.status(400).json({ error: "Missing fields" });

    try {
        const pool = await getPool();
        console.log("DB pool ready");

        const result = await pool.request()
            .input("value", sql.VarChar, emailOrUsername)
            .query("SELECT * FROM Users WHERE Email=@value OR Username=@value");

        console.log("Query result:", result.recordset);

        const user = result.recordset[0];
        if (!user) {
            console.log("User not found");
            return res.status(401).json({ error: "Invalid credentials" });
        }

        const match = await bcrypt.compare(password, user.PasswordHash);
        if (!match) {
            console.log("Password mismatch");
            return res.status(401).json({ error: "Invalid credentials" });
        }

        const token = jwt.sign({ id: user.Id, email: user.Email }, JWT_SECRET, { expiresIn: "7d" });
        res.json({ token });
    } catch (err) {
        console.error("🔥 login error:", err);
        res.status(500).json({ error: "Server error" });
    }
}



// ================= Forgot Password =================
async function forgotPassword(req, res) {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Missing email" });

    try {
        const pool = await getPool();
        const result = await pool.request()
            .input("email", sql.VarChar, email)
            .query("SELECT * FROM Users WHERE Email=@email");

        const user = result.recordset[0];
        if (!user) return res.status(404).json({ error: "User not found" });

        const otp = Math.floor(100000 + Math.random() * 900000).toString();
        const expiresAt = new Date(Date.now() + OTP_EXPIRY_MIN * 60 * 1000);

        await pool.request()
            .input("userId", sql.Int, user.Id)
            .input("otp", sql.VarChar, otp)
            .input("expiresAt", sql.DateTime, expiresAt)
            .query(`
                MERGE PasswordResets AS target
                USING (SELECT @userId AS UserId) AS source
                ON (target.UserId = source.UserId)
                WHEN MATCHED THEN UPDATE SET OTP=@otp, ExpiresAt=@expiresAt
                WHEN NOT MATCHED THEN INSERT (UserId, OTP, ExpiresAt) VALUES (@userId, @otp, @expiresAt);
            `);

        // Just for testing: include OTP in response
        res.json({ message: "OTP sent", otp });

        // Log as well
        console.log(`➡️ OTP for ${email}: ${otp}`);

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
}


// ================= Reset Password =================
async function resetPassword(req, res) {
    const { email, otp, newPassword } = req.body;
    if (!email || !otp || !newPassword)
        return res.status(400).json({ error: "Missing fields" });

    try {
        const pool = await getPool();
        const userRes = await pool.request()
            .input("email", sql.VarChar, email)
            .query("SELECT * FROM Users WHERE Email=@email");
        const user = userRes.recordset[0];
        if (!user) return res.status(404).json({ error: "User not found" });

        const pr = await pool.request()
            .input("userId", sql.Int, user.Id)
            .query("SELECT * FROM PasswordResets WHERE UserId=@userId");
        const row = pr.recordset[0];

        if (!row || row.OTP !== otp) return res.status(400).json({ error: "Invalid OTP" });
        if (new Date(row.ExpiresAt) < new Date()) return res.status(400).json({ error: "OTP expired" });

        const hash = await bcrypt.hash(newPassword, 10);
        await pool.request()
            .input("password", sql.VarChar, hash)
            .input("userId", sql.Int, user.Id)
            .query("UPDATE Users SET PasswordHash=@password WHERE Id=@userId");

        await pool.request()
            .input("userId", sql.Int, user.Id)
            .query("DELETE FROM PasswordResets WHERE UserId=@userId");

        res.json({ message: "Password reset" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Server error" });
    }
}


// middleware: JWT auth
async function getProfile(req, res) {
  try {
    const userId = req.user.id; // from JWT
    const pool = await getPool();

    const result = await pool.request()
      .input("id", sql.Int, userId)
      .query("SELECT Id, Username, Email FROM Users WHERE Id=@id");

    const user = result.recordset[0];
    if (!user) return res.status(404).json({ error: "User not found" });

    res.json({ user }); // ensure keys are lowercase or consistent
  } catch (err) {
    console.error("🔥 profile error:", err);
    res.status(500).json({ error: "Server error" });
  }
}





module.exports = { signup, login, forgotPassword, resetPassword,getProfile };
