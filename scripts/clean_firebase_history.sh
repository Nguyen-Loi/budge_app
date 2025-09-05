#!/bin/bash

# Git History Cleaning Script for Firebase Configuration Files
# This script removes sensitive Firebase configuration files from ALL branches and commit history

set -e

echo "🔥 Firebase Configuration History Cleanup Script"
echo "=================================================="
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
echo "🧹 Starting cleanup process..."

# Get all branches
echo "📋 Fetching all branches..."
git fetch --all

# List of files to remove
FILES_TO_REMOVE=(
    "lib/firebase_options.dart"
    "android/app/google-services.json"
    "ios/Runner/GoogleService-Info.plist"
    "android/key.properties"
    "android/app/key.jks"
    "android/play-account.json"
    "ios/firebase_app_id_file.json"
)

# Create filter-branch command
FILTER_COMMAND="git rm --cached --ignore-unmatch"
for file in "${FILES_TO_REMOVE[@]}"; do
    FILTER_COMMAND="$FILTER_COMMAND '$file'"
done

echo "🔍 Removing files from ALL branches and commit history..."
echo "Command: git filter-branch --force --index-filter \"$FILTER_COMMAND\" --prune-empty --tag-name-filter cat -- --all"

# Execute the filter-branch command
eval "git filter-branch --force --index-filter \"$FILTER_COMMAND\" --prune-empty --tag-name-filter cat -- --all"

echo ""
echo "🗑️  Cleaning up references..."
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo ""
echo "📝 Adding .gitignore rules..."
# Ensure .gitignore has the proper rules (this should already be done by the setup)
if ! grep -q "lib/firebase_options.dart" .gitignore; then
    echo "lib/firebase_options.dart" >> .gitignore
fi

echo ""
echo "✅ Cleanup completed successfully!"
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
echo "🔍 Verification - checking if sensitive files still exist in history..."
for file in "${FILES_TO_REMOVE[@]}"; do
    if git log --all --follow --name-only --pretty=format: -- "$file" | grep -q "$file"; then
        echo "⚠️  Warning: $file may still exist in history"
    else
        echo "✅ $file successfully removed from history"
    fi
done

echo ""
echo "🎉 All done! Your repository is now safe for public sharing."
