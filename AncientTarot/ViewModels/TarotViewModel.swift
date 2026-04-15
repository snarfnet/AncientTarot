import SwiftUI

@MainActor
class TarotViewModel: ObservableObject {
    @Published var allCards: [TarotCard] = []
    @Published var majorArcana: [TarotCard] = []
    @Published var minorArcana: [TarotCard] = []

    init() {
        if let url = Bundle.main.url(forResource: "tarot_cards", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let cards = try? JSONDecoder().decode([TarotCard].self, from: data) {
            allCards = cards
            majorArcana = cards.filter { $0.arcana == "major" }.sorted { $0.number < $1.number }
            minorArcana = cards.filter { $0.arcana == "minor" }
        }
    }

    // MARK: - Daily Card
    func dailyCard() -> DrawnCard {
        let today = Date()
        let seed = UInt64(today.dayOfYear + today.year * 366)
        var rng = SeededRNG(seed: seed)
        let idx = Int.random(in: 0..<allCards.count, using: &rng)
        let reversed = Bool.random(using: &rng)
        return DrawnCard(card: allCards[idx], isReversed: reversed, position: Spreads.dailyCard.positions.first)
    }

    // MARK: - Three Card Spread
    func drawThreeCards() -> [DrawnCard] {
        var deck = allCards.shuffled()
        return Spreads.threeCard.positions.map { pos in
            let card = deck.removeFirst()
            return DrawnCard(card: card, isReversed: Bool.random(), position: pos)
        }
    }

    // MARK: - Celtic Cross
    func drawCelticCross() -> [DrawnCard] {
        var deck = allCards.shuffled()
        return Spreads.celticCross.positions.map { pos in
            let card = deck.removeFirst()
            return DrawnCard(card: card, isReversed: Bool.random(), position: pos)
        }
    }

    // MARK: - Filter
    func cards(forSuit suit: String) -> [TarotCard] {
        minorArcana.filter { $0.suit == suit }.sorted { $0.number < $1.number }
    }
}
