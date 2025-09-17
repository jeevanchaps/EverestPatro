#!/bin/bash

echo "🇳🇵 Nepali Calendar - macOS Installation Script"
echo "==============================================="
echo ""

# Check macOS version
MACOS_VERSION=$(sw_vers -productVersion | cut -d '.' -f 1,2)
REQUIRED_VERSION="14.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$MACOS_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
    echo "✅ macOS Version: $MACOS_VERSION (Compatible)"
else
    echo "❌ macOS Version: $MACOS_VERSION (Requires 14.0+)"
    exit 1
fi

# Check Swift availability
if command -v swift &> /dev/null; then
    SWIFT_VERSION=$(swift --version | head -1 | grep -o '[0-9]\+\.[0-9]\+' | head -1)
    echo "✅ Swift Version: $SWIFT_VERSION"
else
    echo "❌ Swift not found. Installing Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Command Line Tools installation and run this script again."
    exit 1
fi

# Make scripts executable
echo "🔧 Setting up executable permissions..."
chmod +x run-app.sh stop-app.sh

# Build the application
echo "🔨 Building Nepali Calendar..."
if swift build --configuration release; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi

echo ""
echo "🎉 Installation Complete!"
echo "========================"
echo ""
echo "🚀 To start the app:"
echo "   ./run-app.sh"
echo ""
echo "🛑 To stop the app:"
echo "   ./stop-app.sh"
echo ""
echo "📱 The app will appear in your menu bar showing the current Nepali date."
echo "   Click on it to see the beautiful calendar popup!"
echo ""
echo "⌨️  Press ESC to close the calendar or click outside."
echo "🏠 Click 'आज' to return to today's date."
echo ""
echo "🇳🇵 Enjoy your Nepali Calendar!"
