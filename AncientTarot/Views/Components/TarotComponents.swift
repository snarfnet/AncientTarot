import SwiftUI

// MARK: - Cosmic Starfield Background
struct GrimoireBackground: View {
    @State private var twinklePhase: Double = 0

    var body: some View {
        ZStack {
            // Deep space base gradient
            LinearGradient(
                colors: [
                    Color(hex: AppDesign.backgroundDark),
                    Color(hex: "080620"),
                    Color(hex: "0E0A2A"),
                    Color(hex: "060412")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Nebula cloud layers
            GeometryReader { geo in
                // Large violet nebula — top-right
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: AppDesign.cosmicViolet).opacity(0.18), .clear],
                            center: .center, startRadius: 0, endRadius: geo.size.width * 0.45
                        )
                    )
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4)
                    .position(x: geo.size.width * 0.75, y: geo.size.height * 0.2)
                    .blur(radius: 30)
                    .allowsHitTesting(false)

                // Teal nebula — bottom-left
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: AppDesign.cosmicCyan).opacity(0.10), .clear],
                            center: .center, startRadius: 0, endRadius: geo.size.width * 0.35
                        )
                    )
                    .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.3)
                    .position(x: geo.size.width * 0.2, y: geo.size.height * 0.75)
                    .blur(radius: 24)
                    .allowsHitTesting(false)

                // Rose emission nebula — center
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: AppDesign.cosmicRose).opacity(0.06), .clear],
                            center: .center, startRadius: 0, endRadius: geo.size.width * 0.4
                        )
                    )
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.35)
                    .position(x: geo.size.width * 0.5, y: geo.size.height * 0.5)
                    .blur(radius: 40)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            // Star field
            Canvas { context, size in
                // Static background stars
                for i in 0..<120 {
                    let x = CGFloat((i * 7919 + 3) % 1000) / 1000.0 * size.width
                    let y = CGFloat((i * 6271 + 17) % 1000) / 1000.0 * size.height
                    let s = CGFloat((i * 31 + 5) % 4) * 0.4 + 0.3
                    let baseOpacity = Double((i * 47 + 11) % 100) / 200.0 + 0.12
                    // Subtle twinkle for every 5th star
                    let twinkle = i % 5 == 0 ? sin(twinklePhase + Double(i) * 0.7) * 0.15 : 0
                    context.opacity = min(0.75, baseOpacity + twinkle)

                    // Larger stars get a blue-white tint
                    let starColor: Color = s > 1.0 ? Color(hex: AppDesign.starWhite) : .white
                    context.fill(Path(ellipseIn: CGRect(x: x - s/2, y: y - s/2, width: s, height: s)), with: .color(starColor))
                }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    twinklePhase = .pi * 2
                }
            }

            // Constellation line pattern (decorative)
            ConstellationOverlay()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }
}

// MARK: - Constellation Line Overlay
struct ConstellationOverlay: View {
    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                // Define a few constellation-like star clusters
                let clusters: [(points: [CGPoint], color: Color)] = [
                    // Top-left cluster (Orion-like)
                    (points: [
                        CGPoint(x: size.width * 0.08, y: size.height * 0.12),
                        CGPoint(x: size.width * 0.14, y: size.height * 0.09),
                        CGPoint(x: size.width * 0.11, y: size.height * 0.16),
                        CGPoint(x: size.width * 0.17, y: size.height * 0.14),
                        CGPoint(x: size.width * 0.06, y: size.height * 0.20),
                    ], color: Color(hex: AppDesign.cosmicCyan).opacity(0.18)),

                    // Bottom-right cluster
                    (points: [
                        CGPoint(x: size.width * 0.82, y: size.height * 0.78),
                        CGPoint(x: size.width * 0.88, y: size.height * 0.74),
                        CGPoint(x: size.width * 0.91, y: size.height * 0.82),
                        CGPoint(x: size.width * 0.85, y: size.height * 0.88),
                        CGPoint(x: size.width * 0.78, y: size.height * 0.85),
                    ], color: Color(hex: AppDesign.cosmicViolet).opacity(0.18)),
                ]

                for cluster in clusters {
                    let pts = cluster.points
                    guard pts.count > 1 else { continue }
                    // Draw connecting lines
                    for i in 0..<pts.count - 1 {
                        var path = Path()
                        path.move(to: pts[i])
                        path.addLine(to: pts[i + 1])
                        context.stroke(path, with: .color(cluster.color), lineWidth: 0.5)
                    }
                    // Draw star dots
                    for pt in pts {
                        let r: CGFloat = 1.5
                        context.fill(Path(ellipseIn: CGRect(x: pt.x - r, y: pt.y - r, width: r*2, height: r*2)), with: .color(cluster.color.opacity(2.5)))
                    }
                }
            }
        }
    }
}

