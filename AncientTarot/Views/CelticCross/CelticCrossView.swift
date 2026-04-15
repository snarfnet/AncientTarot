import SwiftUI

struct CelticCrossView: View {
    @ObservedObject var viewModel: TarotViewModel
    @State private var drawnCards: [DrawnCard] = []
    @State private var selectedIndex: Int = 0
    @State private var showDetail = false

    var body: some View {
        NavigationStack {
            ZStack {
                GrimoireBackground()

                ScrollView {
                    VStack(spacing: 24) {

                        // — Header —
                        VStack(spacing: 8) {
                            Text("ケルト十字")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundColor(Color(hex: AppDesign.textPrimary))
                                .tracking(1)
                            Text("Celtic Cross  ·  A.E. Waite, 1911")
                                .font(.system(size: 11, design: .serif))
                                .foregroundColor(Color(hex: AppDesign.textSecondary))
                                .tracking(1.5)
                        }
                        .padding(.top, 32)

                        GoldDivider()

                        if drawnCards.isEmpty {
                            // Pre-draw state
                            VStack(spacing: 24) {
                                Text("10枚のカードで深い洞察を得る\n最も有名なスプレッド")
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(Color(hex: AppDesign.textSecondary))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)

                                // Decorative Celtic cross silhouette
                                celticCrossSilhouette

                                CosmicButton(
                                    "✦ ケルト十字を展開 ✦",
                                    sublabel: "10 CARD SPREAD"
                                ) { draw() }
                                .padding(.horizontal, 36)

                                AncientQuoteView(
                                    quote: "The operation of the Celtic Cross is a complete divination in itself.",
                                    source: "A.E. Waite, Pictorial Key to the Tarot, 1911"
                                )
                            }
                        } else {
                            // — Celtic layout grid —
                            celticLayout
                                .padding(.horizontal, 8)

                            // — Selected card detail —
                            if selectedIndex < drawnCards.count {
                                let d = drawnCards[selectedIndex]
                                selectedCardPanel(d)
                                    .padding(.horizontal, 16)
                                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
                                    .id(selectedIndex)
                            }

                            // — Card list —
                            VStack(spacing: 0) {
                                ForEach(0..<drawnCards.count, id: \.self) { i in
                                    let d = drawnCards[i]
                                    Button(action: { withAnimation(.spring(response: 0.3)) { selectedIndex = i } }) {
                                        HStack(spacing: 12) {
                                            // Number badge
                                            ZStack {
                                                Circle()
                                                    .fill(selectedIndex == i
                                                          ? Color(hex: AppDesign.gold)
                                                          : Color(hex: AppDesign.nebulaRim).opacity(0.4))
                                                    .frame(width: 26, height: 26)
                                                Text("\(i+1)")
                                                    .font(.system(size: 11, weight: .bold, design: .serif))
                                                    .foregroundColor(
                                                        selectedIndex == i
                                                            ? Color(hex: AppDesign.backgroundDark)
                                                            : Color(hex: AppDesign.gold)
                                                    )
                                            }

                                            Text(d.position?.nameJa ?? "")
                                                .font(.system(size: 13, design: .serif))
                                                .foregroundColor(Color(hex: AppDesign.textPrimary))

                                            Spacer()

                                            Text(d.card.emoji).font(.system(size: 15))

                                            Text(d.card.nameJa)
                                                .font(.system(size: 11, design: .serif))
                                                .foregroundColor(Color(hex: AppDesign.textSecondary))

                                            if d.isReversed {
                                                Text("逆")
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(Color(hex: AppDesign.cosmicRose))
                                                    .padding(.horizontal, 5).padding(.vertical, 2)
                                                    .background(Color(hex: AppDesign.cosmicRose).opacity(0.12))
                                                    .cornerRadius(3)
                                            }
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(
                                            selectedIndex == i
                                                ? Color(hex: AppDesign.gold).opacity(0.06)
                                                : Color.clear
                                        )
                                    }

                                    if i < drawnCards.count - 1 {
                                        Divider()
                                            .background(Color(hex: AppDesign.cosmicViolet).opacity(0.2))
                                            .padding(.leading, 54)
                                    }
                                }
                            }
                            .grimoireCard()
                            .padding(.horizontal, 16)

                            ResetButton(label: "もう一度展開", action: reset)
                                .padding(.horizontal, 16)

                            Spacer(minLength: 44)
                        }
                    }
                }
            }
            .navigationTitle("").navigationBarHidden(true)
        }
    }

