import SwiftUI

struct ThreeCardView: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var drawnCards: [DrawnCard] = []
    @State private var selectedCard: DrawnCard?
    @State private var isDrawing = false
    @State private var cardAppearOffsets: [CGFloat] = [40, 40, 40]

    var body: some View {
        NavigationStack {
            ZStack {
                GrimoireBackground()

                ScrollView {
                    VStack(spacing: 26) {

                        // — Header —
                        VStack(spacing: 8) {
                            Text("三枚引き")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: AppDesign.textPrimary))
                                .tracking(1)
                            HStack(spacing: 8) {
                                starDot()
                                Text("過去 · 現在 · 未来")
                                    .font(.system(size: 13, design: .serif))
                                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.75))
                                    .tracking(2)
                                starDot()
                            }
                        }
                        .padding(.top, 32)

                        GoldDivider()

                        if drawnCards.isEmpty {
                            // Pre-draw state
                            VStack(spacing: 28) {
                                // Decorative three-card silhouette
                                HStack(spacing: 12) {
                                    ForEach(0..<3) { i in
                                        emptyCardSlot(label: ["過去", "現在", "未来"][i])
                                    }
                                }
                                .padding(.horizontal, 20)

                                CosmicButton(
                                    "✦ カードを引く ✦",
                                    sublabel: "THREE CARD SPREAD"
                                ) { draw() }
                                .padding(.horizontal, 36)

                                AncientQuoteView(
                                    quote: "Past, Present, and Future are but one eternal Now.",
                                    source: "P.D. Ouspensky, The Symbolism of the Tarot"
                                )
                            }
                        } else {
                            // Three drawn cards
                            HStack(alignment: .top, spacing: 10) {
                                ForEach(Array(drawnCards.enumerated()), id: \.element.id) { idx, d in
                                    VStack(spacing: 8) {
                                        // Position label
                                        Text(d.position?.nameJa ?? "")
                                            .font(.system(size: 11, weight: .bold, design: .serif))
                                            .foregroundColor(
                                                selectedCard?.id == d.id
                                                    ? Color(hex: AppDesign.gold)
                                                    : Color(hex: AppDesign.textSecondary)
                                            )
                                            .tracking(2)
                                            .animation(.easeInOut(duration: 0.2), value: selectedCard?.id)

                                        TarotCardFace(card: d.card, isReversed: d.isReversed, size: 108)
                                            .overlay(
                                                // Selection ring
                                                RoundedRectangle(cornerRadius: 14)
                                                    .strokeBorder(
                                                        Color(hex: AppDesign.gold).opacity(selectedCard?.id == d.id ? 0.9 : 0),
                                                        lineWidth: 2
                                                    )
                                            )
                                            .scaleEffect(selectedCard?.id == d.id ? 1.04 : 1.0)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedCard?.id)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3)) {
                                                    selectedCard = d
                                                }
                                            }
                                            .offset(y: cardAppearOffsets[safe: idx] ?? 0)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)

                            // Selected card detail panel
                            if let s = selectedCard {
                                VStack(spacing: 16) {
                                    // Header row
                                    HStack(spacing: 10) {
                                        // Position indicator dot
                                        Circle()
                                            .fill(Color(hex: s.card.color).opacity(0.8))
                                            .frame(width: 8, height: 8)
                                            .shadow(color: Color(hex: s.card.color).opacity(0.6), radius: 4)

                                        Text(s.position?.nameJa ?? "")
                                            .font(.system(size: 13, weight: .bold, design: .serif))
                                            .foregroundColor(Color(hex: AppDesign.gold))
                                            .tracking(2)

                                        Text("—")
                                            .foregroundColor(Color(hex: AppDesign.textSecondary))

                                        Text(s.card.nameJa)
                                            .font(.system(size: 13, design: .serif))
                                            .foregroundColor(Color(hex: AppDesign.textPrimary))

                                        Spacer()

                                        if s.isReversed {
                                            Text("逆")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(Color(hex: AppDesign.cosmicRose))
                                                .padding(.horizontal, 6).padding(.vertical, 2)
                                                .background(Color(hex: AppDesign.cosmicRose).opacity(0.12))
                                                .cornerRadius(4)
                                        }
                                    }

                                    Text(s.position?.description ?? "")
                                        .font(.system(size: 11, design: .serif))
                                        .foregroundColor(Color(hex: AppDesign.textSecondary))
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    GoldDivider()

                                    Text(s.isReversed ? s.card.reversedJa : s.card.uprightJa)
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.88))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(7)

                                    FlowKeywords(
                                        keywords: s.isReversed ? s.card.reversedKeywords : s.card.uprightKeywords,
                                        color: Color(hex: s.card.color)
                                    )
                                }
                                .padding(20)
                                .grimoireCard(glowColor: Color(hex: s.card.color))
                                .padding(.horizontal, 20)
                                .transition(.opacity.combined(with: .scale(scale: 0.97)))
                                .id(s.id)
                            }

                            ResetButton(label: "もう一度引く", action: reset)
                                .padding(.horizontal, 20)
                        }

                        Spacer(minLength: 44)
                    }
                }
            }
            .navigationTitle("").navigationBarHidden(true)
        }
    }

    private func emptyCardSlot(label: String) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textSecondary))
                .tracking(2)

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: AppDesign.nebulaMid).opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color(hex: AppDesign.cosmicViolet).opacity(0.3), Color(hex: AppDesign.gold).opacity(0.15)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 0.8, dash: [4, 3])
                        )
                )
                .frame(width: 90, height: 135)
                .overlay(
                    Text("✦")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: AppDesign.gold).opacity(0.2))
                )
        }
    }

    private func starDot() -> some View {
        Circle()
            .fill(Color(hex: AppDesign.gold).opacity(0.4))
            .frame(width: 3, height: 3)
    }

    private func draw() {
        drawnCards = viewModel.drawThreeCards()
        selectedCard = drawnCards.first
        // Staggered card entry animation
        cardAppearOffsets = [40, 40, 40]
        for i in 0..<3 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(i) * 0.12)) {
                if cardAppearOffsets.indices.contains(i) {
                    cardAppearOffsets[i] = 0
                }
            }
        }
    }

    private func reset() {
        withAnimation(.easeOut(duration: 0.3)) {
            drawnCards = []
            selectedCard = nil
            cardAppearOffsets = [40, 40, 40]
        }
    }
}

// MARK: - Safe array subscript
private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
