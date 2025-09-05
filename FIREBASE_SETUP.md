# Firebase Configuration Setup

This document explains how to set up Firebase configuration for the Budget App project.

## Prerequisites

1. A Firebase project (create one at [Firebase Console](https://console.firebase.google.com/))
2. Flutter SDK installed
3. FlutterFire CLI installed (`dart pub global activate flutterfire_cli`)

## Setup Instructions

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Enable the following services:
   - Authentication (with your preferred sign-in methods)
   - Firestore Database
   - Firebase Storage
   - Firebase Messaging (for push notifications)
   - Firebase Crashlytics (optional)

### 2. Generate Configuration Files

#### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```

3. Follow the prompts to select your Firebase project and platforms

#### Option B: Manual Configuration

If you prefer manual setup or FlutterFire CLI doesn't work:

1. **Android Configuration:**
   - Go to Firebase Console → Project Settings → General
   - Add an Android app with package name: `com.yourcompany.yourapp`
   - Download `google-services.json`
   - Place it in `android/app/google-services.json`

2. **iOS Configuration:**
   - Add an iOS app with bundle ID: `com.yourcompany.yourapp`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/GoogleService-Info.plist`

3. **Web Configuration:**
   - Add a Web app
   - Copy the configuration and update `lib/firebase_options.dart`

### 3. Copy Example Files

Copy the example configuration files and replace with your actual values:

```bash
# Copy Firebase options
cp lib/firebase_options.dart.example lib/firebase_options.dart

# Copy Android configuration (if not using FlutterFire CLI)
cp android/app/google-services.json.example android/app/google-services.json

# Copy iOS configuration (if not using FlutterFire CLI)
cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
```

### 4. Update Configuration Files

Replace the placeholder values in the copied files with your actual Firebase configuration:

- `YOUR_PROJECT_ID` → Your Firebase project ID
- `YOUR_API_KEY` → Your platform-specific API key
- `YOUR_APP_ID` → Your platform-specific app ID
- `YOUR_MESSAGING_SENDER_ID` → Your Firebase messaging sender ID
- Other platform-specific values as needed

## Android Signing Setup

For release builds, you'll need to set up Android app signing:

### 1. Generate a Keystore

```bash
keytool -genkey -v -keystore android/app/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key
```

### 2. Configure Key Properties

```bash
cp android/key.properties.example android/key.properties
```

Update `android/key.properties` with your keystore information:
- `storePassword` → Your keystore password
- `keyPassword` → Your key password
- `keyAlias` → Your key alias
- `storeFile` → Path to your keystore file

## Play Store Deployment (Optional)

If you plan to deploy to Google Play Store:

### 1. Service Account Setup

1. Go to [Google Play Console](https://play.google.com/console/)
2. Create a service account for API access
3. Download the JSON key file
4. Copy it to `android/play-account.json`

```bash
cp android/play-account.json.example android/play-account.json
```

## Environment Variables (Optional)

For additional security, you can use environment variables:

1. Create a `.env` file in the project root
2. Add your sensitive configuration:
   ```
   FIREBASE_API_KEY=your_api_key_here
   FIREBASE_PROJECT_ID=your_project_id_here
   ```

3. Load environment variables in your app (requires additional setup)

## Security Best Practices

1. **Never commit sensitive files:** Ensure `.gitignore` is properly configured
2. **Use different projects for different environments:** Separate Firebase projects for development, staging, and production
3. **Enable App Check:** Add an additional layer of security to your Firebase resources
4. **Configure Firestore Security Rules:** Properly secure your database
5. **Monitor usage:** Set up billing alerts and monitor API usage

## Troubleshooting

### Common Issues

1. **Build errors after configuration:**
   - Clean your project: `flutter clean && flutter pub get`
   - For iOS: `cd ios && rm Podfile.lock && pod install`

2. **Firebase not initializing:**
   - Ensure all configuration files are in the correct locations
   - Check that package names/bundle IDs match your Firebase project

3. **Authentication not working:**
   - Verify that authentication methods are enabled in Firebase Console
   - Check that OAuth 2.0 client IDs are properly configured

### Getting Help

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://docs.flutter.dev/)

## Important Notes

- Keep your Firebase configuration files secure and never share them publicly
- The example files in this repository contain placeholder values only
- Always use different Firebase projects for development and production
- Regularly review your Firebase security rules and access permissions
