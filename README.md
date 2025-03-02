# Collab - Connect. Create. Collaborate.

Collab is a modern Flutter application designed to connect influencers, brands, and businesses for collaboration opportunities. The app provides a sleek, Apple-inspired UI with smooth animations and intuitive user flows.

## Features

- **Multi-user Types**: Support for Influencers, Brands, and Businesses
- **Phone Authentication**: Secure login via mobile number and OTP verification
- **Profile Management**: Create and manage detailed profiles
- **Modern UI/UX**: Clean, minimal design inspired by Apple's design language
- **Responsive Layout**: Works across different screen sizes
- **Smooth Animations**: Enhances the user experience

## Screens

1. **Splash Screen**: Animated app introduction
2. **Onboarding**: Interactive introduction to app features
3. **Login**: Phone number authentication
4. **Verification**: OTP verification
5. **Profile Creation**: User profile setup
6. **Home**: Dashboard with recommendations and stats
7. **Profile**: User profile management

## Technical Details

- Built with Flutter and Dart
- State management using Provider
- Mock authentication system (for demo purposes)
- Custom theme with Google Fonts
- Animations with flutter_animate

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- A physical device or emulator

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/collab.git
```

2. Navigate to the project directory:

```bash
cd collab
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Demo Credentials

For testing purposes, use:
- Any 10-digit phone number for login
- OTP: 123456

## Future Enhancements

- Real authentication integration
- Chat functionality
- Project management
- Analytics dashboard
- Notification system
- Payment integration

## Screenshots

[Screenshots will be added here]

## License

This project is licensed under the MIT License.

## Acknowledgements

- Flutter Team for the amazing framework
- Google Fonts for the typography
- All the open-source packages used in this project

## Firebase Setup

This project uses Firebase for authentication, storage, and database functionalities. Follow these steps to set up Firebase for your project:

1. **Create a Firebase Project**:
   - Go to the [Firebase Console](https://console.firebase.google.com/)
   - Click "Add Project" and follow the setup wizard
   - Give your project a name (e.g., "Collab App")
   - Enable Google Analytics if desired
   - Create the project

2. **Configure FlutterFire**:
   - Install Firebase CLI if not already installed:
     ```bash
     npm install -g firebase-tools
     ```
   - Login to Firebase:
     ```bash
     firebase login
     ```
   - Install FlutterFire CLI:
     ```bash
     dart pub global activate flutterfire_cli
     ```
   - Run the FlutterFire configuration command in your project directory:
     ```bash
     flutterfire configure --project=your-firebase-project-id
     ```
   - Select the platforms you want to support (iOS, Android, Web, etc.)
   - This will generate a `firebase_options.dart` file which will replace the placeholder file

3. **Enable Authentication**:
   - In the Firebase Console, go to "Authentication" → "Sign-in method"
   - Enable "Phone" as a sign-in provider
   - Set up other providers if needed

4. **Set up Firestore Database**:
   - Go to "Firestore Database" in the Firebase Console
   - Click "Create database"
   - Choose "Start in production mode" or "Start in test mode" (for development)
   - Select a location for your database
   - Create a "users" collection for storing user profiles

5. **Set up Storage (if needed)**:
   - Go to "Storage" in the Firebase Console
   - Follow the setup wizard
   - Create storage rules for your app's needs

6. **Update iOS and Android configurations**:
   - For iOS: Update `ios/Runner/Info.plist` to include necessary permissions
   - For Android: Ensure the minimum SDK version in `android/app/build.gradle` is set to 21 or higher

With these steps completed, your app should be properly connected to Firebase services.
# collab
