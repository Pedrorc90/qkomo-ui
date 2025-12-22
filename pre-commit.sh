#!/bin/bash
# Pre-commit hook for dart format
# To install: copy this file to .git/hooks/pre-commit and make it executable
# chmod +x .git/hooks/pre-commit

echo "Running dart format check..."

# Check if dart format would make changes
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Code formatting issues detected!"
    echo "Run 'dart format .' to fix formatting issues."
    exit 1
fi

echo "✅ Code formatting check passed!"
exit 0
