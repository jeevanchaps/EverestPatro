#!/bin/bash

echo "🇳🇵 Nepali Calendar App Launcher"
echo "================================="

# Check if app is already running
if pgrep -f "NepaliCalendar" > /dev/null; then
    echo "✅ Nepali Calendar is already running in your menu bar!"
    echo "   Look for the Nepali date next to your system clock."
    echo "   Click on it to see the beautiful calendar popup."
    exit 0
fi

# Build if needed
if [ ! -f ".build/release/NepaliCalendar" ]; then
    echo "🔨 Building Nepali Calendar..."
    swift build --configuration release
fi

if [ -f ".build/release/NepaliCalendar" ]; then
    echo "🚀 Starting Nepali Calendar in background..."
    echo "   ✓ App will run independently (you can close this terminal)"
    echo "   ✓ Look for Nepali date in your menu bar"
    echo "   ✓ Click the date to see the beautiful calendar"
    echo "   ✓ App shows Nepal time (UTC+5:45)"
    echo ""
    
    # Run the app in background and detach from terminal
    nohup ./.build/release/NepaliCalendar > /dev/null 2>&1 &
    
    # Wait a moment to check if it started
    sleep 2
    
    if pgrep -f "NepaliCalendar" > /dev/null; then
        echo "✅ Nepali Calendar started successfully!"
        echo "   The app is now running in your menu bar."
        echo ""
        echo "To stop the app later:"
        echo "   pkill -f NepaliCalendar"
    else
        echo "❌ Failed to start the app."
    fi
else
    echo "❌ Build failed. Make sure you have Swift installed."
fi
