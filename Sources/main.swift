/**
 * Nepali Calendar - macOS Menu Bar App
 * 
 * A beautiful macOS menu bar application that displays current Nepali date
 * with accurate Nepal timezone (UTC+5:45) and provides an elegant calendar popup.
 * 
 * Author: Nepali Calendar Team
 * License: MIT
 * Version: 1.0.0
 */

import SwiftUI
import AppKit
import Foundation

// Create a daemon-like app that runs independently of terminal
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// Set up the app to run in background mode (no dock icon)
app.setActivationPolicy(.accessory)

// Start the application loop
app.run()

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide the app from the dock
        NSApp.setActivationPolicy(.accessory)
        
        // Create menu bar controller
        menuBarController = MenuBarController()
    }
}
