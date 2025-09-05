#!/bin/bash

# Branch Verification Script - Check all branches for sensitive files
# This script helps verify that sensitive files are removed from all branches

echo "🔍 Comprehensive Branch Security Verification"
echo "=============================================="

# Array of sensitive files to check
SENSITIVE_FILES=(
    "lib/firebase_options.dart"
    "android/app/google-services.json"
    "ios/Runner/GoogleService-Info.plist" 
    "android/key.properties"
    "android/app/key.jks"
    "android/play-account.json"
    "ios/firebase_app_id_file.json"
)

echo "📋 Files being checked:"
for file in "${SENSITIVE_FILES[@]}"; do
    echo "   - $file"
done
echo ""

# Check current branch first
echo "🎯 Current branch: $(git branch --show-current)"
echo "📍 Current commit: $(git rev-parse HEAD)"
echo ""

# Function to check files in a branch
check_branch() {
    local branch="$1"
    local commit_hash="$2"
    
    echo "🔍 Checking branch: $branch ($commit_hash)"
    
    # Check if any sensitive files exist
    local found_files=0
    for file in "${SENSITIVE_FILES[@]}"; do
        if git ls-tree -r --name-only "$commit_hash" | grep -q "^$file$"; then
            echo "   ⚠️  FOUND: $file"
            found_files=$((found_files + 1))
        fi
    done
    
    if [ $found_files -eq 0 ]; then
        echo "   ✅ Clean - No sensitive files found"
    else
        echo "   ❌ $found_files sensitive file(s) found!"
    fi
    echo ""
}

# Check all local branches
echo "🌿 Checking Local Branches:"
echo "----------------------------"
while IFS= read -r branch; do
    branch_name=$(echo "$branch" | sed 's/^..//' | sed 's/^remotes\/origin\///')
    if [[ "$branch" == *"* "* ]]; then
        # Current branch
        branch_name=$(echo "$branch" | sed 's/^\* //')
        commit_hash=$(git rev-parse HEAD)
    else
        # Other local branch
        branch_name=$(echo "$branch" | sed 's/^  //')
        if git show-ref --verify --quiet "refs/heads/$branch_name"; then
            commit_hash=$(git rev-parse "$branch_name")
        else
            continue
        fi
    fi
    
    if [[ "$branch_name" != *"origin/"* && "$branch_name" != "" ]]; then
        check_branch "$branch_name" "$commit_hash"
    fi
done < <(git branch)

# Check all remote branches
echo "🌐 Checking Remote Branches:"
echo "-----------------------------"
while IFS= read -r line; do
    commit_hash=$(echo "$line" | awk '{print $1}')
    ref=$(echo "$line" | awk '{print $2}')
    
    if [[ "$ref" == refs/heads/* ]]; then
        branch_name=$(echo "$ref" | sed 's|refs/heads/||')
        check_branch "origin/$branch_name" "$commit_hash"
    fi
done < <(git ls-remote origin)

echo "🔍 Historical Verification:"
echo "---------------------------"
echo "Checking if files appear anywhere in Git history..."

for file in "${SENSITIVE_FILES[@]}"; do
    echo -n "📁 $file: "
    if git log --all --follow --name-only --pretty=format: -- "$file" | grep -q "$file"; then
        echo "⚠️  Found in history (this shouldn't happen!)"
    else
        echo "✅ Not found in history"
    fi
done

echo ""
echo "🎯 Quick Commands to Verify:"
echo "----------------------------"
echo "# Check current working directory for sensitive files:"
echo "find . -name 'firebase_options.dart' -o -name 'google-services.json' -o -name 'GoogleService-Info.plist' -o -name 'key.properties' -o -name 'key.jks' -o -name 'play-account.json' 2>/dev/null | grep -v '/ios/Pods/'"
echo ""
echo "# Check if files exist in current Git tree:"
echo "git ls-tree -r --name-only HEAD | grep -E '(firebase_options\.dart|google-services\.json|GoogleService-Info\.plist|key\.properties|key\.jks|play-account\.json)'"
echo ""
echo "# Force refresh remote branches:"
echo "git fetch --all --prune"
echo "git remote prune origin"
echo ""

echo "✅ Verification complete!"
echo ""
echo "💡 If you're still seeing sensitive files:"
echo "   1. Clear your browser cache if viewing on GitHub"
echo "   2. Refresh your IDE/editor"
echo "   3. Run: git fetch --all --prune"
echo "   4. Check if you're looking at the right branch"
echo "   5. Verify you're looking at the latest commit"
