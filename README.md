## Information
- App Name: Budget
- Language: Flutter (3.29.3)
- Java: 17
- Description: Budget is app for manage your money. Base on from transactions and the app not get information about Bank card and related it. It helps users calculate expenses every day, every week, etc.

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (3.29.3+)
- Java 17
- Firebase account

### 🔐 Firebase Configuration
This project requires Firebase configuration to run. For security reasons, the actual configuration files are not included in this repository.

**Quick Setup:**
1. See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions
2. Copy example configuration files and replace with your Firebase values:
   ```bash
   cp lib/firebase_options.dart.example lib/firebase_options.dart
   cp android/app/google-services.json.example android/app/google-services.json
   cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
   ```

**Or use FlutterFire CLI (Recommended):**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 🔑 Android Signing Setup (For Release Builds)
```bash
# Generate keystore
keytool -genkey -v -keystore android/app/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key

# Copy and configure key properties
cp android/key.properties.example android/key.properties
# Edit android/key.properties with your keystore details
```

### 📱 Installation
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```
## Document
- [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Complete Firebase configuration guide
- [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) - Security checklist for public repositories
- [flutter_facebook_auth](https://facebook.meedu.app/docs/4.x.x/intro)

## 🔒 Security Notice
This repository is configured for public sharing. All sensitive Firebase configuration files have been removed and replaced with example files. See the setup documentation for configuration instructions.

## CI/CD
fastlane add_plugin increment_version_code
- Play_store:
    - Tracks:
        - production: Deploys to Production
        - beta: Deploys to Open testing
        - alpha: Deploys to Closed testing
        - internal: Deploys to Internal testing

## Command
- Check lint: 
    ```
    dart run custom_lint
    ```
    ```
    dart run build_runner watch -d
    ```
- Rebuld text language
    ```
    dart run build_runner build
    ```
- Rebuild launch icon:
    ```
    flutter pub run flutter_launcher_icons
    ```
- Build abb:
    ```
    flutter build appbundle
    ```
### Chính sách quyền riêng tư
- [Chính sách](https://www.termsfeed.com/live/2d5f7165-d7ba-49b3-b191-6f3f94b412ac)
