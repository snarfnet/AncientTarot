import SwiftUI

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Date Extensions
extension Date {
    var dayOfYear: Int { Calendar.current.ordinality(of: .day, in: .year, for: self) ?? 1 }
    var year: Int { Calendar.current.component(.year, from: self) }
    var month: Int { Calendar.current.component(.month, from: self) }
    var day: Int { Calendar.current.component(.day, from: self) }

    var zodiacSign: String {
        let m = month, d = day
        switch (m, d) {
        case (3, 21...31), (4, 1...19): return "aries"
        case (4, 20...30), (5, 1...20): return "taurus"
        case (5, 21...31), (6, 1...20): return "gemini"
        case (6, 21...30), (7, 1...22): return "cancer"
        case (7, 23...31), (8, 1...22): return "leo"
        case (8, 23...31), (9, 1...22): return "virgo"
        case (9, 23...30), (10, 1...22): return "libra"
        case (10, 23...31), (11, 1...21): return "scorpio"
        case (11, 22...30), (12, 1...21): return "sagittarius"
        case (12, 22...31), (1, 1...19): return "capricorn"
        case (1, 20...31), (2, 1...18): return "aquarius"
        case (2, 19...29), (3, 1...20): return "pisces"
        default: return "aries"
        }
    }

    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }

    /// Approximate lunar day (1-29) using simple calculation
    var lunarDay: Int {
        // Known new moon: Jan 6, 2000
        let reference = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 6))!
        let days = Calendar.current.dateComponents([.day], from: reference, to: self).day ?? 0
        let cycle = 29.53059
        let phase = Double(days).truncatingRemainder(dividingBy: cycle)
        return max(1, min(29, Int(phase) + 1))
    }

    var lunarPhaseName: String {
        let d = lunarDay
        switch d {
        case 1: return "新月"
        case 2...7: return "三日月（上弦へ）"
        case 8: return "上弦の月"
        case 9...14: return "十三夜（満月へ）"
        case 15: return "満月"
        case 16...21: return "十六夜（下弦へ）"
        case 22: return "下弦の月"
        case 23...29: return "二十六夜（新月へ）"
        default: return "新月"
        }
    }

    var lunarPhaseEmoji: String {
        let d = lunarDay
        switch d {
        case 1: return "🌑"
        case 2...4: return "🌒"
        case 5...7: return "🌓"
        case 8...10: return "🌔"
        case 11...14: return "🌕"
        case 15: return "🌕"
        case 16...18: return "🌖"
        case 19...21: return "🌗"
        case 22...25: return "🌘"
        case 26...29: return "🌑"
        default: return "🌑"
        }
    }
}

// View modifiers are in TarotComponents.swift

// MARK: - Seeded RNG
struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
