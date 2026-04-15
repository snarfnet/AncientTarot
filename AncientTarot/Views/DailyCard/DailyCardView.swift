import SwiftUI

struct DailyCardView: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var revealed = false
    @State private var drawn: DrawnCard?
    @State private var flipDegrees: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var headerOffset: CGFloat = -16

    var body: some View {
        NavigationStack {
            ZStack {
                GrimoireBackground()

                ScrollView {
                    VStack(spacing: 28) {

                        // — Header —
                        VStack(spacing: 8) {
                            // Lunar phase badge
                            HStack(spacing: 6) {
                                Text(Date().lunarPhaseEmoji)
                                    .font(.system(size: 13))
                                Text(Date().lunarPhaseName)
                                    .font(.system(size: 11, design: .serif))
                                    .foregroundColor(Color(hex: AppDesign.textSecondary))
                                    .tracking(1)
                            }
                            .padding(.horizontal, 12).padding(.vertical, 4)
                            .background(Color(hex: AppDesign.nebulaRim).opacity(0.25))
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color(hex: AppDesign.cosmicViolet).opacity(0.35), lineWidth: 0.7)
                            )
                            .clipShape(Capsule())

                            Text("今日の一枚")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: AppDesign.textPrimary))
                                .tracking(1)

                            Text("DAILY CARD")
                                .font(.system(size: 11, design: .serif))
                                .foregroundColor(Color(hex: AppDesign.gold).opacity(0.65))
                                .tracking(5)
                        }
                        .padding(.top, 36)
                        .offset(y: headerOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                                headerOffset = 0
                            }
                        }

                        GoldDivider()

                        // — Card Area —
                        ZStack {
                            // Ambient glow behind card
                            if let d = drawn {
                                Ellipse()
                                    .fill(
                                        RadialGradient(
                                            colors: [Color(hex: d.card.color).opacity(0.22), .clear],
                                            center: .center, startRadius: 0, endRadius: 120
                                        )
                                    )
                                    .frame(width: 240, height: 160)
                                    .blur(radius: 20)
                            }

                            if revealed, let d = drawn {
                                TarotCardFace(card: d.card, isReversed: d.isReversed, size: 200)
                                    .rotation3DEffect(.degrees(flipDegrees > 90 ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                            } else {
                                TarotCardBack(size: 200)
                            }
                        }
                        .rotation3DEffect(.degrees(flipDegrees), axis: (x: 0, y: 1, z: 0))
                        .onTapGesture { if !revealed { drawCard() } }

                        // — Tap hint —
                        if !revealed {
                            VStack(spacing: 6) {
                                Image(systemName: "hand.tap")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.5))
                                Text("カードをタップして引く")
                                    .font(.system(size: 13, design: .serif))
                                    .foregroundColor(Color(hex: AppDesign.textSecondary))
                                    .tracking(0.5)
                            }
                            .transition(.opacity)
                        }

                        // — Revealed content —
                        if revealed, let d = drawn {
                            VStack(spacing: 20) {

                                // Card name banner
                                HStack(spacing: 10) {
                                    Text(d.card.emoji).font(.system(size: 20))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(d.card.nameJa)
                                            .font(.system(size: 18, weight: .semibold, design: .serif))
                                            .foregroundColor(Color(hex: AppDesign.textPrimary))
                                        Text(d.isReversed ? "逆位置" : "正位置")
                                            .font(.system(size: 11, design: .serif))
                                            .foregroundColor(d.isReversed ? Color(hex: AppDesign.cosmicRose) : Color(hex: AppDesign.gold))
                                            .tracking(1)
                                    }
                                    Spacer()
                                    if d.card.arcana == "major" {
                                        Text(d.card.zodiac ?? "")
                                            .font(.system(size: 13))
                                    }
                                }
                                .padding(.horizontal, 20).padding(.vertical, 14)
                                .grimoireCard(glowColor: Color(hex: d.card.color))
                                .padding(.horizontal, 20)

                                // Meaning panel
                                VStack(spacing: 14) {
                                    SectionHeader(
                                        icon: d.isReversed ? "🔻" : "🔺",
                                        title: d.isReversed ? "逆位置の意味" : "正位置の意味"
                                    )

                                    Text(d.isReversed ? d.card.reversedJa : d.card.uprightJa)
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.88))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(7)

                                    // Keywords
                                    FlowKeywords(
                                        keywords: d.isReversed ? d.card.reversedKeywords : d.card.uprightKeywords,
                                        color: Color(hex: d.card.color)
                                    )
                                }
                                .padding(20)
                                .grimoireCard(glowColor: Color(hex: d.card.color))
                                .padding(.horizontal, 20)

                                // Masters section (major arcana only)
                                if d.card.arcana == "major" {
                                    mastersSection(d.card)
                                }

                                AncientQuoteView(
                                    quote: d.card.historicalQuote,
                                    source: d.card.quoteSource
                                )

                                ResetButton(label: "もう一度引く", action: resetCard)
                                    .padding(.horizontal, 20)
                            }
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        Spacer(minLength: 44)
                    }
                }
                .opacity(contentOpacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) { contentOpacity = 1 }
                }
            }
            .navigationTitle("").navigationBarHidden(true)
        }
    }

    private func mastersSection(_ card: TarotCard) -> some View {
        VStack(spacing: 14) {
            SectionHeader(icon: "📖", title: "三巨匠の解釈")
            if let p = card.papusInterpretation { masterQuote("Papus (1892)", p) }
            if let w = card.waiteInterpretation { masterQuote("Waite (1911)", w) }
            if let o = card.ouspenskyInterpretation { masterQuote("Ouspensky", o) }
        }
        .padding(20)
        .grimoireCard(glowColor: Color(hex: AppDesign.cosmicViolet))
        .padding(.horizontal, 20)
    }

    private func masterQuote(_ name: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.gold).opacity(0.65))
                .tracking(1)
            Text(text)
                .font(.system(size: 13, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.78))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func drawCard() {
        drawn = viewModel.dailyCard()
        withAnimation(.easeInOut(duration: 0.8)) { flipDegrees = 180 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) { revealed = true }
        }
    }

    private func resetCard() {
        withAnimation(.easeOut(duration: 0.35)) {
            revealed = false
            flipDegrees = 0
        }
    }
}

// MARK: - Flow Keywords helper
struct FlowKeywords: View {
    let keywords: [String]
    var color: Color = Color(hex: AppDesign.gold)

    var body: some View {
        // Simple wrapping HStack using a fixed-wrap approach
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(keywords, id: \.self) { kw in
                    Text(kw)
                        .font(.system(size: 11, design: .serif))
                        .foregroundColor(color)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(color.opacity(0.1))
                        .overlay(
                            Capsule()
                                .strokeBorder(color.opacity(0.3), lineWidth: 0.7)
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }
}
