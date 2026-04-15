import SwiftUI

enum AppDesign {
    // --- Cosmic palette ---
    // Deep space base
    static let backgroundDark    = "#03020F"   // near-black with indigo undertone
    static let backgroundCard    = "#0D0B1E"   // dark violet-navy
    static let backgroundElevated = "#15122A"  // slightly lifted layer

    // Nebula accent layers
    static let nebulaDeep        = "#0A0620"   // darkest violet
    static let nebulaMid         = "#1A1040"   // mid violet
    static let nebulaRim         = "#2B1B5E"   // bright rim purple

    // Star-gold — champagne, not brash yellow
    static let gold              = "#C9A84C"   // warm champagne gold
    static let goldLight         = "#E8C96A"   // bright highlight
    static let goldDim           = "#7A6128"   // subdued gold

    // Cosmic accent colors
    static let cosmicCyan        = "#4DD9E8"   // ionized nebula teal
    static let cosmicViolet      = "#8B5CF6"   // deep violet
    static let cosmicRose        = "#E879A8"   // emission nebula pink
    static let starWhite         = "#EEF0FF"   // star-white with blue tint

    // Legacy — kept for compatibility with card .color references
    static let amethyst          = "#6D28D9"   // violet
    static let mysticBlue        = "#1E3A8A"   // deep blue

    // Typography
    static let textPrimary       = "#EEF0FF"   // star-white
    static let textSecondary     = "#8B8AAA"   // muted slate-violet

    // --- Gradients ---
    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: goldDim), Color(hex: gold), Color(hex: goldLight), Color(hex: gold)],
            startPoint: .leading, endPoint: .trailing
        )
    }

    static var cosmicBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: backgroundDark),
                Color(hex: "0B0828"),
                Color(hex: "100D2F"),
                Color(hex: backgroundDark)
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    static var cardGlassBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: nebulaMid).opacity(0.7),
                Color(hex: backgroundCard).opacity(0.85)
            ],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    static var nebulaGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: cosmicViolet).opacity(0.3), Color(hex: cosmicCyan).opacity(0.15), .clear],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
}

enum Spreads {
    static let dailyCard = TarotSpread(
        id: "daily", nameJa: "今日の一枚", nameEn: "Daily Card",
        description: "毎日一枚のカードを引き、今日のメッセージを受け取ります。",
        cardCount: 1,
        positions: [SpreadPosition(id: 0, nameJa: "今日のカード", description: "今日一日のテーマとメッセージ")]
    )

    static let threeCard = TarotSpread(
        id: "three", nameJa: "三枚引き", nameEn: "Three Card Spread",
        description: "過去・現在・未来を読み解く基本的なスプレッド。",
        cardCount: 3,
        positions: [
            SpreadPosition(id: 0, nameJa: "過去", description: "あなたの過去の影響"),
            SpreadPosition(id: 1, nameJa: "現在", description: "現在の状況"),
            SpreadPosition(id: 2, nameJa: "未来", description: "これから訪れる展開"),
        ]
    )

    static let celticCross = TarotSpread(
        id: "celtic", nameJa: "ケルト十字", nameEn: "Celtic Cross",
        description: "A.E. Waite (1911) が体系化した最も有名な10枚のスプレッド。深い洞察を与えます。",
        cardCount: 10,
        positions: [
            SpreadPosition(id: 0, nameJa: "現状", description: "質問者を取り巻く現在の状況"),
            SpreadPosition(id: 1, nameJa: "障害", description: "直面している課題や対立"),
            SpreadPosition(id: 2, nameJa: "基盤", description: "状況の根底にあるもの"),
            SpreadPosition(id: 3, nameJa: "過去", description: "過ぎ去りつつある影響"),
            SpreadPosition(id: 4, nameJa: "可能性", description: "起こりうる最善の結果"),
            SpreadPosition(id: 5, nameJa: "近未来", description: "間もなく訪れる影響"),
            SpreadPosition(id: 6, nameJa: "自己", description: "質問者自身の態度"),
            SpreadPosition(id: 7, nameJa: "環境", description: "周囲の人々や状況"),
            SpreadPosition(id: 8, nameJa: "希望/恐れ", description: "内なる望みと不安"),
            SpreadPosition(id: 9, nameJa: "最終結果", description: "全てを統合した結論"),
        ]
    )
}
