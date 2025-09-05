#!/bin/bash

# Script to add example files to all branches
echo "📋 Adding example files to all branches..."

# Store current branch
CURRENT_BRANCH=$(git branch --show-current)

# List of example files to copy
EXAMPLE_FILES=(
    "lib/firebase_options.dart.example"
    "android/app/google-services.json.example"
    "ios/Runner/GoogleService-Info.plist.example"
    "android/key.properties.example"
    "android/play-account.json.example"
)

# Documentation files to copy
DOC_FILES=(
    "FIREBASE_SETUP.md"
    "SECURITY_CHECKLIST.md"
    "REPOSITORY_READY.md"
    "scripts/clean_firebase_history.sh"
    "scripts/clean_firebase_history_bfg.sh"
    "scripts/verify_all_branches.sh"
)

echo "📁 Files to be added to each branch:"
for file in "${EXAMPLE_FILES[@]}" "${DOC_FILES[@]}"; do
    echo "   - $file"
done
echo ""

# Function to add files to a branch
add_files_to_branch() {
    local branch="$1"
    echo "🌿 Processing branch: $branch"
    
    # Switch to branch
    git checkout "$branch" -q
    
    # Check if files already exist
    local files_added=0
    
    # Copy example files
    for file in "${EXAMPLE_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            git checkout feature/merge-data-account -- "$file" 2>/dev/null && {
                echo "   ✅ Added: $file"
                files_added=$((files_added + 1))
            }
        else
            echo "   ⏭️  Already exists: $file"
        fi
    done
    
    # Copy documentation files
    for file in "${DOC_FILES[@]}"; do
        if [ ! -f "$file" ]; then
            git checkout feature/merge-data-account -- "$file" 2>/dev/null && {
                echo "   ✅ Added: $file"
                files_added=$((files_added + 1))
            }
        else
            echo "   ⏭️  Already exists: $file"
        fi
    done
    
    # Commit changes if any files were added
    if [ $files_added -gt 0 ]; then
        git add .
        git commit -m "feat: add Firebase example files and security documentation

- Add example configuration files with placeholder values
- Add comprehensive setup and security documentation
- Prepare branch for safe public sharing

Files added:
$(for f in "${EXAMPLE_FILES[@]}" "${DOC_FILES[@]}"; do [ -f "$f" ] && echo "- $f"; done)"
        echo "   🎉 Committed $files_added files"
    else
        echo "   ℹ️  No changes needed"
    fi
    echo ""
}

# Get list of all local branches except current
BRANCHES=$(git branch | grep -v "^\*" | sed 's/^  //')

echo "🚀 Starting to process branches..."
echo ""

# Process each branch
for branch in $BRANCHES; do
    add_files_to_branch "$branch"
done

# Return to original branch
echo "🔄 Returning to original branch: $CURRENT_BRANCH"
git checkout "$CURRENT_BRANCH" -q

echo "✅ Complete! Example files added to all branches."
echo ""
echo "📤 Next step: Push all branches to remote"
echo "   git push --all"
