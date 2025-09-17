# Changelog

All notable changes to the Nepali Calendar macOS app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-09-17

### Added
- 🇳🇵 **Initial Release** - Complete Nepali Calendar for macOS
- ⏰ **Nepal Standard Time** - Accurate UTC+5:45 timezone support
- 📅 **Menu Bar Integration** - Clean Nepali date display in menu bar
- 🎨 **Dark Theme Calendar** - Beautiful black-themed calendar popup
- 🔴 **Weekend Highlighting** - Saturday (शनि) dates in red
- 🎯 **Today Highlighting** - Current date with blue rounded border
- 📊 **Dual Date System** - Nepali dates with English dates below
- ⬅️➡️ **Month Navigation** - Smooth previous/next month buttons
- 🏠 **Today Button** - "आज" button to jump to current month
- ⌨️ **ESC Key Support** - Press ESC to close calendar popup
- 🚀 **Background Operation** - Runs independently of terminal
- 🔄 **Auto Updates** - Menu bar refreshes every minute
- 📱 **Live Time Display** - Real-time Nepal time in calendar header
- 🗓️ **Smart Month Display** - Shows overlapping English months (e.g., "Sep/Oct")

### Technical Features
- **Swift Package Manager** - Modern build system
- **SwiftUI** - Native macOS UI framework
- **Accurate Date Conversion** - BS 2081-2090 (AD 2024-2034) support
- **Memory Efficient** - ~10MB RAM usage
- **Easy Scripts** - `run-app.sh` and `stop-app.sh` for convenience

### Calendar Data
- **Years Supported**: 2081-2090 BS (Bikram Sambat)
- **Months**: All 12 Nepali months with accurate day counts
- **Variable Lengths**: Proper handling of 29-32 day months
- **Leap Years**: Accurate Nepali calendar leap year handling

### User Experience
- **Intuitive Interface** - Clean, modern design
- **Keyboard Shortcuts** - ESC to close
- **Mouse Interaction** - Click anywhere outside to close
- **Visual Feedback** - Hover effects and smooth animations
- **Accessibility** - Works with macOS accessibility features

## [Unreleased]

### Planned Features
- 🌅 **Light Theme** - Alternative light color scheme
- 🎉 **Festival Dates** - Nepali festivals and holidays
- 🔔 **Notifications** - Daily date change notifications
- 🌍 **More Years** - Extended calendar data beyond 2090 BS
- 🎨 **Custom Themes** - User-configurable color schemes
- 📱 **Widget Support** - macOS widget integration
- 🌐 **Localization** - Multiple Nepali script variants

### Known Issues
- None reported in v1.0.0

---

## Version History

- **v1.0.0** (2024-09-17) - Initial release with full feature set
- **Development** (2024-09-16) - Private development and testing

## Contributing

See [README.md](README.md#contributing) for contribution guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