// MARK: - Cosmic Divider (replaces GoldDivider)
struct GoldDivider: View {
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, Color(hex: AppDesign.gold).opacity(0.5), Color(hex: AppDesign.cosmicCyan).opacity(0.3)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
            // Central star glyph
            ZStack {
                Circle()
                    .fill(Color(hex: AppDesign.gold).opacity(0.12))
                    .frame(width: 18, height: 18)
                Text("✦")
                    .font(.system(size: 8))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.8))
            }
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: AppDesign.cosmicCyan).opacity(0.3), Color(hex: AppDesign.gold).opacity(0.5), .clear],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Tarot Card Face (glassmorphic + nebula glow)
struct TarotCardFace: View {
    let card: TarotCard
    var isReversed: Bool = false
    var size: CGFloat = 180

    @State private var glowPulse: Bool = false

    var body: some View {
        VStack(spacing: size * 0.044) {
            Text(card.emoji)
                .font(.system(size: size * 0.26))
                .rotationEffect(.degrees(isReversed ? 180 : 0))
                .shadow(color: Color(hex: card.color).opacity(0.6), radius: 8)

            Text(card.nameJa)
                .font(.system(size: size * 0.072, weight: .semibold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.textPrimary))
                .multilineTextAlignment(.center)

            if card.arcana == "major" {
                Text(romanNumeral(card.number))
                    .font(.system(size: size * 0.052, design: .serif))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.75))
                    .tracking(2)
            }

            if isReversed {
                Text("逆位置")
                    .font(.system(size: size * 0.042, weight: .semibold))
                    .foregroundColor(Color(hex: AppDesign.cosmicRose))
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .background(Color(hex: AppDesign.cosmicRose).opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(Color(hex: AppDesign.cosmicRose).opacity(0.35), lineWidth: 0.5)
                    )
                    .cornerRadius(4)
            }
        }
        .frame(width: size, height: size * 1.5)
        .background(
            ZStack {
                // Glass base
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: AppDesign.nebulaMid).opacity(0.65),
                                Color(hex: AppDesign.backgroundCard).opacity(0.9)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                // Card color tint
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: card.color).opacity(0.07))
                // Inner shimmer
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.05), .clear, Color.white.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(hex: card.color).opacity(glowPulse ? 0.85 : 0.55),
                            Color(hex: AppDesign.gold).opacity(0.4),
                            Color(hex: card.color).opacity(0.2)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
        // Outer nebula glow
        .shadow(color: Color(hex: card.color).opacity(glowPulse ? 0.35 : 0.18), radius: glowPulse ? 16 : 10)
        .shadow(color: Color(hex: AppDesign.cosmicViolet).opacity(0.15), radius: 20)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }

    private func romanNumeral(_ n: Int) -> String {
        let numerals = ["0","I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX","XXI"]
        return n < numerals.count ? numerals[n] : "\(n)"
    }
}

// MARK: - Card Back (cosmic design)
struct TarotCardBack: View {
    var size: CGFloat = 180
    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        ZStack {
            // Base glass
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: AppDesign.nebulaDeep),
                            Color(hex: AppDesign.nebulaMid),
                            Color(hex: AppDesign.nebulaRim).opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Constellation pattern on back
            Canvas { context, size in
                // Eight-pointed star pattern
                let cx = size.width / 2
                let cy = size.height / 2
                let r1 = min(size.width, size.height) * 0.32
                let r2 = r1 * 0.42

                var path = Path()
                for i in 0..<16 {
                    let angle = Double(i) * .pi / 8.0
                    let r = i % 2 == 0 ? r1 : r2
                    let pt = CGPoint(x: cx + CGFloat(cos(angle)) * r, y: cy + CGFloat(sin(angle)) * r)
                    if i == 0 { path.move(to: pt) } else { path.addLine(to: pt) }
                }
                path.closeSubpath()
                context.stroke(path, with: .color(Color(hex: AppDesign.gold).opacity(0.35)), lineWidth: 0.7)

                // Inner circle
                let innerPath = Path(ellipseIn: CGRect(x: cx - r2, y: cy - r2, width: r2*2, height: r2*2))
                context.stroke(innerPath, with: .color(Color(hex: AppDesign.gold).opacity(0.25)), lineWidth: 0.5)

                // Outer circle
                let outerR = r1 * 1.15
                let outerPath = Path(ellipseIn: CGRect(x: cx - outerR, y: cy - outerR, width: outerR*2, height: outerR*2))
                context.stroke(outerPath, with: .color(Color(hex: AppDesign.cosmicCyan).opacity(0.2)), lineWidth: 0.5)
            }

