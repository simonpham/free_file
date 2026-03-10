#!/bin/bash

# ==============================================================================
# MacOS Build, Sign, Notarize, and Package Script for Free File
# ==============================================================================
#
# This script builds the Flutter application for macOS, signs it with the
# Hardened Runtime (required for notarization), packages it into a DMG,
# notarizes the DMG with Apple, and finally staples the notarization ticket.
#
# PREREQUISITES:
# 1. Xcode command line tools installed (`xcode-select --install`).
# 2. A valid "Developer ID Application" certificate in your Keychain.
# 3. An App Specific Password created at appleid.apple.com (if not using specific keychain profile).
#
# ENV VARIABLES REQUIRED:
# - SIGNING_IDENTITY : The name of your certificate, e.g., "Developer ID Application: Team Name (TeamID)"
#                      Run `security find-identity -v -p codesigning` to list available identities.
#
# NOTARIZATION AUTHENTICATION (Choose Option A or Option B):
#
# Option A (Recommended - Keychain Profile):
# - FREE_FILE_NOTARY_PROFILE : The name of the keychain profile created via `xcrun notarytool store-credentials`.
#                      Example: `xcrun notarytool store-credentials "AC_PROFILE" --apple-id "email@example.com" --team-id "TEAMID" --password "app-specific-password"`
#                      Then set FREE_FILE_NOTARY_PROFILE="AC_PROFILE".
#
# Option B (Direct Credentials):
# - APPLE_ID         : Your Apple ID email address.
# - TEAM_ID          : Your Apple Team ID (10-character alphanumeric string).
# - APPLE_PASSWORD   : Your App Specific Password (NOT your normal Apple ID password).
#
# USAGE:
#   export SIGNING_IDENTITY="Developer ID Application: ..."
#   export FREE_FILE_NOTARY_PROFILE="MyProfile"
#   ./scripts/build_macos.sh
#
# ==============================================================================

set -e

# --- Configuration ---
PROJECT_ROOT=$(pwd)
APP_DIR="apps/ff_desktop"
BUILD_DIR="${PROJECT_ROOT}/${APP_DIR}/build/macos/Build/Products/Release"
APP_NAME="Free File.app"
DMG_NAME="Free File.dmg"
ENTITLEMENTS="apps/ff_desktop/macos/Runner/Release.entitlements"

# --- Colors for Output ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Starting macOS Build & Release Process for Free File${NC}"

# --- Checks ---
if [ -z "$SIGNING_IDENTITY" ]; then
    echo -e "${RED}Error: SIGNING_IDENTITY environment variable is not set.${NC}"
    echo "Please export SIGNING_IDENTITY=\"Developer ID Application: Your Name (ID)\""
    exit 1
fi

if [ -z "$FREE_FILE_NOTARY_PROFILE" ] && { [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APPLE_PASSWORD" ]; }; then
    echo -e "${RED}Error: Notarization credentials missing.${NC}"
    echo "Please set FREE_FILE_NOTARY_PROFILE (recommended) OR set APPLE_ID, TEAM_ID, and APPLE_PASSWORD."
    exit 1
fi

# --- 0. Pre-build Generation ---
echo -e "${GREEN}==> Running Pre-build Generation...${NC}"
chmod +x ./scripts/gen.sh
./scripts/gen.sh

# --- 1. Build ---
echo -e "${GREEN}==> Building Flutter App (Release Mode)...${NC}"
cd "$APP_DIR"
flutter build macos --release --no-tree-shake-icons

if [ ! -d "$BUILD_DIR/$APP_NAME" ]; then
    echo -e "${RED}Error: Build failed. Could not find $APP_NAME at $BUILD_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}Build successful.${NC}"

# --- 2. Prepare for Packaging (Copy to Staging) ---
echo -e "${GREEN}==> Copying App to Staging Directory...${NC}"
DMG_SRC_DIR="$PROJECT_ROOT/build/dmg_source"
rm -rf "$DMG_SRC_DIR"
mkdir -p "$DMG_SRC_DIR"
cp -R "$BUILD_DIR/$APP_NAME" "$DMG_SRC_DIR/"

# --- 3. Codesign (with Hardened Runtime) ---
echo -e "${GREEN}==> Signing '$APP_NAME' in Staging Area with Hardened Runtime...${NC}"

# Navigate to staging folder
cd "$DMG_SRC_DIR"

# 1. Clean up extended attributes (finder info, quarantine, etc.)
echo "Cleaning extended attributes..."
xattr -cr "$APP_NAME"

# 2. Remove existing signatures (crucial for re-signing)
echo "Removing existing signatures..."
find "$APP_NAME" -name "_CodeSignature" -exec rm -rf {} +

# 3. Sign ALL content in Frameworks/Plugins first (Inside-Out)
echo "Signing inner frameworks and dylibs..."

# Find all frameworks and dylibs inside the app bundle
find "$APP_NAME/Contents" -mindepth 1 \( -name "*.framework" -o -name "*.dylib" \) | sort -r | while read -r BINARY; do
    echo "  Signing: $BINARY"
    codesign --force --verbose --options runtime --timestamp \
        --sign "$SIGNING_IDENTITY" \
        "$BINARY"
done

# 4. Sign the main Application bundle
echo "Signing app bundle..."
codesign --force --verbose --options runtime --timestamp \
    --entitlements "$PROJECT_ROOT/$ENTITLEMENTS" \
    --sign "$SIGNING_IDENTITY" \
    "$APP_NAME"

# Verify signature
echo -e "${YELLOW}Verifying signature...${NC}"
codesign --verify --verbose --strict "$APP_NAME"
echo -e "${GREEN}Signing complete and verified.${NC}"

# Go back to project root
cd "$PROJECT_ROOT"

# --- 4. Create DMG ---
echo -e "${GREEN}==> Creating DMG package...${NC}"
# Remove existing DMG if any
if [ -f "$PROJECT_ROOT/$DMG_NAME" ]; then
    rm "$PROJECT_ROOT/$DMG_NAME"
fi

# Add a link to Applications folder into the staging area
ln -s /Applications "$DMG_SRC_DIR/Applications"

# Create DMG using hdiutil
hdiutil create -volname "Free File" \
    -srcfolder "$DMG_SRC_DIR" \
    -ov -format UDZO \
    "$PROJECT_ROOT/$DMG_NAME"

echo -e "${GREEN}DMG created at $PROJECT_ROOT/$DMG_NAME${NC}"

# --- 5. Notarize ---
echo -e "${GREEN}==> Uploading DMG for Notarization (this may take a while)...${NC}"

if [ -n "$FREE_FILE_NOTARY_PROFILE" ]; then
    xcrun notarytool submit "$PROJECT_ROOT/$DMG_NAME" \
        --keychain-profile "$FREE_FILE_NOTARY_PROFILE" \
        --wait
else
    xcrun notarytool submit "$PROJECT_ROOT/$DMG_NAME" \
        --apple-id "$APPLE_ID" \
        --password "$APPLE_PASSWORD" \
        --team-id "$TEAM_ID" \
        --wait
fi

echo -e "${GREEN}Notarization submission finished.${NC}"

# --- 5. Staple ---
echo -e "${GREEN}==> Stapling the ticket to the DMG...${NC}"
xcrun stapler staple "$PROJECT_ROOT/$DMG_NAME"

echo -e "${GREEN}==> SUCCESS! Distribution-ready DMG is available at:${NC}"
echo "$PROJECT_ROOT/$DMG_NAME"
