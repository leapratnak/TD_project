const express = require("express");
const router = express.Router();
const authController = require("../controllers/authController");
const authMiddleware = require("../middleware/authMiddleware");

// Test route
router.get("/", (req, res) => res.send("Auth API running"));

// Auth routes
router.post("/signup", authController.signup);
router.post("/login", authController.login);
router.post("/forgot-password", authController.forgotPassword);
router.post("/reset-password", authController.resetPassword);

// ✅ New profile route
router.get("/profile", authMiddleware, async (req, res) => {
    try {
        // req.user comes from JWT middleware
        const user = {
            id: req.user.id,
            email: req.user.email,
            username: req.user.username,
        };
        res.json({ user });
    } catch (err) {
        console.error("🔥 profile error:", err);
        res.status(500).json({ error: "Server error" });
    }
});

module.exports = router;
