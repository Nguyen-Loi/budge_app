# CI/CD Setup for Flutter Web with Firebase Hosting

This repository contains GitHub Actions workflows for automated deployment of the Flutter web application to Firebase Hosting.

## Workflows

### 1. Web Deploy (`web-deploy.yml`)

Automatically builds and deploys your Flutter web app to Firebase Hosting when changes are pushed to `main` or `develop` branches, or when pull requests are created.

#### Features:
- **Automated Testing**: Runs Flutter tests and code analysis
- **Performance Optimized**: Uses caching for Flutter dependencies
- **Preview Deployments**: Creates preview deployments for pull requests
- **Production Deployments**: Deploys to production on main branch
- **Auto Tagging**: Creates Git tags for production releases
- **PR Comments**: Automatically comments on PRs with preview URLs
- **Performance Monitoring**: Runs Lighthouse CI for performance checks

#### Triggers:
- Push to `main` or `develop` branch
- Pull requests to `main` branch

### 2. Android Deploy (`android-deploy.yml`)

Builds and deploys Android app to Google Play Store (existing workflow).

## Required Secrets

To use these workflows, you need to set up the following secrets in your GitHub repository:

### For Web Deployment:
1. **`FIREBASE_TOKEN`**: Firebase CLI token for deployment
   ```bash
   # Generate the token locally
   firebase login:ci
   ```

### For Android Deployment (existing):
- `KEYSTORE_BASE64`
- `GOOGLE_PLAY_JSON`
- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`

## Setup Instructions

### 1. Firebase Token Setup

1. Install Firebase CLI locally:
   ```bash
   npm install -g firebase-tools
   ```

2. Login and generate a CI token:
   ```bash
   firebase login:ci
   ```

3. Copy the generated token and add it as a GitHub secret named `FIREBASE_TOKEN`

### 2. GitHub Secrets Configuration

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the `FIREBASE_TOKEN` secret

### 3. Firebase Project Configuration

Ensure your Firebase project is properly configured:

- **Project ID**: `budget-ss` (already configured in `.firebaserc`)
- **Hosting**: Configured to serve from `build/web` directory
- **Web app**: Registered with Firebase project

## Deployment Process

### Production Deployment (main branch)
1. Push changes to `main` branch
2. GitHub Actions automatically:
   - Runs tests and analysis
   - Builds Flutter web app
   - Deploys to Firebase Hosting
   - Creates a Git tag
   - Runs Lighthouse performance tests

### Preview Deployment (Pull Requests)
1. Create a pull request to `main`
2. GitHub Actions automatically:
   - Runs tests and analysis
   - Builds Flutter web app
   - Deploys preview to Firebase Hosting
   - Comments on PR with preview URL

## Performance Monitoring

The workflow includes Lighthouse CI for performance monitoring with the following thresholds:
- **Performance**: Warning if score < 80%
- **Accessibility**: Error if score < 90%
- **Best Practices**: Warning if score < 80%
- **SEO**: Warning if score < 80%

## File Structure

```
.github/workflows/
├── android-deploy.yml    # Android deployment workflow
└── web-deploy.yml        # Web deployment workflow

firebase.json             # Firebase hosting configuration
.firebaserc              # Firebase project configuration
lighthouserc.json        # Lighthouse CI configuration
```

## URLs

- **Production**: https://budget-ss.web.app
- **Firebase Console**: https://console.firebase.google.com/project/budget-ss

## Troubleshooting

### Common Issues:

1. **Firebase Token Expired**
   - Regenerate token: `firebase login:ci`
   - Update GitHub secret

2. **Build Failures**
   - Check Flutter version compatibility
   - Ensure all dependencies are properly cached

3. **Deployment Failures**
   - Verify Firebase project permissions
   - Check hosting configuration in `firebase.json`

### Logs and Monitoring:
- GitHub Actions logs: Repository → Actions tab
- Firebase Hosting logs: Firebase Console → Hosting section
- Lighthouse reports: Available in Actions artifacts

## Manual Deployment

To deploy manually from local machine:

```bash
# Build the web app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting
```
