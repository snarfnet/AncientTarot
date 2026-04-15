import SwiftUI

struct DeckView: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var selectedTab = 0
    @State private var selectedSuit: String?

    var body: some View {
        NavigationStack {
            ZStack {
                GrimoireBackground()

                VStack(spacing: 0) {
                    // — Header —
                    VStack(spacing: 6) {
                        Text("全78枚")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: AppDesign.textPrimary))
                            .tracking(1)
                        Text("THE COMPLETE DECK")
                            .font(.system(size: 10, design: .serif))
                            .foregroundColor(Color(hex: AppDesign.gold).opacity(0.55))
                            .tracking(4)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    // — Major / Minor segmented control —
                    CosmicSegmentedControl(
                        options: ["大アルカナ (22)", "小アルカナ (56)"],
                        selected: $selectedTab
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    // — Suit filter (minor only) —
                    if selectedTab == 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                suitButton(nil, "✦ 全て")
                                ForEach(TarotSuit.allCases, id: \.rawValue) { s in
                                    suitButton(s.rawValue, "\(s.emoji) \(s.nameJa)")
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 8)
                    }

                    // — Card grid —
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10)
                            ],
                            spacing: 12
                        ) {
                            ForEach(currentCards) { card in
                                NavigationLink(destination: CardDetailView(card: card)) {
                                    DeckCardCell(card: card)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 4)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
    }

    private var currentCards: [TarotCard] {
        if selectedTab == 0 { return viewModel.majorArcana }
        if let suit = selectedSuit { return viewModel.cards(forSuit: suit) }
        return viewModel.minorArcana.sorted { $0.id < $1.id }
    }

    private func suitButton(_ suit: String?, _ label: String) -> some View {
        let isSelected = selectedSuit == suit
        return Button(action: { selectedSuit = suit }) {
            Text(label)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular, design: .serif))
                .foregroundColor(
                    isSelected
                        ? Color(hex: AppDesign.backgroundDark)
                        : Color(hex: AppDesign.textSecondary)
                )
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(
                    isSelected
                        ? AnyView(Capsule().fill(AppDesign.goldGradient))
                        : AnyView(Capsule().fill(Color(hex: AppDesign.nebulaMid).opacity(0.5)))
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected
                                ? Color.clear
                                : Color(hex: AppDesign.cosmicViolet).opacity(0.3),
                            lineWidth: 0.6
                        )
                )
        }
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Deck card cell
struct DeckCardCell: View {
    let card: TarotCard
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 7) {
            ZStack {
                // Glow behind emoji
                Circle()
                    .fill(Color(hex: card.color).opacity(0.15))
                    .frame(width: 44, height: 44)
                    .blur(radius: 8)
                Text(card.emoji)
                    .font(.system(size: 30))
                    .shadow(color: Color(hex: card.color).opacity(0.5), radius: 5)
            }

            Text(card.nameJa)
                .font(.system(size: 11, weight: .semibold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if card.arcana == "major" {
                Text(card.hebrewLetter ?? "")
                    .font(.system(size: 9, design: .serif))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.55))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: AppDesign.nebulaMid).opacity(0.6),
                                Color(hex: AppDesign.backgroundCard).opacity(0.85)
                            ],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: card.color).opacity(0.05))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(hex: card.color).opacity(0.5),
                            Color(hex: AppDesign.gold).opacity(0.2)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
        )
        .shadow(color: Color(hex: card.color).opacity(0.12), radius: 8)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Cosmic Segmented Control
