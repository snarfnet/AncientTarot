import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TarotViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DailyCardView(viewModel: viewModel)
                .tabItem {
                    Label("今日の一枚", systemImage: "sparkle")
                }
                .tag(0)

            ThreeCardView(viewModel: viewModel)
                .tabItem {
                    Label("三枚引き", systemImage: "rectangle.split.3x1")
                }
                .tag(1)

            CelticCrossView(viewModel: viewModel)
                .tabItem {
                    Label("ケルト十字", systemImage: "plus.rectangle.on.rectangle")
                }
                .tag(2)

            DeckView(viewModel: viewModel)
                .tabItem {
                    Label("全カード", systemImage: "square.stack.3d.up")
                }
                .tag(3)
        }
        .tint(Color(hex: AppDesign.gold))
        .onAppear {
            configureTabBarAppearance()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Deep cosmic background
        appearance.backgroundColor = UIColor(red: 0.012, green: 0.008, blue: 0.059, alpha: 0.97)

        // Unselected item style
        let unselectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.545, green: 0.541, blue: 0.667, alpha: 1)
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = unselectedAttrs
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.545, green: 0.541, blue: 0.667, alpha: 1)

        // Selected item style — champagne gold
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.788, green: 0.659, blue: 0.298, alpha: 1)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.788, green: 0.659, blue: 0.298, alpha: 1)

        // Top separator line — subtle violet
        appearance.shadowColor = UIColor(red: 0.42, green: 0.36, blue: 0.90, alpha: 0.25)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
