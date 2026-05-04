import SwiftUI

private enum ShellTab: String, CaseIterable, Identifiable {
    case league = "League"
    case matches = "Matches"
    case teams = "Teams"
    case calendar = "Play"
    case insights = "Insights"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .league:
            return "shield.fill"
        case .matches:
            return "figure.hockey"
        case .teams:
            return "person.3.fill"
        case .calendar:
            return "gamecontroller.fill"
        case .insights:
            return "chart.line.uptrend.xyaxis"
        }
    }
}

struct RootView: View {
    @State private var selectedTab: ShellTab = .league

    var body: some View {
        ZStack(alignment: .bottom) {
            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            bottomBar
                .padding(.horizontal, 18)
                .padding(.bottom, 14)
        }
        .background(RoobTheme.pageGradient.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch selectedTab {
        case .league:
            LeagueOverviewView()
        case .matches:
            MatchesView()
        case .teams:
            TeamsView()
        case .calendar:
            LeagueCalendarView()
        case .insights:
            ProfileView()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            BrandLogoBadge(size: 42)

            HStack(spacing: 10) {
                ForEach(ShellTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tab.iconName)
                                .font(.system(size: 18, weight: .semibold))
                            Text(tab.rawValue)
                                .font(.caption.weight(.semibold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(selectedTab == tab ? RoobTheme.gold : .white.opacity(0.76))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(selectedTab == tab ? RoobTheme.plum.opacity(0.48) : .clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: 860)
        .padding(10)
        .background(RoobTheme.surface.opacity(0.96))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(RoobTheme.gold.opacity(0.16), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.28), radius: 24, y: 8)
    }
}
