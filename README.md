
**Backend**

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





**Frontend**

### Base URL (important for real device)
- Flutter real device must use **PC IP address**
- Both devices must be on the **same Wi-Fi network**

- Update API base URL in: **lib/services/...**
  Example:
- static const **baseUrl = "http://132.184.00.1:3000";**



## Setup and running flutter
--- Note : **Backend server must be running before Flutter app** ---

- cd flutter_app
- flutter pub get  (for when add dependencies)
- Configure API Base URL
- flutter run