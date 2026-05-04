import Foundation
import SwiftUI

enum MembershipRole: String, CaseIterable, Identifiable {
    case player = "Player"
    case captain = "Captain"
    case organizer = "Organizer"

    var id: String { rawValue }
}

enum MatchStatus: String, CaseIterable {
    case scheduled = "Scheduled"
    case final = "Final"
}

enum MatchResultFocus: String, CaseIterable, Identifiable {
    case completed = "Completed"
    case upcoming = "Upcoming"
    case personal = "My Matches"

    var id: String { rawValue }
}

enum CalendarMode: String, CaseIterable, Identifiable {
    case training = "Drill Run"
    case strategy = "Rink Tactics"
    case play = "Quick Play"

    var id: String { rawValue }
}

enum InsightKind: String, Identifiable, CaseIterable {
    case momentum
    case scoring
    case venue
    case availability

    var id: String { rawValue }
}

struct League: Identifiable {
    let id = UUID()
    let name: String
    let season: String
    let region: String
    let nextEventLabel: String
    let trackedLeagues: Int
    let trackedTeams: Int
    let trackedVenues: Int
}

struct TrackedLeague: Identifiable {
    let id = UUID()
    let name: String
    let season: String
    let city: String
    let format: String
    let scheduleWindow: String
    let venue: String
    let detail: String
    let sourceLine: String
}

struct PlayerProfile: Identifiable, Hashable {
    let id = UUID()
    let number: Int
    let name: String
    let role: String
    let shoots: String
    let hometown: String
    let note: String
}

struct MatchPlayerStat: Identifiable {
    let id = UUID()
    let playerName: String
    let teamName: String
    let goals: Int
    let assists: Int
    let saves: Int
    let plusMinus: Int
}

struct MatchTeamStats {
    let shots: Int
    let saves: Int
    let penalties: Int
    let faceoffWinRate: Int
    let powerPlay: String
}

struct Team: Identifiable {
    let id = UUID()
    let competition: String
    let name: String
    let city: String
    let division: String
    let record: String
    let ranking: Int
    let nationalRanking: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let points: Int
    let manager: String
    let venue: String
    let note: String
    let styleColor: Color
    let secondaryColor: Color
    let logoText: String
    let established: String
    let roster: [PlayerProfile]

    var goalDifference: Int { goalsFor - goalsAgainst }
    var winRateLabel: String {
        let parts = record.split(separator: "-").compactMap { Int($0) }
        guard parts.count >= 2 else { return "--" }
        let games = parts.reduce(0, +)
        guard games > 0 else { return "--" }
        let value = Double(parts[0]) / Double(games)
        return "\(Int((value * 100).rounded()))%"
    }
}

struct Match: Identifiable {
    let id = UUID()
    let competition: String
    let week: String
    let homeTeam: String
    let awayTeam: String
    let venue: String
    let start: Date
    let status: MatchStatus
    let homeScore: Int?
    let awayScore: Int?
    let note: String
    let attendance: Int?
    let periodSummary: [String]
    let headline: String
    let homeStats: MatchTeamStats?
    let awayStats: MatchTeamStats?
    let leaders: [MatchPlayerStat]

    var scoreLine: String {
        if let homeScore, let awayScore {
            return "\(homeScore) - \(awayScore)"
        }
        return "vs"
    }

    var isCompleted: Bool { status == .final }
}

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let location: String
    let category: String
    let detail: String
}

struct Announcement: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let tag: String
}

struct VenueProfile: Identifiable {
    let id = UUID()
    let name: String
    let city: String
    let detail: String
    let venueNote: String
    let sourceLine: String
}

struct TrendPoint: Identifiable {
    let id = UUID()
    let series: String
    let label: String
    let step: Int
    let value: Double
}

struct MetricBar: Identifiable {
    let id = UUID()
    let team: String
    let category: String
    let value: Double
    let color: Color
}

struct PersonalPlan: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let location: String
    let type: String
    let note: String
}

struct StrategyPreset: Identifiable {
    let id = UUID()
    let title: String
    let emphasis: String
    let zoneNotes: [RinkZoneNote]
}

struct RinkZoneNote: Identifiable {
    let id = UUID()
    let zone: String
    let title: String
    let detail: String
}

struct TrainingBlock: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let intensity: String
    let objective: String
}

struct InsightReport: Identifiable {
    let id = UUID()
    let kind: InsightKind
    let title: String
    let summary: String
    let metric: String
    let bullets: [String]
}
