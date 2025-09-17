import SwiftUI
import AppKit

class MenuBarController: ObservableObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private let dateConverter = NepaliDateConverter.shared
    private var timer: Timer?
    
    init() {
        setupStatusItem()
        setupPopover()
        startTimer()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            updateStatusItemTitle()
            button.action = #selector(statusItemClicked)
            button.target = self
        }
    }
    
    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 400, height: 450)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.contentViewController = NSHostingController(rootView: CalendarView())
    }
    
    private func startTimer() {
        // Update every minute to keep the date current
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.updateStatusItemTitle()
        }
    }
    
    private func updateStatusItemTitle() {
        let currentNepaliDate = dateConverter.getCurrentNepaliDate()
        statusItem?.button?.title = currentNepaliDate.formattedString
    }
    
    @objc private func statusItemClicked() {
        guard let button = statusItem?.button, let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            // Update the calendar view with current date and close handler
            let calendarView = CalendarView { [weak self] in
                self?.popover?.performClose(nil)
            }
            popover.contentViewController = NSHostingController(rootView: calendarView)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
