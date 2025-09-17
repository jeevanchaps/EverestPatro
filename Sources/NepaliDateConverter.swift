import Foundation

struct NepaliDate {
    let year: Int
    let month: Int
    let day: Int
    
    var monthName: String {
        let monthNames = [
            "बैशाख", "जेठ", "आषाढ", "श्रावण", "भाद्र", "आश्विन",
            "कार्तिक", "मंसिर", "पौष", "माघ", "फाल्गुन", "चैत"
        ]
        return monthNames[month - 1]
    }
    
    var dayName: String {
        let dayNames = ["आइत", "सोम", "मङ्गल", "बुध", "बिहि", "शुक्र", "शनि"]
        let englishDate = NepaliDateConverter.shared.nepaliToEnglish(nepaliYear: year, nepaliMonth: month, nepaliDay: day)
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: englishDate) - 1
        return dayNames[weekday]
    }
    
    var formattedString: String {
        return "\(day) \(monthName)"
    }
    
    var fullFormattedString: String {
        return "\(dayName), \(day) \(monthName) \(String(year))"
    }
}

class NepaliDateConverter: ObservableObject {
    static let shared = NepaliDateConverter()
    
    // Nepali calendar data - days in each month for different years
    private let nepaliCalendarData: [Int: [Int]] = [
        2081: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30], // BS 2081 (2024-2025 AD)
        2082: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31], // BS 2082 (2025-2026 AD)
        2083: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31], // BS 2083 (2026-2027 AD)
        2084: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30], // BS 2084 (2027-2028 AD)
        2085: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30], // BS 2085 (2028-2029 AD)
        2086: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31], // BS 2086 (2029-2030 AD)
        2087: [30, 32, 31, 32, 31, 30, 30, 30, 29, 30, 29, 31], // BS 2087 (2030-2031 AD)
        2088: [31, 31, 32, 31, 31, 31, 30, 29, 30, 29, 30, 30], // BS 2088 (2031-2032 AD)
        2089: [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30], // BS 2089 (2032-2033 AD)
        2090: [31, 32, 31, 32, 31, 30, 30, 30, 29, 29, 30, 31]  // BS 2090 (2033-2034 AD)
    ]
    
    // Reference date: BS 2081/01/01 = AD 2024/04/13
    private let referenceNepaliDate = (year: 2081, month: 1, day: 1)
    private let referenceEnglishDate: Date = {
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(year: 2024, month: 4, day: 13))!
    }()
    
    func getCurrentNepaliDate() -> NepaliDate {
        let nepaliTimeZone = TimeZone(secondsFromGMT: 5 * 3600 + 45 * 60)! // UTC+5:45
        let today = Date()
        return englishToNepali(englishDate: today, timeZone: nepaliTimeZone)
    }
    
    func getCurrentEnglishDate() -> String {
        let nepaliTimeZone = TimeZone(secondsFromGMT: 5 * 3600 + 45 * 60)! // UTC+5:45
        let formatter = DateFormatter()
        formatter.timeZone = nepaliTimeZone
        formatter.dateFormat = "MMM d yyyy"
        return formatter.string(from: Date())
    }
    
    func englishToNepali(englishDate: Date, timeZone: TimeZone = TimeZone.current) -> NepaliDate {
        // Convert to Nepal time if timezone is provided
        let adjustedDate: Date
        if timeZone.secondsFromGMT() != TimeZone.current.secondsFromGMT() {
            let offset = timeZone.secondsFromGMT() - TimeZone.current.secondsFromGMT()
            adjustedDate = englishDate.addingTimeInterval(TimeInterval(offset))
        } else {
            adjustedDate = englishDate
        }
        
        let daysDifference = Calendar.current.dateComponents([.day], from: referenceEnglishDate, to: adjustedDate).day ?? 0
        
        var nepaliYear = referenceNepaliDate.year
        var nepaliMonth = referenceNepaliDate.month
        var nepaliDay = referenceNepaliDate.day + daysDifference
        
        // Adjust for negative days (going backwards)
        while nepaliDay <= 0 {
            nepaliMonth -= 1
            if nepaliMonth <= 0 {
                nepaliYear -= 1
                nepaliMonth = 12
            }
            nepaliDay += getDaysInNepaliMonth(year: nepaliYear, month: nepaliMonth)
        }
        
        // Adjust for excess days (going forwards)
        while nepaliDay > getDaysInNepaliMonth(year: nepaliYear, month: nepaliMonth) {
            nepaliDay -= getDaysInNepaliMonth(year: nepaliYear, month: nepaliMonth)
            nepaliMonth += 1
            if nepaliMonth > 12 {
                nepaliYear += 1
                nepaliMonth = 1
            }
        }
        
        return NepaliDate(year: nepaliYear, month: nepaliMonth, day: nepaliDay)
    }
    
    func nepaliToEnglish(nepaliYear: Int, nepaliMonth: Int, nepaliDay: Int) -> Date {
        var totalDays = 0
        
        // Calculate days from reference date
        if nepaliYear >= referenceNepaliDate.year {
            // Going forward
            for year in referenceNepaliDate.year..<nepaliYear {
                for month in 1...12 {
                    totalDays += getDaysInNepaliMonth(year: year, month: month)
                }
            }
            
            for month in 1..<nepaliMonth {
                totalDays += getDaysInNepaliMonth(year: nepaliYear, month: month)
            }
            
            totalDays += nepaliDay - referenceNepaliDate.day
        } else {
            // Going backward
            for year in nepaliYear..<referenceNepaliDate.year {
                for month in 1...12 {
                    totalDays -= getDaysInNepaliMonth(year: year, month: month)
                }
            }
            
            for month in nepaliMonth..<referenceNepaliDate.month {
                totalDays -= getDaysInNepaliMonth(year: referenceNepaliDate.year, month: month)
            }
            
            totalDays += nepaliDay - referenceNepaliDate.day
        }
        
        return Calendar.current.date(byAdding: .day, value: totalDays, to: referenceEnglishDate) ?? Date()
    }
    
    func getDaysInNepaliMonth(year: Int, month: Int) -> Int {
        guard let yearData = nepaliCalendarData[year], month >= 1 && month <= 12 else {
            // Default fallback for unknown years
            let defaultDays = [31, 31, 32, 32, 31, 30, 30, 29, 30, 29, 30, 30]
            return defaultDays[month - 1]
        }
        return yearData[month - 1]
    }
    
    func getCalendarDays(for nepaliYear: Int, month: Int) -> [[NepaliDate?]] {
        let daysInMonth = getDaysInNepaliMonth(year: nepaliYear, month: month)
        let firstDayOfMonth = nepaliToEnglish(nepaliYear: nepaliYear, nepaliMonth: month, nepaliDay: 1)
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        let startingWeekday = weekday == 1 ? 7 : weekday - 1 // Convert Sunday=1 to Sunday=7
        
        var weeks: [[NepaliDate?]] = []
        var currentWeek: [NepaliDate?] = Array(repeating: nil, count: 7)
        
        // Fill empty days at the beginning
        for i in 0..<(startingWeekday - 1) {
            currentWeek[i] = nil
        }
        
        // Fill the actual days
        var dayIndex = startingWeekday - 1
        for day in 1...daysInMonth {
            currentWeek[dayIndex] = NepaliDate(year: nepaliYear, month: month, day: day)
            dayIndex += 1
            
            if dayIndex == 7 {
                weeks.append(currentWeek)
                currentWeek = Array(repeating: nil, count: 7)
                dayIndex = 0
            }
        }
        
        // Add the last week if it has any days
        if dayIndex > 0 {
            weeks.append(currentWeek)
        }
        
        return weeks
    }
}
