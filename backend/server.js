const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const sql = require("mssql");
const path = require('path');

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

// Routes
const authRoutes = require("./routes/authRoutes");
app.use("/api/auth", authRoutes);

const categoryRoutes = require("./routes/categoryRoutes");
app.use("/api/categories", categoryRoutes);

const productRoutes = require("./routes/productRoutes");
app.use('/api/products', productRoutes); // mount products

// Test route
app.get("/", (req, res) => res.send("API running..."));

// Serve uploaded images
app.use(
  '/images',
  express.static(path.join(__dirname, 'upload/images'))
);


// Start server
const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => console.log(`✅ Server running on http://192.168.56.1:${PORT}`));
