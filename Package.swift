// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NepaliCalendar",
    platforms: [
        .macOS(.v14) // Requires macOS Sonoma or later
    ],
    products: [
        // Executable product for the Nepali Calendar menu bar app
        .executable(
            name: "NepaliCalendar",
            targets: ["NepaliCalendar"]
        ),
    ],
    dependencies: [
        // No external dependencies - pure Swift/SwiftUI implementation
    ],
    targets: [
        // Main executable target
        .executableTarget(
            name: "NepaliCalendar",
            dependencies: [],
            path: "Sources",
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        ),
    ]
)
