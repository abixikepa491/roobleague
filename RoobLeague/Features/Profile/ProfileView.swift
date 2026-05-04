import Charts
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var selectedInsight: InsightReport?

    var body: some View {
        RoobScreen {
            ScreenHeader(
                eyebrow: "Insights",
                title: "Full Insight Reports",
                subtitle: "Bigger analytics cards, deeper summaries, and tap-through detail pages for every insight."
            )

            HeroCard(
                title: "Analytics Center",
                subtitle: "Track momentum, scoring shape, venue edge, and your own availability pressure from one product surface."
            ) {
                SplitMetricRow(
                    leftTitle: "Insight reports",
                    leftValue: "\(appModel.insightReports.count)",
                    rightTitle: "Tracked series",
                    rightValue: "\(Set(appModel.momentum.map(\.series)).count)"
                )
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: 16)], spacing: 16) {
                ForEach(appModel.insightReports) { report in
                    Button {
                        selectedInsight = report
                    } label: {
                        InsightCard(report: report)
                    }
                    .buttonStyle(.plain)
                }
            }

            SurfaceCard(title: "Quick Read") {
                Chart(appModel.momentum) { point in
                    LineMark(
                        x: .value("Week", point.step),
                        y: .value("Points", point.value)
                    )
                    .foregroundStyle(by: .value("Club", point.series))
                    .lineStyle(.init(lineWidth: 3, lineCap: .round))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 260)
            }
        }
        .fullScreenCover(item: $selectedInsight) { report in
            InsightDetailView(report: report)
                .environmentObject(appModel)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct InsightCard: View {
    let report: InsightReport

    var body: some View {
        SurfaceCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(report.title.uppercased())
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)
                Text(report.summary)
                    .foregroundStyle(RoobTheme.slate)
                    .fixedSize(horizontal: false, vertical: true)
                Text(report.metric)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(RoobTheme.gold)
                Text("Open full report")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
            }
        }
    }
}

private struct InsightDetailView: View {
    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismiss) private var dismiss
    let report: InsightReport

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
                eyebrow: "Insight Report",
                title: report.title,
                subtitle: report.summary
            )

            HeroCard(
                title: report.metric,
                subtitle: "Full view with supporting chart and interpretation."
            ) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(report.bullets, id: \.self) { bullet in
                        Text("• \(bullet)")
                            .foregroundStyle(.white.opacity(0.84))
                    }
                }
            }

            chartSection

            SurfaceCard(title: "Analyst Notes") {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(report.bullets, id: \.self) { bullet in
                        Text(bullet)
                            .foregroundStyle(RoobTheme.slate)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var chartSection: some View {
        switch report.kind {
        case .momentum:
            SurfaceCard(title: "Momentum Curve") {
                Chart(appModel.momentum) { point in
                    LineMark(
                        x: .value("Week", point.step),
                        y: .value("Points", point.value)
                    )
                    .foregroundStyle(by: .value("Club", point.series))
                    .lineStyle(.init(lineWidth: 3, lineCap: .round))

                    AreaMark(
                        x: .value("Week", point.step),
                        y: .value("Points", point.value)
                    )
                    .foregroundStyle(by: .value("Club", point.series))
                    .opacity(0.12)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 300)
            }
        case .scoring:
            SurfaceCard(title: "Goals For vs Goals Against") {
                Chart(appModel.goalMetrics) { item in
                    BarMark(
                        x: .value("Team", item.team),
                        y: .value("Goals", item.value)
                    )
                    .foregroundStyle(item.color)
                    .position(by: .value("Category", item.category))
                    .cornerRadius(6)
                }
                .frame(height: 320)
            }
        case .venue:
            SurfaceCard(title: "Venue Load") {
                Chart(appModel.venues.prefix(4), id: \.id) { venue in
                    BarMark(
                        x: .value("Venue", venue.name),
                        y: .value("Weight", Double(venue.detail.count / 12))
                    )
                    .foregroundStyle(RoobTheme.gold)
                }
                .frame(height: 280)
            }
        case .availability:
            SurfaceCard(title: "Personal Load") {
                Chart(appModel.personalPlans) { plan in
                    BarMark(
                        x: .value("Type", plan.type),
                        y: .value("Count", 1)
                    )
                    .foregroundStyle(RoobTheme.plum)
                }
                .frame(height: 260)
            }
        }
    }
}
