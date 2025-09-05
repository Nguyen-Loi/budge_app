# 🔒 Security Checklist for Public Repository

Before making your repository public, ensure you've completed all items in this checklist:

## ✅ Pre-Publication Security Checklist

### 🔥 Firebase Configuration
- [ ] Removed `lib/firebase_options.dart` from repository
- [ ] Removed `android/app/google-services.json` from repository  
- [ ] Removed `ios/Runner/GoogleService-Info.plist` from repository
- [ ] Removed `ios/firebase_app_id_file.json` from repository
- [ ] Created example files with placeholder values
- [ ] Updated `.gitignore` to prevent future commits of these files
- [ ] Ran history cleanup script to remove files from all branches and commit history

### 🔑 Android Signing & Deployment
- [ ] Removed `android/key.properties` from repository
- [ ] Removed `android/app/key.jks` (keystore file) from repository
- [ ] Removed `android/play-account.json` (Play Store service account) from repository
- [ ] Created example files for signing configuration
- [ ] Added signing files to `.gitignore`

### 🛡️ Environment Variables & Secrets
- [ ] Checked for `.env` files and added to `.gitignore`
- [ ] Removed any hardcoded API keys from source code
- [ ] Removed any hardcoded passwords or tokens
- [ ] Checked for any service account JSON files
- [ ] Verified no database URLs or connection strings are exposed

### 📚 Documentation
- [ ] Created `FIREBASE_SETUP.md` with setup instructions
- [ ] Updated `README.md` with security setup instructions
- [ ] Added clear instructions for new developers
- [ ] Documented all required environment variables
- [ ] Added troubleshooting section

### 🔍 Code Review
- [ ] Searched codebase for hardcoded credentials: `grep -r "password\|secret\|key\|token" lib/`
- [ ] Searched for API endpoints that might contain sensitive data
- [ ] Reviewed all configuration files in root directory
- [ ] Checked for any database exports or backups
- [ ] Verified no test data contains real user information

### 🗂️ File System Check
Run these commands to double-check for sensitive files:
```bash
# Find potential sensitive files
find . -name "*.json" -o -name "*.plist" -o -name "*.p12" -o -name "*.jks" | grep -v example

# Check for environment files
find . -name ".env*" -o -name "secrets*"

# Look for certificate files
find . -name "*.cer" -o -name "*.crt" -o -name "*.p12"
```

### 🌐 Git History Verification
- [ ] Ran `git log --all --follow --name-only --pretty=format: -- lib/firebase_options.dart` (should return empty)
- [ ] Ran `git log --all --follow --name-only --pretty=format: -- android/app/google-services.json` (should return empty)
- [ ] Ran `git log --all --follow --name-only --pretty=format: -- ios/Runner/GoogleService-Info.plist` (should return empty)
- [ ] Verified sensitive files don't appear in any branch: `git ls-tree -r --name-only HEAD | grep -E "(firebase_options\.dart|google-services\.json|GoogleService-Info\.plist)"`

### 📤 Repository Settings
- [ ] Updated repository description to mention it's a Flutter budget app
- [ ] Added appropriate topics/tags (flutter, dart, firebase, budget, mobile)
- [ ] Configured branch protection rules if needed
- [ ] Set up appropriate issue templates
- [ ] Configured security advisories settings

### 🚀 Final Steps
- [ ] Created a test Firebase project for public demo
- [ ] Verified the app builds successfully with example configuration
- [ ] Tested the setup instructions with a fresh clone
- [ ] Force pushed all branches to remote: `git push --force --all`
- [ ] Force pushed all tags to remote: `git push --force --tags`

## 🚨 Emergency Procedures

If you accidentally commit sensitive data:

1. **Immediate Response:**
   ```bash
   # Stop any CI/CD pipelines
   # Revoke any exposed API keys/tokens immediately
   ```

2. **Clean History:**
   ```bash
   # Use the provided cleanup scripts
   ./scripts/clean_firebase_history.sh
   # OR
   ./scripts/clean_firebase_history_bfg.sh
   ```

3. **Update Remote:**
   ```bash
   git push --force --all
   git push --force --tags
   ```

4. **Rotate Credentials:**
   - Generate new Firebase API keys
   - Create new service account files
   - Update all deployment systems

## 📞 Support

If you need help with any security-related issues:
- Review [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
- Check [Flutter Firebase Documentation](https://firebase.flutter.dev/)
- Review [Git History Rewriting Guide](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

---

**Remember:** Security is an ongoing process. Regularly review your repository for new sensitive data and keep this checklist updated.
