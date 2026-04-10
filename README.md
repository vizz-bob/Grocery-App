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

*(Add screenshots here)*

## License

This project is for educational purposes.