            // Shimmer sweep
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [.clear, Color.white.opacity(0.06), .clear],
                        startPoint: UnitPoint(x: shimmerOffset, y: 0),
                        endPoint: UnitPoint(x: shimmerOffset + 0.5, y: 1)
                    )
                )

            VStack(spacing: 6) {
                Text("✦")
                    .font(.system(size: size * 0.11))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.75))
                Text("TAROT")
                    .font(.system(size: size * 0.075, weight: .bold, design: .serif))
                    .tracking(5)
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.55))
                Text("✦")
                    .font(.system(size: size * 0.07))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.45))
            }

            // Rim glow border
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color(hex: AppDesign.cosmicViolet).opacity(0.6),
                            Color(hex: AppDesign.gold).opacity(0.45),
                            Color(hex: AppDesign.cosmicCyan).opacity(0.4),
                            Color(hex: AppDesign.cosmicViolet).opacity(0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        }
        .frame(width: size, height: size * 1.5)
        .shadow(color: Color(hex: AppDesign.cosmicViolet).opacity(0.3), radius: 18)
        .onAppear {
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                shimmerOffset = 1.5
            }
        }
    }
}

// MARK: - Glass Panel Modifier (replaces GrimoireCardModifier)
struct GrimoireCardModifier: ViewModifier {
    var glowColor: Color = Color(hex: AppDesign.gold)

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: AppDesign.nebulaMid).opacity(0.55),
                                    Color(hex: AppDesign.backgroundCard).opacity(0.88)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.04), .clear],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [glowColor.opacity(0.45), glowColor.opacity(0.12), Color(hex: AppDesign.cosmicCyan).opacity(0.1)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: glowColor.opacity(0.14), radius: 12)
            .shadow(color: Color(hex: AppDesign.cosmicViolet).opacity(0.08), radius: 20)
    }
}

extension View {
    func grimoireCard(glowColor: Color = Color(hex: AppDesign.gold)) -> some View {
        modifier(GrimoireCardModifier(glowColor: glowColor))
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 8) {
            Text(icon).font(.body)
            Text(title)
                .font(.system(size: 11, weight: .bold, design: .serif))
                .foregroundColor(Color(hex: AppDesign.gold))
                .textCase(.uppercase)
                .tracking(3)
            Spacer()
        }
    }
}

// MARK: - Ancient Quote
struct AncientQuoteView: View {
    let quote: String
    let source: String

    var body: some View {
        VStack(spacing: 8) {
            // Decorative line
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color(hex: AppDesign.gold).opacity(0.3))
                    .frame(width: 24, height: 0.5)
                Text("✦")
                    .font(.system(size: 7))
                    .foregroundColor(Color(hex: AppDesign.gold).opacity(0.4))
                Rectangle()
                    .fill(Color(hex: AppDesign.gold).opacity(0.3))
                    .frame(width: 24, height: 0.5)
            }

            Text("\u{201C}\(quote)\u{201D}")
                .font(.system(size: 12, design: .serif))
                .italic()
                .foregroundColor(Color(hex: AppDesign.textSecondary))
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Text("— \(source)")
                .font(.system(size: 10, design: .serif))
                .foregroundColor(Color(hex: AppDesign.gold).opacity(0.5))
                .tracking(0.5)
        }
        .padding(.horizontal, 28)
    }
}

// MARK: - Cosmic Action Button
struct CosmicButton: View {
    let label: String
    let sublabel: String?
    let action: () -> Void

    init(_ label: String, sublabel: String? = nil, action: @escaping () -> Void) {
        self.label = label
        self.sublabel = sublabel
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 17, weight: .semibold, design: .serif))
                    .foregroundColor(Color(hex: AppDesign.backgroundDark))
                if let sub = sublabel {
                    Text(sub)
                        .font(.system(size: 10, design: .serif))
                        .foregroundColor(Color(hex: AppDesign.backgroundDark).opacity(0.65))
                        .tracking(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppDesign.goldGradient)
                    // Shimmer overlay
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.2), .clear, Color.white.opacity(0.05)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .shadow(color: Color(hex: AppDesign.gold).opacity(0.4), radius: 14, y: 4)
            .shadow(color: Color(hex: AppDesign.cosmicViolet).opacity(0.2), radius: 20, y: 6)
        }
    }
}

// MARK: - Reset Button
struct ResetButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 13, weight: .semibold))
                Text(label)
                    .font(.system(size: 14, weight: .semibold, design: .serif))
            }
            .foregroundColor(Color(hex: AppDesign.gold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Color(hex: AppDesign.gold).opacity(0.07))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color(hex: AppDesign.gold).opacity(0.4), Color(hex: AppDesign.cosmicCyan).opacity(0.2)],
                            startPoint: .leading, endPoint: .trailing
                        ),
                        lineWidth: 0.8
                    )
            )
            .cornerRadius(12)
        }
    }
}
