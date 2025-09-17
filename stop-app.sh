#!/bin/bash

echo "🛑 Stopping Nepali Calendar App"
echo "==============================="

if pgrep -f "NepaliCalendar" > /dev/null; then
    pkill -f "NepaliCalendar"
    echo "✅ Nepali Calendar app stopped successfully."
    echo "   The app has been removed from your menu bar."
else
    echo "ℹ️  Nepali Calendar app is not currently running."
fi