struct CosmicSegmentedControl: View {
    let options: [String]
    @Binding var selected: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(options.enumerated()), id: \.offset) { idx, label in
                Button(action: { withAnimation(.easeInOut(duration: 0.2)) { selected = idx } }) {
                    Text(label)
                        .font(.system(size: 12, weight: selected == idx ? .semibold : .regular, design: .serif))
                        .foregroundColor(
                            selected == idx
                                ? Color(hex: AppDesign.backgroundDark)
                                : Color(hex: AppDesign.textSecondary)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(
                            selected == idx
                                ? AnyView(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppDesign.goldGradient)
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(LinearGradient(
                                                colors: [Color.white.opacity(0.15), .clear],
                                                startPoint: .top, endPoint: .bottom
                                            ))
                                    }
                                )
                                : AnyView(Color.clear)
                        )
                        .cornerRadius(10)
                }
            }
        }
        .padding(3)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(hex: AppDesign.nebulaMid).opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .strokeBorder(Color(hex: AppDesign.cosmicViolet).opacity(0.3), lineWidth: 0.7)
        )
    }
}

// MARK: - Card Detail View
struct CardDetailView: View {
    let card: TarotCard
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GrimoireBackground()

            ScrollView {
                VStack(spacing: 20) {
                    // Card face with ambient glow
                    ZStack {
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [Color(hex: card.color).opacity(0.25), .clear],
                                    center: .center, startRadius: 0, endRadius: 130
                                )
                            )
                            .frame(width: 260, height: 180)
                            .blur(radius: 24)

                        TarotCardFace(card: card, size: 180)
                    }
                    .padding(.top, 20)

                    // Astro chips
                    if let hebrew = card.hebrewLetter {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                infoChip("ヘブライ文字", hebrew)
                                if let p = card.planet { infoChip("惑星", p) }
                                if let z = card.zodiac { infoChip("星座", z) }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    // Symbolism
                    VStack(spacing: 10) {
                        SectionHeader(icon: "🎨", title: "象徴")
                        Text(card.symbolism)
                            .font(.system(size: 14, design: .serif))
                            .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.88))
                            .lineSpacing(6)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .grimoireCard(glowColor: Color(hex: card.color))
                    .padding(.horizontal, 16)

                    // Upright meaning
                    meaningSection("🔺", "正位置", card.uprightJa, card.uprightKeywords, color: Color(hex: card.color))

                    // Reversed meaning
                    meaningSection("🔻", "逆位置", card.reversedJa, card.reversedKeywords, color: Color(hex: AppDesign.cosmicRose))

                    // Masters (major only)
                    if card.arcana == "major" {
                        VStack(spacing: 12) {
                            SectionHeader(icon: "📖", title: "三巨匠の解釈")
                            if let p = card.papusInterpretation { masterRow("Papus (1892)", p) }
                            if let w = card.waiteInterpretation { masterRow("Waite (1911)", w) }
                            if let o = card.ouspenskyInterpretation { masterRow("Ouspensky", o) }
                        }
                        .padding(18)
                        .grimoireCard(glowColor: Color(hex: AppDesign.cosmicViolet))
                        .padding(.horizontal, 16)
                    }

                    AncientQuoteView(quote: card.historicalQuote, source: card.quoteSource)
                        .padding(.bottom, 44)
                }
            }
        }
        .navigationTitle(card.nameJa)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 6) {
                    Text(card.emoji).font(.system(size: 16))
                    Text(card.nameJa)
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .foregroundColor(Color(hex: AppDesign.textPrimary))
                }
            }
        }
    }

    private func meaningSection(_ icon: String, _ title: String, _ text: String, _ keywords: [String], color: Color) -> some View {
        VStack(spacing: 10) {
            SectionHeader(icon: icon, title: title)
            Text(text)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.88))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            FlowKeywords(keywords: keywords, color: color)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .grimoireCard(glowColor: color)
        .padding(.horizontal, 16)
    }

    private func masterRow(_ name: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.gold).opacity(0.65))
                .tracking(1)
            Text(text)
                .font(.system(size: 13, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.8))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func infoChip(_ label: String, _ value: String) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 9, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textSecondary))
                .tracking(0.5)
            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.gold))
                .lineLimit(1)
        }
        .padding(.horizontal, 12).padding(.vertical, 7)
        .background(Color(hex: AppDesign.gold).opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color(hex: AppDesign.gold).opacity(0.3), Color(hex: AppDesign.cosmicCyan).opacity(0.2)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.7
                )
        )
        .cornerRadius(10)
    }
}
