

# Backend – Node.js API

This folder contains the **Node.js + Express REST API** used by the Flutter frontend.  
It handles **authentication, products, image upload, and database access**.

---

## Tech Stack

- **Node.js**
- **Express.js**
- **MSSQL (SQL Server)**
- **JWT Authentication**
- **bcrypt** (password hashing)
- **multer** (image upload)
- **dotenv** (environment variables)

---

## Folder Structure

backend/
│
├── controllers/
│ ├── authController.js
│ └── productController.js
│
├── middleware/
│ └── authMiddleware.js
│
├── routes/
│ ├── authRoutes.js
│ └── productRoutes.js
│
├── upload/
│ └── images/ # Uploaded product images
│
├── utils/
│ └── email.js # OTP email (console log for dev)
│
├── db.js # MSSQL configuration
├── server.js # App entry point
├── .env.example
├── package.json
└── README.md




---

## Environment Configuration

  Edit a `.env` file 
  Please config match with your Database 
      
   DB_USER=sa
   DB_PASSWORD=yourStrongPassword
   DB_NAME=your_database
   DB_SERVER=yourServerName
   DB_PORT=1433
   
   JWT_SECRET=replace-me
   OTP_EXPIRY_MIN=15


## Setup and running
- cd backend
- npm install
- npm start, npm run dev, node server.js

