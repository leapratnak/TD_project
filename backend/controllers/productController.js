const config = require('../db');
const sql = require('mssql');
const path = require('path');
const fs = require('fs');

async function getPool() {
  return await sql.connect(config);
}
const BASE_URL = "http://192.168.56.1:3000";
const getImageUrl = (req) => {
  if (req.file) return `/images/${req.file.filename}`;
  return req.body.imageUrl || null;
};

// Create Product
exports.createProduct = async (req, res) => {
  const { name, description, categoryId, price } = req.body;
  // const imageUrl = getImageUrl(req);
  const imageUrl = req.file
      // ? `${BASE_URL}/images/${req.file.filename}`
      ? `/images/${req.file.filename}`
      : null;

  try {
    const pool = await getPool();
    const result = await pool.request()
      .input('name', sql.NVarChar, name)
      .input('description', sql.NVarChar, description)
      .input('categoryId', sql.Int, categoryId)
      .input('price', sql.Decimal(18, 2), price)
      .input('imageUrl', sql.NVarChar, imageUrl)
      .query(`
        INSERT INTO Products (Name, Description, CategoryId, Price, ImageUrl)
        VALUES (@name, @description, @categoryId, @price, @imageUrl);
        SELECT CAST(SCOPE_IDENTITY() AS INT) AS Id;
      `);

    const newId = result.recordset[0]?.Id ?? null;
    res.status(201).json({ message: 'Product created', id: newId });
  } catch (err) {
    console.error('createProduct error:', err);
    res.status(500).json({ error: 'Server error' });
  }
};

/* =========================
   GET PRODUCTS (PAGINATION)
========================= */
exports.getProducts = async (req, res) => {
  try {
    const page = Math.max(parseInt(req.query.page || '1'), 1);
    const limit = Math.max(parseInt(req.query.limit || '20'), 1);
    const offset = (page - 1) * limit;

    const search = req.query.search ? `%${req.query.search}%` : '%';
    const categoryId = req.query.category_id
      ? parseInt(req.query.category_id)
      : null;

    const sortBy = req.query.sort_by || 'id';
    const sortOrder = req.query.sort_order === 'asc' ? 'ASC' : 'DESC';

    let orderColumn = 'p.Id';
    if (sortBy === 'name') orderColumn = 'p.Name COLLATE Khmer_100_CI_AS';
    if (sortBy === 'price') orderColumn = 'p.Price';

    const pool = await getPool();

    // COUNT
    const countReq = pool.request().input('search', sql.NVarChar, search);
    if (categoryId) countReq.input('categoryId', sql.Int, categoryId);

    const countSql = categoryId
      ? `SELECT COUNT(*) AS total FROM Products p WHERE p.Name COLLATE Khmer_100_CI_AS LIKE @search AND p.CategoryId=@categoryId`
      : `SELECT COUNT(*) AS total FROM Products p WHERE p.Name COLLATE Khmer_100_CI_AS LIKE @search`;

    const total = (await countReq.query(countSql)).recordset[0].total;

    // DATA
    const reqData = pool.request()
      .input('search', sql.NVarChar, search)
      .input('offset', sql.Int, offset)
      .input('limit', sql.Int, limit);

    if (categoryId) reqData.input('categoryId', sql.Int, categoryId);

    const whereSql = categoryId
      ? `WHERE p.Name COLLATE Khmer_100_CI_AS LIKE @search AND p.CategoryId=@categoryId`
      : `WHERE p.Name COLLATE Khmer_100_CI_AS LIKE @search`;

    const data = await reqData.query(`
      SELECT p.*, c.Name AS CategoryName
      FROM Products p
      LEFT JOIN Categories c ON p.CategoryId = c.Id
      ${whereSql}
      ORDER BY ${orderColumn} ${sortOrder}
      OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY
    `);

    res.json({
      data: data.recordset,
      meta: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (err) {
    console.error('getProducts error:', err);
    res.status(500).json({ error: 'Server error' });
  }
};

/* =========================
   UPDATE PRODUCT
========================= */
exports.updateProduct = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  const { name, description, categoryId, price } = req.body;
  // const imageUrl = getImageUrl(req);
   const imageUrl = req.file
      // ? `${BASE_URL}/images/${req.file.filename}`
      ? `/images/${req.file.filename}`
      : null;

  try {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.Int, id)
      .input('name', sql.NVarChar, name)
      .input('description', sql.NVarChar, description)
      .input('price', sql.Decimal(18, 2), price)
      .input('categoryId', sql.Int, categoryId)
      .input('imageUrl', sql.NVarChar, imageUrl)
      .query(`
        UPDATE Products
        SET Name = COALESCE(@name, Name),
            Description = COALESCE(@description, Description),
            Price = COALESCE(@price, Price),
            CategoryId = COALESCE(@categoryId, CategoryId),
            ImageUrl = COALESCE(@imageUrl, ImageUrl)
        WHERE Id = @id
      `);
    res.json({ message: 'Product updated' });
  } catch (err) {
    console.error('updateProduct error:', err);
    res.status(500).json({ error: 'Server error' });
  }
};

/* =========================
   DELETE PRODUCT
========================= */
exports.deleteProduct = async (req, res) => {
  const id = parseInt(req.params.id, 10);
  try {
    const pool = await getPool();
    await pool.request().input('id', sql.Int, id).query('DELETE FROM Products WHERE Id = @id');
    res.json({ message: 'Product deleted' });
  } catch (err) {
    console.error('deleteProduct error:', err);
    res.status(500).json({ error: 'Server error' });
  }
};
