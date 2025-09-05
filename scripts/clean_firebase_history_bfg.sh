#!/bin/bash

# Alternative Git History Cleaning Script using BFG Repo-Cleaner
# BFG is faster and more efficient than git filter-branch for large repositories

set -e

echo "🚀 Firebase Configuration History Cleanup Script (BFG Method)"
echo "============================================================="
echo "ℹ️  This script uses BFG Repo-Cleaner for faster and more efficient cleanup"
echo ""

# Check if BFG is installed
if ! command -v bfg &> /dev/null; then
    echo "❌ BFG Repo-Cleaner not found!"
    echo "📥 Install BFG using one of these methods:"
    echo ""
    echo "🍺 Homebrew (macOS/Linux):"
    echo "   brew install bfg"
    echo ""
    echo "☕ Direct download:"
    echo "   wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar"
    echo "   alias bfg='java -jar bfg-1.14.0.jar'"
    echo ""
    echo "🔗 More info: https://rtyley.github.io/bfg-repo-cleaner/"
    exit 1
fi

echo "⚠️  WARNING: This will permanently remove sensitive files from ALL branches and commit history!"
echo "📋 Files to be removed:"
echo "   - lib/firebase_options.dart"
echo "   - android/app/google-services.json"
echo "   - ios/Runner/GoogleService-Info.plist"
echo "   - android/key.properties"
echo "   - android/app/key.jks"
echo "   - android/play-account.json"
echo "   - ios/firebase_app_id_file.json"
echo ""

read -p "❓ Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Operation cancelled."
    exit 1
fi

echo "📦 Creating backup of current repository..."
BACKUP_DIR="../$(basename $(pwd))_backup_$(date +%Y%m%d_%H%M%S)"
cp -r . "$BACKUP_DIR"
echo "✅ Backup created at: $BACKUP_DIR"

echo ""
echo "🧹 Starting BFG cleanup process..."

# Create a temporary file list for BFG
TEMP_FILE=$(mktemp)
cat > "$TEMP_FILE" << EOF
firebase_options.dart
google-services.json
GoogleService-Info.plist
key.properties
key.jks
play-account.json
firebase_app_id_file.json
EOF

echo "🔍 Removing files using BFG Repo-Cleaner..."
bfg --delete-files "$TEMP_FILE" --no-blob-protection .

echo ""
echo "🗑️  Cleaning up references..."
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Clean up temp file
rm "$TEMP_FILE"

echo ""
echo "✅ BFG cleanup completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. 🔧 Set up Firebase configuration using FIREBASE_SETUP.md"
echo "2. 📤 Force push to update remote repository:"
echo "   git push --force --all"
echo "   git push --force --tags"
echo ""
echo "⚠️  Note: Force push will rewrite history on remote. Coordinate with your team!"
echo "💾 Backup location: $BACKUP_DIR"
echo ""
echo "🎉 All done! Your repository is now safe for public sharing."
