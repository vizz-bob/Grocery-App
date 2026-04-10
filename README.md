# Grocery App

A Flutter-based grocery delivery application with a PHP backend.

## Features

- **User Authentication**: Login, Signup, and OTP verification
- **Product Browsing**: Categories, Featured Products, and Product Variants
- **Shopping Cart**: Add products, manage quantities, and checkout
- **Address Management**: Add, edit, and delete delivery addresses
- **Order Tracking**: Track order status in real-time
- **Wallet & Payments**: Manage wallet balance and payment methods
- **User Profile**: View and edit profile information

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: PHP REST API
- **Database**: MySQL
- **State Management**: Provider / SharedPreferences
- **API**: HTTP requests with JSON

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio / Xcode (for emulators)
- PHP server with MySQL (backend)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/vizz-bob/Grocery-App.git
cd Grocery-App
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Backend API

The app connects to a PHP backend API hosted at:
`https://darkslategrey-chicken-274271.hostingersite.com/api`

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models (CartModel, etc.)
├── screens/               # UI screens
├── services/              # API services
├── theme/                 # App theming and colors
├── utils/                 # Utility classes
└── widgets/               # Reusable widgets
```

## Screenshots

<img width="500" height="826" alt="image" src="https://github.com/user-attachments/assets/248b3df6-e62d-41ac-b133-a17de35c8caa" />
<img width="382" height="826" alt="image" src="https://github.com/user-attachments/assets/399c1911-eb5e-4b96-b497-a745bf65d336" />
<img width="382" height="826" alt="image" src="https://github.com/user-attachments/assets/1e49f398-3301-47ac-a7cb-0e01781f6274" />
<img width="382" height="826" alt="image" src="https://github.com/user-attachments/assets/7a072512-1565-4219-8071-a33cfac958eb" />


## License

This project is for educational purposes.
