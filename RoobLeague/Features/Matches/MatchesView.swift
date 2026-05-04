import SwiftUI

struct MatchesView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var selectedMatch: Match?
    @State private var showingPlanComposer = false

    var body: some View {
        RoobScreen {
            ScreenHeader(
                eyebrow: "Match Control",
                title: "Everything For Match Control",
                subtitle: "Completed games open into full stat packs, future fixtures live in their own board, and your personal training schedule stays separate."
            )

            HeroCard(
                title: "Match Hub",
                subtitle: "Switch between completed results, upcoming fixtures, and your own private training or match notes."
            ) {
                SplitMetricRow(
                    leftTitle: "Completed",
                    leftValue: "\(appModel.completedMatches.count)",
                    rightTitle: "Upcoming",
                    rightValue: "\(appModel.upcomingMatches.count)"
                )
            }

            Picker("Match focus", selection: $appModel.matchFocus) {
                ForEach(MatchResultFocus.allCases) { focus in
                    Text(focus.rawValue).tag(focus)
                }
            }
            .pickerStyle(.segmented)

            switch appModel.matchFocus {
            case .completed:
                completedMatchesSection
            case .upcoming:
                upcomingMatchesSection
            case .personal:
                personalPlansSection
            }
        }
        .fullScreenCover(item: $selectedMatch) { match in
            MatchDetailView(match: match)
                .environmentObject(appModel)
        }
        .sheet(isPresented: $showingPlanComposer) {
            PersonalPlanComposer(isPresented: $showingPlanComposer)
                .environmentObject(appModel)
                .presentationDetents([.medium, .large])
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var completedMatchesSection: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "Completed Games",
                headline: "Tap Into Full Match Statistics",
                bodyText: "Every past result opens into attendance, period-by-period flow, team totals, and leaderboards."
            )

            SurfaceCard {
                VStack(spacing: 14) {
                    ForEach(appModel.completedMatches) { match in
                        Button {
                            selectedMatch = match
                        } label: {
                            MatchListCard(match: match, emphasis: "Open full report")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var upcomingMatchesSection: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "Upcoming Board",
                headline: "Dedicated Future Match Menu",
                bodyText: "A cleaner planning surface for who plays next, where it happens, and what each matchup means."
            )

            ForEach(groupedUpcomingMatches, id: \.0) { group in
                SurfaceCard(title: group.0) {
                    VStack(spacing: 14) {
                        ForEach(group.1) { match in
                            MatchListCard(match: match, emphasis: match.headline)
                        }
                    }
                }
            }
        }
    }

    private var personalPlansSection: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "My Schedule",
                headline: "Private Matches, Training, And Notes",
                bodyText: "Keep your own training sessions, light games, and strategy notes separate from public league fixtures."
            )

            SurfaceCard {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        showingPlanComposer = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create personal match or training note")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(16)
                        .background(RoobTheme.surfaceRaised.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    ForEach(appModel.personalPlans) { plan in
                        PersonalPlanCard(plan: plan)
                    }
                }
            }
        }
    }

    private var groupedUpcomingMatches: [(String, [Match])] {
        Dictionary(grouping: appModel.upcomingMatches, by: \.competition)
            .map { ($0.key, $0.value.sorted { $0.start < $1.start }) }
            .sorted { $0.0 < $1.0 }
    }
}

