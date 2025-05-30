#!/bin/zsh

# Script to create a DMG for Base64 app

APP_NAME="Base64"
APP_PATH="./Base64.app"
DMG_NAME="$APP_NAME.dmg"
DMG_BACKGROUND="./scripts/dmg-resources/background.png"
DMG_ICON="$APP_PATH/Contents/Resources/AppIconMacOS.icns"

# Ensure we have create-dmg installed
if ! command -v create-dmg &> /dev/null
then
    echo "create-dmg is not installed. Installing via Homebrew..."
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi

    brew install create-dmg
fi

if [ -f $DMG_NAME ]
then
    echo "Removing existing DMG file $DMG_NAME..."
    rm $DMG_NAME
fi

if [ ! -d $APP_PATH ]
then
    echo "Error: $APP_PATH does not exist. Please build the app first."
    exit 1
fi

if [ ! -f $DMG_BACKGROUND ]
then
    echo "Error: Background image $DMG_BACKGROUND does not exist."
    exit 1
fi

if [ ! -f $DMG_ICON ]
then
    echo "Error: Icon file $DMG_ICON does not exist."
    exit 1
fi

echo "Creating DMG for $APP_NAME..."
create-dmg \
    --volname $APP_NAME \
    --volicon $DMG_ICON \
    --background $DMG_BACKGROUND \
    --window-pos 200 120 \
    --window-size 800 500 \
    --icon-size 128 \
    --icon "$APP_NAME.app" 200 250 \
    --app-drop-link 600 250 \
    --no-internet-enable \
    $DMG_NAME \
    $APP_PATH

if [ $? -eq 0 ]
then
    echo "DMG created successfully: $APP_NAME.dmg"
else
    echo "Error creating DMG"
    exit 1
fi

echo "Done!"
