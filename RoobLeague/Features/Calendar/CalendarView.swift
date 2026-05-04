import SwiftUI

struct LeagueCalendarView: View {
    @EnvironmentObject private var appModel: AppModel

    @State private var selectedTrainingFocus = "Transition"
    @State private var selectedZone = "Neutral"
    @State private var score = 240
    @State private var streak = 3
    @State private var energy = 82
    @State private var selectedQuickAction = "Pass"
    @State private var quickCombo: [String] = []
    @State private var completedDrills: Set<String> = []
    @State private var tacticalDeploys = 0

    private let trainingFocuses = [
        "Transition",
        "Forecheck",
        "Finishing",
        "Goalie Support"
    ]

    private let quickActions = [
        "Steal",
        "Pass",
        "Shoot",
        "Screen"
    ]

    var body: some View {
        RoobScreen {
            ScreenHeader(
                eyebrow: "Ice Arcade",
                title: "Play The Rink",
                subtitle: "This screen is now a broomball game mechanic. Run drills, deploy tactics on the rink, and build quick-play combos instead of browsing a calendar."
            )

            HeroCard(
                title: "Game Mode",
                subtitle: "Train for points, stack streaks, and keep your on-ice energy alive across drill, tactics, and quick-play runs."
            ) {
                VStack(spacing: 12) {
                    SplitMetricRow(
                        leftTitle: "Score",
                        leftValue: "\(score)",
                        rightTitle: "Streak",
                        rightValue: "\(streak)x"
                    )

                    SplitMetricRow(
                        leftTitle: "Energy",
                        leftValue: "\(energy)%",
                        rightTitle: "Deploys",
                        rightValue: "\(tacticalDeploys)"
                    )
                }
            }

            Picker("Play Mode", selection: $appModel.calendarMode) {
                ForEach(CalendarMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            switch appModel.calendarMode {
            case .training:
                drillRunView
            case .strategy:
                tacticsView
            case .play:
                quickPlayView
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var drillRunView: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "Drill Run",
                headline: "Complete Drills To Level Up",
                bodyText: "Pick a focus, clear the session blocks, and turn every completed broomball drill into score, streak, and energy management."
            )

            SurfaceCard(title: "Training Focus") {
                FlowLayout(spacing: 10) {
                    ForEach(trainingFocuses, id: \.self) { focus in
                        Button {
                            selectedTrainingFocus = focus
                        } label: {
                            ActionChip(title: focus, selected: selectedTrainingFocus == focus)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            SurfaceCard(title: "Drill Board") {
                VStack(spacing: 12) {
                    ForEach(appModel.trainingBlocks) { block in
                        DrillMissionCard(
                            block: block,
                            isCompleted: completedDrills.contains(block.title),
                            points: drillPoints(for: block),
                            onComplete: {
                                completeDrill(block)
                            }
                        )
                    }
                }
            }

            SurfaceCard(title: "Run Status") {
                VStack(spacing: 12) {
                    SplitMetricRow(
                        leftTitle: "Cleared drills",
                        leftValue: "\(completedDrills.count)/\(appModel.trainingBlocks.count)",
                        rightTitle: "Current focus",
                        rightValue: selectedTrainingFocus
                    )

                    Text(trainingFlavorText)
                        .foregroundStyle(RoobTheme.slate)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var tacticsView: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "Rink Tactics",
                headline: "Tap Zones And Deploy Shape",
                bodyText: "Use the rink like a board-game surface. Choose a system, light up a zone, and deploy tactical pressure for live broomball reads."
            )

            strategyPicker
            tacticalBoard

            if let strategy = appModel.selectedStrategy {
                SurfaceCard(title: "Selected Deploy") {
                    VStack(alignment: .leading, spacing: 12) {
                        if let note = selectedZoneNote(for: strategy) {
                            StrategyLineCard(note: note)
                        }

                        SplitMetricRow(
                            leftTitle: "Deploy count",
                            leftValue: "\(tacticalDeploys)",
                            rightTitle: "Active zone",
                            rightValue: selectedZone
                        )

                        Button {
                            deployTactic()
                        } label: {
                            Text("Deploy \(selectedZone) Pressure")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(RoobTheme.ink)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(RoobTheme.gold))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var quickPlayView: some View {
        VStack(spacing: 18) {
            EditorialBanner(
                eyebrow: "Quick Play",
                headline: "Build A Rush Combo",
                bodyText: "Chain broomball actions into a fast attack. Every tap updates the combo lane, score flow, and your energy balance like a lightweight arcade loop."
            )

            SurfaceCard(title: "Action Deck") {
                FlowLayout(spacing: 10) {
                    ForEach(quickActions, id: \.self) { action in
                        Button {
                            selectedQuickAction = action
                            play(action)
                        } label: {
                            ActionChip(title: action, selected: selectedQuickAction == action)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            SurfaceCard(title: "Current Combo") {
                VStack(spacing: 12) {
                    if quickCombo.isEmpty {
                        Text("Start with a steal, move the ball, then finish the rush.")
                            .foregroundStyle(RoobTheme.slate)
                    } else {
                        FlowLayout(spacing: 10) {
                            ForEach(Array(quickCombo.enumerated()), id: \.offset) { _, action in
                                Text(action)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(RoobTheme.surfaceRaised.opacity(0.95)))
                            }
                        }
                    }

                    SplitMetricRow(
                        leftTitle: "Combo score",
                        leftValue: "\(comboPoints)",
                        rightTitle: "Rush rating",
                        rightValue: comboLabel
                    )

                    Button {
                        resetCombo()
                    } label: {
                        Text("Reset Rush")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(RoobTheme.surfaceRaised.opacity(0.92)))
                    }
                    .buttonStyle(.plain)
                }
            }

            SurfaceCard(title: "Arcade Goals") {
                VStack(spacing: 12) {
                    QuickGoalRow(title: "3-touch rush", detail: "Land a clean sequence with `Steal`, `Pass`, and `Shoot` for the sharpest quick-play bonus.")
                    QuickGoalRow(title: "Net-front chaos", detail: "Drop `Screen` into the combo to boost your finishing threat and pressure value.")
                    QuickGoalRow(title: "Streak keeper", detail: "Every strong combo extends your streak, but overplaying `Shoot` drains energy fast.")
                }
            }
        }
    }

    private var strategyPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(appModel.strategyPresets) { preset in
                    Button {
                        appModel.selectedStrategyID = preset.id
                        selectedZone = "Neutral"
                    } label: {
                        ActionChip(title: preset.title, selected: appModel.selectedStrategyID == preset.id)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var tacticalBoard: some View {
        SurfaceCard(title: "Rink Control") {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = min(max(220, width * 0.48), 320)

                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(.white.opacity(0.16), lineWidth: 1.5)
                        )

                    VStack(spacing: 0) {
                        tacticalZone(title: "Forecheck", symbol: "bolt.fill", height: height * 0.30)
                        Divider().overlay(.white.opacity(0.14))
                        tacticalZone(title: "Neutral", symbol: "arrow.left.and.right", height: height * 0.34)
                        Divider().overlay(.white.opacity(0.14))
                        tacticalZone(title: "Defensive", symbol: "shield.fill", height: height * 0.30)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                    Circle()
                        .stroke(.white.opacity(0.18), lineWidth: 1.5)
                        .frame(width: height * 0.30, height: height * 0.30)

                    VStack {
                        HStack {
                            IceMarker(title: "F1")
                            Spacer()
                            IceMarker(title: "F2")
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            IceMarker(title: "C")
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            IceMarker(title: "D1")
                            Spacer()
                            IceMarker(title: "D2")
                        }
                    }
                    .padding(28)
                }
                .frame(height: height)
            }
            .frame(height: 260)
        }
    }

    private func tacticalZone(title: String, symbol: String, height: CGFloat) -> some View {
        Button {
            selectedZone = title
        } label: {
            ZStack {
                (selectedZone == title ? RoobTheme.plum.opacity(0.45) : Color.clear)

                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Label(title, systemImage: symbol)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                        Text(zoneSummary(for: title))
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.74))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
            }
            .frame(height: height)
        }
        .buttonStyle(.plain)
    }

    private var trainingFlavorText: String {
        switch selectedTrainingFocus {
        case "Forecheck":
            return "This run rewards fast first pressure and cleaner support angles after the first touch."
        case "Finishing":
            return "Lean into quick release timing, rebound recovery, and net-front lane occupation."
        case "Goalie Support":
            return "Treat every rep as a goalie-friendly breakout where low support matters more than speed alone."
        default:
            return "Prioritize clean transition: first pass, middle-lane support, and quick shape recovery."
        }
    }

    private var comboPoints: Int {
        var total = quickCombo.count * 12
        if quickCombo.contains("Pass") && quickCombo.contains("Shoot") {
            total += 18
        }
        if quickCombo.contains("Screen") {
            total += 10
        }
        if quickCombo.prefix(3).elementsEqual(["Steal", "Pass", "Shoot"]) {
            total += 24
        }
        return total
    }

    private var comboLabel: String {
        switch comboPoints {
        case 0..<20:
            return "Setup"
        case 20..<45:
            return "Danger"
        case 45..<70:
            return "Chance"
        default:
            return "Goal Rush"
        }
    }

    private func drillPoints(for block: TrainingBlock) -> Int {
        switch block.intensity {
        case "High":
            return 36
        case "Light":
            return 18
        default:
            return 28
        }
    }

    private func completeDrill(_ block: TrainingBlock) {
        guard !completedDrills.contains(block.title) else { return }
        completedDrills.insert(block.title)
        score += drillPoints(for: block)
        streak += 1
        energy = max(20, min(100, energy - 6))
    }

    private func deployTactic() {
        tacticalDeploys += 1
        score += 22
        streak += 1
        energy = max(20, energy - 4)
    }

    private func play(_ action: String) {
        quickCombo.append(action)
        if quickCombo.count > 4 {
            quickCombo.removeFirst()
        }

        score += 8
        energy = max(18, energy - (action == "Shoot" ? 6 : 3))

        if comboPoints >= 45 {
            streak += 1
        }
    }

    private func resetCombo() {
        quickCombo.removeAll()
        selectedQuickAction = "Pass"
        energy = min(100, energy + 12)
    }

    private func zoneSummary(for zone: String) -> String {
        guard let strategy = appModel.selectedStrategy,
              let note = strategy.zoneNotes.first(where: { $0.zone == zone }) else {
            return "Tap this lane to assign pressure."
        }
        return note.title
    }

    private func selectedZoneNote(for strategy: StrategyPreset) -> RinkZoneNote? {
        strategy.zoneNotes.first { $0.zone == selectedZone }
    }
}

private struct DrillMissionCard: View {
    let block: TrainingBlock
    let isCompleted: Bool
    let points: Int
    let onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(block.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text("+\(points)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(RoobTheme.gold)
            }

            Text(block.objective)
                .foregroundStyle(RoobTheme.slate)
                .fixedSize(horizontal: false, vertical: true)

            SplitMetricRow(
                leftTitle: "Duration",
                leftValue: block.duration,
                rightTitle: "Intensity",
                rightValue: block.intensity
            )

            Button {
                onComplete()
            } label: {
                Text(isCompleted ? "Completed" : "Clear Drill")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(isCompleted ? .white.opacity(0.7) : RoobTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(isCompleted ? RoobTheme.surfaceRaised.opacity(0.72) : RoobTheme.gold)
                    )
            }
            .buttonStyle(.plain)
            .disabled(isCompleted)
        }
        .padding(16)
        .background(RoobTheme.surfaceRaised.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

private struct StrategyLineCard: View {
    let note: RinkZoneNote

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.zone.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(RoobTheme.gold)
            Text(note.title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            Text(note.detail)
                .foregroundStyle(RoobTheme.slate)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoobTheme.surfaceRaised.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct IceMarker: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption.weight(.bold))
            .foregroundStyle(RoobTheme.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Capsule().fill(RoobTheme.gold))
    }
}

private struct QuickGoalRow: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
            Text(detail)
                .foregroundStyle(RoobTheme.slate)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(RoobTheme.surfaceRaised.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
