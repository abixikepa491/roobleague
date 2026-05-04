import SwiftUI

struct TeamsView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var selectedTeam: Team?

    private let columns = [
        GridItem(.adaptive(minimum: 280), spacing: 16)
    ]

    var body: some View {
        RoobScreen {
            ScreenHeader(
                eyebrow: "Team Directory",
                title: "Real Teams, Full Profiles",
                subtitle: "A complete list of tracked teams with rankings, logos, roster cards, and team detail pages for match context."
            )

            HeroCard(
                title: "US Power Ranking",
                subtitle: "All tracked teams are stacked in one national board while still preserving their real local competition standings."
            ) {
                SplitMetricRow(
                    leftTitle: "Tracked clubs",
                    leftValue: "\(appModel.teams.count)",
                    rightTitle: "Ranked markets",
                    rightValue: "2"
                )
            }

            SurfaceCard(title: "National Power Board") {
                VStack(spacing: 14) {
                    ForEach(appModel.powerRankedTeams) { team in
                        Button {
                            selectedTeam = team
                        } label: {
                            HStack(spacing: 14) {
                                TeamLogoView(primary: team.styleColor, secondary: team.secondaryColor, text: team.logoText, size: 54)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("#\(team.nationalRanking) \(team.name)")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("\(team.city) • \(team.record) • \(team.points) pts")
                                        .foregroundStyle(RoobTheme.slate)
                                }
                                Spacer()
                                Text(team.competition)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(RoobTheme.gold)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoobTheme.surfaceRaised.opacity(0.82))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            ForEach(appModel.groupedTeams, id: \.0) { group in
                EditorialBanner(
                    eyebrow: group.0,
                    headline: "Tap Any Team For Full Club Information",
                    bodyText: "Every card opens into roster depth, recent games, core stats, and venue context."
                )

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(group.1) { team in
                        Button {
                            selectedTeam = team
                        } label: {
                            TeamCard(team: team)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedTeam) { team in
            TeamDetailView(team: team)
                .environmentObject(appModel)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct TeamCard: View {
    let team: Team

    var body: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    TeamLogoView(primary: team.styleColor, secondary: team.secondaryColor, text: team.logoText)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(team.name.uppercased())
                            .font(.headline.weight(.black))
                            .foregroundStyle(.white)
                        Text(team.city)
                            .foregroundStyle(RoobTheme.slate)
                    }
                    Spacer()
                    Text("#\(team.ranking)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(RoobTheme.gold)
                }

                SplitMetricRow(
                    leftTitle: "Record",
                    leftValue: team.record,
                    rightTitle: "Points",
                    rightValue: "\(team.points)"
                )

                SplitMetricRow(
                    leftTitle: "Goal Diff",
                    leftValue: "\(team.goalDifference)",
                    rightTitle: "US Rank",
                    rightValue: "#\(team.nationalRanking)"
                )

                Text(team.note)
                    .foregroundStyle(RoobTheme.slate)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct TeamDetailView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss
    let team: Team

    var body: some View {
        RoobScreen {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(RoobTheme.surfaceRaised.opacity(0.96))
                        )
                }
                .buttonStyle(.plain)
            }

            ScreenHeader(
                eyebrow: team.competition,
                title: team.name,
                subtitle: "\(team.city) • Established \(team.established) • Managed by \(team.manager)"
            )

            HeroCard(
                title: "#\(team.nationalRanking) US Rank",
                subtitle: "\(team.record) • \(team.points) pts • \(team.winRateLabel) win rate"
            ) {
                HStack(spacing: 16) {
                    TeamLogoView(primary: team.styleColor, secondary: team.secondaryColor, text: team.logoText, size: 74)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(team.division)
                            .foregroundStyle(.white.opacity(0.86))
                        Text(team.venue)
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    Spacer()
                }
            }

            SurfaceCard(title: "Club Snapshot") {
                VStack(alignment: .leading, spacing: 12) {
                    Text(team.note)
                        .foregroundStyle(RoobTheme.slate)
                    SplitMetricRow(
                        leftTitle: "Goals For",
                        leftValue: "\(team.goalsFor)",
                        rightTitle: "Goals Against",
                        rightValue: "\(team.goalsAgainst)"
                    )
                }
            }

            SurfaceCard(title: "Roster") {
                VStack(spacing: 14) {
                    ForEach(team.roster) { player in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("#\(player.number) \(player.name)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text(player.role)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(RoobTheme.gold)
                            }
                            Text("\(player.hometown) • Shoots \(player.shoots)")
                                .foregroundStyle(RoobTheme.slate)
                            Text(player.note)
                                .foregroundStyle(.white.opacity(0.78))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if player.id != team.roster.last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }

            SurfaceCard(title: "Recent And Upcoming Matches") {
                VStack(spacing: 12) {
                    ForEach(appModel.matches(for: team).prefix(6)) { match in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(match.homeTeam) vs \(match.awayTeam)")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("\(match.week) • \(match.scoreLine) • \(match.venue)")
                                .foregroundStyle(RoobTheme.slate)
                            Text(match.headline)
                                .foregroundStyle(.white.opacity(0.74))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if match.id != appModel.matches(for: team).prefix(6).last?.id {
                            Divider().overlay(.white.opacity(0.08))
                        }
                    }
                }
            }
        }
    }
}
