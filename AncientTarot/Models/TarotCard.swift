import SwiftUI

struct TarotCard: Codable, Identifiable {
    let id: String
    let number: Int          // 0-21 for Major, 1-14 for Minor
    let nameJa: String
    let nameEn: String
    let arcana: String       // "major" or "minor"
    let suit: String?        // nil for Major; "wands","cups","swords","pentacles"
    let emoji: String
    let hebrewLetter: String?
    let hebrewMeaning: String?
    let planet: String?
    let zodiac: String?
    let element: String?
    let symbolism: String    // Waite's symbolism description (Japanese)
    let uprightJa: String    // Upright meaning
    let reversedJa: String   // Reversed meaning
    let uprightKeywords: [String]
    let reversedKeywords: [String]
    let papusInterpretation: String?   // Papus (1892)
    let waiteInterpretation: String?   // Waite (1911)
    let ouspenskyInterpretation: String? // Ouspensky
    let historicalQuote: String
    let quoteSource: String
    let color: String        // hex
}

struct TarotSpread: Identifiable {
    let id: String
    let nameJa: String
    let nameEn: String
    let description: String
    let cardCount: Int
    let positions: [SpreadPosition]
}

struct SpreadPosition: Identifiable {
    let id: Int
    let nameJa: String
    let description: String
}

struct DrawnCard: Identifiable {
    let id = UUID()
    let card: TarotCard
    let isReversed: Bool
    let position: SpreadPosition?
}

enum TarotSuit: String, CaseIterable {
    case wands = "wands"
    case cups = "cups"
    case swords = "swords"
    case pentacles = "pentacles"

    var nameJa: String {
        switch self {
        case .wands: return "ワンド（杖）"
        case .cups: return "カップ（杯）"
        case .swords: return "ソード（剣）"
        case .pentacles: return "ペンタクル（金貨）"
        }
    }

    var element: String {
        switch self {
        case .wands: return "火"
        case .cups: return "水"
        case .swords: return "風"
        case .pentacles: return "地"
        }
    }

    var emoji: String {
        switch self {
        case .wands: return "🪄"
        case .cups: return "🏆"
        case .swords: return "⚔️"
        case .pentacles: return "🪙"
        }
    }

    var color: String {
        switch self {
        case .wands: return "#E85D04"
        case .cups: return "#4361EE"
        case .swords: return "#ADB5BD"
        case .pentacles: return "#2D6A4F"
        }
    }
}
