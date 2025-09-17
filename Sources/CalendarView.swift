import SwiftUI

struct CalendarView: View {
    @StateObject private var dateConverter = NepaliDateConverter.shared
    @State private var displayedDate: NepaliDate
    @State private var currentTime: String = ""
    private let currentDate: NepaliDate
    private let currentEnglishDate: String
    let onClose: (() -> Void)?
    @State private var timer: Timer?
    
    init(onClose: (() -> Void)? = nil) {
        let current = NepaliDateConverter.shared.getCurrentNepaliDate()
        let englishDate = NepaliDateConverter.shared.getCurrentEnglishDate()
        self.currentDate = current
        self.currentEnglishDate = englishDate
        self.onClose = onClose
        self._displayedDate = State(initialValue: current)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section with dark background
            VStack(spacing: 16) {
                // Month/Year and navigation
                HStack {
                    // Left side: आज button
                    Button(action: goToToday) {
                        Text("आज")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Center: Time, Month and Year
                    VStack(spacing: 4) {
                        // Current time in Nepal timezone (centered)
                        Text(currentTime.isEmpty ? getCurrentNepalTime() : currentTime)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            Text(displayedDate.monthName)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text("-")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text(String(displayedDate.year))
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                        
                        // English month/year equivalent
                        Text(getEnglishMonthYear())
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Right side: Navigation arrows
                    HStack(spacing: 12) {
                        Button(action: previousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: nextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Day headers
                HStack {
                    ForEach(["आइत", "सोम", "मङ्गल", "बुध", "बिहि", "शुक्र", "शनि"], id: \.self) { day in
                        Text(day)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .background(Color.black)
            
            // Calendar grid with dark background
            VStack(spacing: 0) {
                let weeks = dateConverter.getCalendarDays(for: displayedDate.year, month: displayedDate.month)
                
                ForEach(0..<weeks.count, id: \.self) { weekIndex in
                    HStack(spacing: 0) {
                        ForEach(0..<7, id: \.self) { dayIndex in
                            if let date = weeks[weekIndex][dayIndex] {
                                DarkCalendarDayView(
                                    date: date,
                                    isCurrentDate: isCurrentDate(date),
                                    isToday: isToday(date),
                                    englishDate: getEnglishDateForNepali(date)
                                )
                            } else {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(maxWidth: .infinity, minHeight: 60)
                            }
                        }
                    }
                }
            }
            .background(Color.black)
        }
        .frame(width: 400, height: 450)
        .background(Color.black)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 8)
        .onAppear {
            updateTime()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            // Make the view focusable for key events
        }
        .focusable()
        .onKeyPress(.escape) {
            closeCalendar()
            return .handled
        }
    }
    
    private func getEnglishMonthYear() -> String {
        // Get the start and end dates of the Nepali month to find overlapping English months
        let startDate = dateConverter.nepaliToEnglish(nepaliYear: displayedDate.year, nepaliMonth: displayedDate.month, nepaliDay: 1)
        let endDay = dateConverter.getDaysInNepaliMonth(year: displayedDate.year, month: displayedDate.month)
        let endDate = dateConverter.nepaliToEnglish(nepaliYear: displayedDate.year, nepaliMonth: displayedDate.month, nepaliDay: endDay)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        let startMonth = formatter.string(from: startDate)
        let endMonth = formatter.string(from: endDate)
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let year = yearFormatter.string(from: startDate)
        
        if startMonth == endMonth {
            return "\(startMonth) - \(year)"
        } else {
            return "\(startMonth)/\(endMonth) - \(year)"
        }
    }
    
    private func getEnglishDateForNepali(_ nepaliDate: NepaliDate) -> Int {
        let englishDate = dateConverter.nepaliToEnglish(nepaliYear: nepaliDate.year, nepaliMonth: nepaliDate.month, nepaliDay: nepaliDate.day)
        let calendar = Calendar.current
        return calendar.component(.day, from: englishDate)
    }
    
    private func getCurrentNepalTime() -> String {
        let nepaliTimeZone = TimeZone(secondsFromGMT: 5 * 3600 + 45 * 60)! // UTC+5:45
        let formatter = DateFormatter()
        formatter.timeZone = nepaliTimeZone
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if displayedDate.month == 1 {
                displayedDate = NepaliDate(year: displayedDate.year - 1, month: 12, day: 1)
            } else {
                displayedDate = NepaliDate(year: displayedDate.year, month: displayedDate.month - 1, day: 1)
            }
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if displayedDate.month == 12 {
                displayedDate = NepaliDate(year: displayedDate.year + 1, month: 1, day: 1)
            } else {
                displayedDate = NepaliDate(year: displayedDate.year, month: displayedDate.month + 1, day: 1)
            }
        }
    }
    
    private func goToToday() {
        withAnimation(.easeInOut(duration: 0.3)) {
            displayedDate = currentDate
        }
    }
    
    private func closeCalendar() {
        onClose?()
    }
    
    private func updateTime() {
        currentTime = getCurrentNepalTime()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func isCurrentDate(_ date: NepaliDate) -> Bool {
        return date.year == displayedDate.year && date.month == displayedDate.month
    }
    
    private func isToday(_ date: NepaliDate) -> Bool {
        return date.year == currentDate.year && 
               date.month == currentDate.month && 
               date.day == currentDate.day
    }
}

struct DarkCalendarDayView: View {
    let date: NepaliDate
    let isCurrentDate: Bool
    let isToday: Bool
    let englishDate: Int
    @State private var isHovered = false
    
    var body: some View {
        VStack(spacing: 2) {
            // Nepali date (larger, main)
            Text("\(date.day)")
                .font(.title2)
                .fontWeight(isToday ? .bold : .medium)
                .foregroundColor(nepaliDateColor)
            
            // English date (smaller, below)
            Text("\(englishDate)")
                .font(.caption2)
                .foregroundColor(englishDateColor)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(backgroundColor)
        .overlay(
            // Blue rounded rectangle for today (like in the image)
            Group {
                if isToday {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.3))
                        )
                        .padding(4)
                }
            }
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var nepaliDateColor: Color {
        if isToday {
            return .white
        } else if isWeekend {
            return .red // Make Saturday dates bright red
        } else {
            return .white
        }
    }
    
    private var englishDateColor: Color {
        if isToday {
            return .white.opacity(0.8)
        } else if isWeekend {
            return .red.opacity(0.9) // Make Saturday English dates also more red
        } else {
            return .white.opacity(0.6)
        }
    }
    
    private var backgroundColor: Color {
        if isHovered {
            return Color.white.opacity(0.1)
        } else {
            return Color.black
        }
    }
    
    private var isWeekend: Bool {
        // Use the EXACT same logic as the calendar generation in NepaliDateConverter
        // This must match the getCalendarDays function
        
        let firstDayOfMonth = NepaliDateConverter.shared.nepaliToEnglish(nepaliYear: date.year, nepaliMonth: date.month, nepaliDay: 1)
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let startingWeekday = weekday == 1 ? 7 : weekday - 1 // Same conversion as calendar generation
        
        // Calculate the position of this date using same logic as calendar generation
        let daysSinceFirst = date.day - 1
        let dayIndex = (startingWeekday - 1 + daysSinceFirst) % 7
        
        // In the calendar generation:
        // startingWeekday - 1 gives us the starting position (0-6)
        // Our headers are: आइत(0), सोम(1), मङ्गल(2), बुध(3), बिहि(4), शुक्र(5), शनि(6)
        // So Saturday (शनि) should be at position 6
        
        return dayIndex == 6
    }
}

// Add small dots for special styling (like in the original image)
struct DotIndicator: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 4, height: 4)
    }
}