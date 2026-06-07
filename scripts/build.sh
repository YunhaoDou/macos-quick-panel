#!/bin/bash
# Build script for QuickPanel macOS app
# Usage: ./scripts/build.sh [--release]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="QuickPanel"

BUILD_MODE="${1:-debug}"
if [ "$BUILD_MODE" = "--release" ]; then
    CONFIG="release"
    BUILD_FLAG="-c release"
else
    CONFIG="debug"
    BUILD_FLAG=""
fi

echo "📦 Building $APP_NAME ($CONFIG)..."

cd "$PROJECT_DIR"

# Build with SwiftPM
swift build $BUILD_FLAG

# Determine binary path
BIN_DIR=$(swift build $BUILD_FLAG --show-bin-path 2>/dev/null || echo ".build/$CONFIG")
BINARY_PATH="$BIN_DIR/$APP_NAME"
echo "✅ Build complete. Binary at: $BINARY_PATH"

# Create .app bundle
APP_BUNDLE="$PROJECT_DIR/dist/$APP_NAME.app"
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copy binary
cp "$BINARY_PATH" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# Copy Info.plist
cp "$PROJECT_DIR/Info.plist" "$APP_BUNDLE/Contents/"

# Copy assets
if [ -d "$PROJECT_DIR/Sources/QuickPanel/Assets.xcassets" ]; then
    cp -r "$PROJECT_DIR/Sources/QuickPanel/Assets.xcassets" "$APP_BUNDLE/Contents/Resources/"
fi

# Set bundle identifier
/usr/libexec/PlistBuddy -c "Set CFBundleExecutable $APP_NAME" "$APP_BUNDLE/Contents/Info.plist" 2>/dev/null || true

echo "✅ App bundle created at: $APP_BUNDLE"

# Code sign (ad-hoc) for local use
codesign --force --deep --sign - "$APP_BUNDLE" 2>/dev/null || true

echo ""
echo "🎉 Done! Run with:"
echo "   open \"$APP_BUNDLE\""
echo ""
echo "Or from Terminal:"
echo "   $APP_BUNDLE/Contents/MacOS/$APP_NAME &"