private struct MatchListCard: View {
    let match: Match
    let emphasis: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(match.week.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(RoobTheme.gold)
                Spacer()
                Text(match.status.rawValue.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.7))
            }

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(match.homeTeam)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text(match.awayTeam)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white.opacity(0.86))
                }
                Spacer()
                Text(match.scoreLine)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(RoobTheme.gold)
            }

            HStack {
                Label(match.venue, systemImage: "mappin.and.ellipse")
                Spacer()
                Text(match.start, format: .dateTime.month(.abbreviated).day().hour().minute())
            }
            .font(.subheadline)
            .foregroundStyle(RoobTheme.slate)

            Text(emphasis)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct MatchDetailView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss
    let match: Match

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
                eyebrow: match.competition,
                title: "\(match.homeTeam) vs \(match.awayTeam)",
                subtitle: match.headline
            )

            HeroCard(
                title: match.scoreLine,
                subtitle: "\(match.week) • \(match.venue)"
            ) {
                SplitMetricRow(
                    leftTitle: "Attendance",
                    leftValue: match.attendance.map(String.init) ?? "TBD",
                    rightTitle: "Status",
                    rightValue: match.status.rawValue
                )
            }

            SurfaceCard(title: "Game Flow") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(match.periodSummary, id: \.self) { period in
                        Text(period)
                            .foregroundStyle(.white)
                    }
                    Text(match.note)
                        .foregroundStyle(RoobTheme.slate)
                }
            }

            if let homeStats = match.homeStats, let awayStats = match.awayStats {
                SurfaceCard(title: "Team Statistics") {
                    VStack(spacing: 12) {
                        MatchStatComparisonRow(label: "Shots", homeValue: "\(homeStats.shots)", awayValue: "\(awayStats.shots)")
                        MatchStatComparisonRow(label: "Saves", homeValue: "\(homeStats.saves)", awayValue: "\(awayStats.saves)")
                        MatchStatComparisonRow(label: "Penalties", homeValue: "\(homeStats.penalties)", awayValue: "\(awayStats.penalties)")
                        MatchStatComparisonRow(label: "Faceoff Win %", homeValue: "\(homeStats.faceoffWinRate)%", awayValue: "\(awayStats.faceoffWinRate)%")
                        MatchStatComparisonRow(label: "Power Play", homeValue: homeStats.powerPlay, awayValue: awayStats.powerPlay)
                    }
                }
            }

            SurfaceCard(title: "Top Performers") {
                VStack(spacing: 12) {
                    ForEach(match.leaders) { player in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(player.playerName)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                Spacer()
                                Text(player.teamName)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(RoobTheme.gold)
                            }
                            Text("G \(player.goals) • A \(player.assists) • Saves \(player.saves) • +/- \(player.plusMinus)")
                                .foregroundStyle(RoobTheme.slate)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

private struct MatchStatComparisonRow: View {
    let label: String
    let homeValue: String
    let awayValue: String

    var body: some View {
        HStack {
            Text(homeValue)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(RoobTheme.gold)
            Text(awayValue)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private struct PersonalPlanCard: View {
    let plan: PersonalPlan

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(plan.type.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(RoobTheme.gold)
                Spacer()
                Text(plan.date, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(RoobTheme.slate)
            }
            Text(plan.title)
                .font(.headline)
                .foregroundStyle(.white)
            Label(plan.location, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
                .foregroundStyle(RoobTheme.slate)
            Text(plan.note)
                .foregroundStyle(.white.opacity(0.76))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct PersonalPlanComposer: View {
    @EnvironmentObject private var appModel: AppModel
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var type = "Training"
    @State private var note = ""

    private let types = ["Training", "Strategy", "Friendly", "Match Note"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Session") {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date)
                    TextField("Location", text: $location)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { value in
                            Text(value).tag(value)
                        }
                    }
                }

                Section("Notes") {
                    TextField("What are you planning?", text: $note, axis: .vertical)
                        .lineLimit(4...8)
                }
            }
            .scrollContentBackground(.hidden)
            .background(RoobTheme.pageGradient.ignoresSafeArea())
            .navigationTitle("New Personal Plan")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        appModel.addPersonalPlan(
                            title: title.isEmpty ? "Untitled session" : title,
                            date: date,
                            location: location.isEmpty ? "TBD" : location,
                            type: type,
                            note: note.isEmpty ? "No extra note yet." : note
                        )
                        isPresented = false
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
