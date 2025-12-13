

# Flutter Frontend Application

This document describes the **Flutter frontend** of the project, including setup instructions, structure and API integration

---

## Frontend Structure

/flutter_app
│
├── lib/
│ ├── screens/ --> UI screens (login, signup, reset, home)
│ ├── services/ --> API service & token handling
│ ├── widgets/ --> Reusable UI components
│ └── main.dart --> App entry point
│
├── pubspec.yaml --> Flutter dependencies
└── README.md --> Frontend documentation



## API Configuration

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







