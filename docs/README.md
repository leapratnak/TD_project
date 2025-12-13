
## Project Structure

/my-project-repo
│
├── backend/ --> Node.js API
├── frontend/ --> Flutter app
├── sql/ --> SQL scripts (schema & sample data)
├── docs/ --> Main documentation(README.md)


---


## Project Purpose

This project is a **full-stack application** that includes:

- User authentication (Login, Signup)
- Forgot password with OTP
- Product management (CRUD)
- Image upload and display
- Mobile-friendly Flutter UI
- RESTful API backend

---

## Technologies Used

### Backend
- Node.js
- Express.js
- MSSQL
- Multer (image upload)
- JWT Authentication

### Frontend
- Flutter (Dart)
- CachedNetworkImage
- REST API integration

### Database
- Microsoft SQL Server

---

## Authentication Flow

1. User logs in or signs up
2. Token (JWT) is returned
3. Token is stored locally in Flutter
4. Protected APIs use token
5. Forgot password uses OTP for verification

---

## OTP Reset Flow

1. User enters email (Forgot Password)
2. Backend generates OTP
3. OTP is alert on screen and displayed in console (development mode)
4. OTP is entered in Flutter app
5. Password is reset successfully

---

## Image Handling

- Images are uploaded from Flutter
- Stored locally in backend:


## API Communication

- Flutter communicates with backend using HTTP
- JSON-based request/response
- Multipart form-data for image upload

---

## Important Notes(Real Device)

- Flutter real device must use **PC IP address**
- Backend server must be running before Flutter app
- Both devices must be on the **same Wi-Fi network**

---



## Future Improvements

- Real email service (Nodemailer / SendGrid)
- Role-based access control
- Product categories
- Admin dashboard (Web)

---

##  Author

Developed by **Sath Leapratnak**  
Year: **14/12/2025**