const sql = require('mssql');
const dbConfig = require('../db');

// CREATE CATEGORY
exports.createCategory = async (req, res) => {
  try {
    const { name, description } = req.body;
    const pool = await sql.connect(dbConfig);

    await pool.request()
      .input("name", sql.NVarChar, name)
      .input("description", sql.NVarChar, description)
      .query(`INSERT INTO Categories (Name, Description) VALUES (@name, @description)`);

    res.status(201).json({ message: "Category created" });
  } catch (error) {
    console.error("CREATE ERROR:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// GET CATEGORIES + SEARCH
exports.getCategories = async (req, res) => {
  try {
    const search = req.query.search || "";
    const pool = await sql.connect(dbConfig);

    const result = await pool.request()
      .input("search", sql.NVarChar, `%${search}%`)
      .query(`
        SELECT Id, Name, Description
        FROM Categories
        WHERE Name COLLATE Khmer_100_CI_AS LIKE @search
        ORDER BY Id DESC
      `);

    res.status(200).json({ data: result.recordset });
  } catch (error) {
    console.error("GET ERROR:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// UPDATE CATEGORY
exports.updateCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;
    const pool = await sql.connect(dbConfig);

    await pool.request()
      .input("id", sql.Int, id)
      .input("name", sql.NVarChar, name)
      .input("description", sql.NVarChar, description)
      .query(`UPDATE Categories SET Name=@name, Description=@description WHERE Id=@id`);

    res.status(200).json({ message: "Category updated" });
  } catch (error) {
    console.error("UPDATE ERROR:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// DELETE CATEGORY
exports.deleteCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const pool = await sql.connect(dbConfig);

    await pool.request()
      .input("id", sql.Int, id)
      .query(`DELETE FROM Categories WHERE Id=@id`);

    res.status(200).json({ message: "Category deleted" });
  } catch (error) {
    console.error("DELETE ERROR:", error);
    res.status(500).json({ message: "Server error" });
  }
};
