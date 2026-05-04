import SwiftUI

struct LeagueOverviewView: View {
    @EnvironmentObject private var appModel: AppModel

    private let heroColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        RoobScreen {
            ScreenHeader(
                eyebrow: "RoobLeague",
                title: "American Broomball",
                subtitle: "A polished U.S. league tracker built around real schedules, venues, standings, and tournament windows."
            )

            HeroCard(
                title: appModel.league.name,
                subtitle: "\(appModel.league.season). \(appModel.league.region)."
            ) {
                VStack(alignment: .leading, spacing: 14) {
                    LazyVGrid(columns: heroColumns, alignment: .leading, spacing: 12) {
                        StatPill(value: "\(appModel.league.trackedLeagues)", label: "Tracked leagues")
                        StatPill(value: "\(appModel.league.trackedTeams)", label: "Tracked teams")
                    }

                    NextEventCard(text: appModel.league.nextEventLabel)
                }
            }

            EditorialBanner(
                eyebrow: "League Command",
                headline: "An App For League Operators",
                bodyText: "RoobLeague is being rebuilt as a bold operational surface for broomball, with standings, match handling, venue logic, and season framing all in one product language."
            )

            VStack(spacing: 16) {
                SurfaceCard(title: "US Focus") {
                    Text("A real-data view of American broomball centered on active municipal leagues and tournament hubs.")
                        .foregroundStyle(RoobTheme.slate)
                        .fixedSize(horizontal: false, vertical: true)
                    SplitMetricRow(
                        leftTitle: "Venues",
                        leftValue: "\(appModel.league.trackedVenues)",
                        rightTitle: "Region",
                        rightValue: "US Midwest"
                    )
                }

                SurfaceCard(title: "Audience Mode") {
                    Picker("Role", selection: $appModel.selectedRole) {
                        ForEach(MembershipRole.allCases) { role in
                            Text(role.rawValue).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text(roleMessage)
                        .foregroundStyle(RoobTheme.slate)
                }
            }

            SurfaceCard(title: "Featured Leagues") {
                VStack(spacing: 16) {
                    ForEach(appModel.leagues) { league in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(league.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("\(league.season) • \(league.city)")
                                .foregroundStyle(RoobTheme.slate)
                            Text("\(league.format) • \(league.scheduleWindow)")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(RoobTheme.gold)
                            Text(league.detail)
                                .foregroundStyle(RoobTheme.slate)
                                .fixedSize(horizontal: false, vertical: true)
                            Label(league.venue, systemImage: "mappin.and.ellipse")
                                .font(.subheadline)
                                .foregroundStyle(RoobTheme.slate)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if league.id != appModel.leagues.last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }

            SurfaceCard(title: "Woodbury Standings Snapshot") {
                VStack(spacing: 12) {
                    ForEach(appModel.featuredWoodburyTeams) { team in
                        HStack(spacing: 14) {
                            Circle()
                                .fill(team.styleColor)
                                .frame(width: 14, height: 14)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("#\(team.ranking) \(team.name)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("\(team.record) • GF \(team.goalsFor) / GA \(team.goalsAgainst)")
                                    .font(.subheadline)
                                    .foregroundStyle(RoobTheme.slate)
                            }
                            Spacer()
                            Text("+\(team.goalDifference)")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(RoobTheme.gold)
                        }
                    }
                }
            }

            SurfaceCard(title: "League Feed") {
                VStack(spacing: 16) {
                    ForEach(appModel.announcements) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.tag.uppercased())
                                .font(.caption.weight(.bold))
                                .foregroundStyle(RoobTheme.gold)
                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text(item.detail)
                                .foregroundStyle(RoobTheme.slate)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if item.id != appModel.announcements.last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var roleMessage: String {
        switch appModel.selectedRole {
        case .player:
            return "Players see cleaner scoreboards, verified venues, and a schedule-first view of the American scene."
        case .captain:
            return "Captains get matchup context, travel-ready venue details, and easy comparisons between clubs."
        case .organizer:
            return "Organizers get the broadest lens: league windows, playoff timing, tournament anchors, and standings movement."
        }
    }
}

private struct InfoItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(RoobTheme.slate)
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
        }
    }
}

private struct NextEventCard: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("NEXT EVENT")
                .font(.caption.weight(.bold))
                .foregroundStyle(RoobTheme.gold)
            Text(text)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
