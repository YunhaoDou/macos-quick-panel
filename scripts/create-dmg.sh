#!/bin/bash
# Create a macOS DMG installer for QuickPanel
# Usage: bash scripts/create-dmg.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="QuickPanel"
APP_PATH="$PROJECT_DIR/dist/$APP_NAME.app"
DMG_NAME="${APP_NAME}-v1.1.0"
DMG_PATH="$PROJECT_DIR/dist/$DMG_NAME.dmg"
STAGING_DIR="/tmp/${APP_NAME}_dmg"

echo "📀 Creating DMG for $APP_NAME..."

# Ensure .app exists
if [ ! -d "$APP_PATH" ]; then
    echo "❌ $APP_PATH not found. Run scripts/build.sh first."
    exit 1
fi

# Clean staging
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"

# Copy .app into staging
cp -R "$APP_PATH" "$STAGING_DIR/$APP_NAME.app"

# Create a symlink to /Applications for drag-and-drop
ln -s /Applications "$STAGING_DIR/Applications"

# Create DMG
echo "📦 Creating DMG..."
rm -f "$DMG_PATH"

hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov -format UDZO \
    -fs HFS+ \
    -imagekey zlib-level=9 \
    "$DMG_PATH" 2>&1

# Clean up
rm -rf "$STAGING_DIR"

DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)
echo "✅ DMG created: $DMG_PATH ($DMG_SIZE)"

echo ""
echo "🎉 Done! Upload to GitHub Release:"
echo "   $DMG_PATH"