    // MARK: - Celtic cross decorative silhouette (pre-draw)
    private var celticCrossSilhouette: some View {
        HStack(alignment: .center, spacing: 6) {
            VStack(spacing: 6) {
                ghostSlot()
                HStack(spacing: 6) {
                    ghostSlot()
                    ZStack {
                        ghostSlot()
                        ghostSlot().rotationEffect(.degrees(90)).opacity(0.6)
                    }
                    ghostSlot()
                }
                ghostSlot()
            }
            VStack(spacing: 6) {
                ForEach(0..<4) { _ in ghostSlot() }
            }
        }
    }

    private func ghostSlot() -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(hex: AppDesign.nebulaMid).opacity(0.25))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color(hex: AppDesign.cosmicViolet).opacity(0.25), lineWidth: 0.5)
            )
            .frame(width: 44, height: 62)
    }

    // MARK: - Celtic layout (drawn state)
    private var celticLayout: some View {
        HStack(alignment: .center, spacing: 6) {
            // Cross section
            VStack(spacing: 6) {
                miniCard(4)
                HStack(spacing: 6) {
                    miniCard(3)
                    ZStack {
                        miniCard(0)
                        miniCard(1).rotationEffect(.degrees(90)).opacity(0.85)
                    }
                    miniCard(5)
                }
                miniCard(2)
            }

            // Staff section
            VStack(spacing: 6) {
                miniCard(9)
                miniCard(8)
                miniCard(7)
                miniCard(6)
            }
        }
    }

    private func miniCard(_ index: Int) -> some View {
        let isSelected = selectedIndex == index
        let d = index < drawnCards.count ? drawnCards[index] : nil

        return Button(action: { withAnimation(.spring(response: 0.3)) { selectedIndex = index } }) {
            VStack(spacing: 3) {
                Text(d?.card.emoji ?? "?")
                    .font(.system(size: 15))
                    .rotationEffect(.degrees(d?.isReversed == true ? 180 : 0))
                    .shadow(color: Color(hex: d?.card.color ?? AppDesign.gold).opacity(0.5), radius: 4)

                Text("\(index + 1)")
                    .font(.system(size: 8, weight: .bold, design: .serif))
                    .foregroundColor(isSelected ? Color(hex: AppDesign.backgroundDark) : Color(hex: AppDesign.gold).opacity(0.8))
            }
            .frame(width: 52, height: 72)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isSelected
                                ? Color(hex: AppDesign.gold).opacity(0.18)
                                : Color(hex: AppDesign.nebulaMid).opacity(0.55)
                        )
                    if let cardColor = d?.card.color {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: cardColor).opacity(0.06))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isSelected
                            ? Color(hex: AppDesign.gold).opacity(0.85)
                            : Color(hex: d?.card.color ?? AppDesign.cosmicViolet).opacity(0.35),
                        lineWidth: isSelected ? 1.5 : 0.6
                    )
            )
            .shadow(color: isSelected ? Color(hex: AppDesign.gold).opacity(0.3) : .clear, radius: 6)
            .scaleEffect(isSelected ? 1.06 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        }
    }

    private func selectedCardPanel(_ d: DrawnCard) -> some View {
        VStack(spacing: 14) {
            HStack {
                // Position number + name
                HStack(spacing: 8) {
                    Text("\(selectedIndex + 1)")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(Color(hex: AppDesign.gold))
                    Text(d.position?.nameJa ?? "")
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundColor(Color(hex: AppDesign.textPrimary))
                }
                Spacer()
                // Card name + emoji
                HStack(spacing: 6) {
                    Text(d.card.emoji).font(.system(size: 16))
                    Text(d.card.nameJa)
                        .font(.system(size: 13, design: .serif))
                        .foregroundColor(Color(hex: d.card.color))
                }
            }

            Text(d.position?.description ?? "")
                .font(.system(size: 12, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textSecondary))
                .frame(maxWidth: .infinity, alignment: .leading)

            GoldDivider()

            Text(d.isReversed ? d.card.reversedJa : d.card.uprightJa)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary).opacity(0.88))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)

            if d.isReversed {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color(hex: AppDesign.cosmicRose))
                        .frame(width: 6, height: 6)
                    Text("逆位置")
                        .font(.system(size: 11, weight: .semibold, design: .serif))
                        .foregroundColor(Color(hex: AppDesign.cosmicRose))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .grimoireCard(glowColor: Color(hex: d.card.color))
    }

    private func draw() { drawnCards = viewModel.drawCelticCross(); selectedIndex = 0 }
    private func reset() { withAnimation { drawnCards = []; selectedIndex = 0 } }
}
