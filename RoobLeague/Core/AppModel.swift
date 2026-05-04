import Foundation
import SwiftUI

final class AppModel: ObservableObject {
    @Published var selectedRole: MembershipRole = .organizer
    @Published var matchFocus: MatchResultFocus = .completed
    @Published var calendarMode: CalendarMode = .training
    @Published var selectedStrategyID: StrategyPreset.ID?
    @Published var personalPlans: [PersonalPlan]

    let league = League(
        name: "RoobLeague USA",
        season: "2026 American Broomball Tracker",
        region: "United States • Midwest-first data curation",
        nextEventLabel: "ABA Nationals • Apr 16-19 • Minneapolis",
        trackedLeagues: 5,
        trackedTeams: 10,
        trackedVenues: 6
    )

    let announcements: [Announcement]
    let leagues: [TrackedLeague]
    let teams: [Team]
    let matches: [Match]
    let events: [CalendarEvent]
    let venues: [VenueProfile]
    let momentum: [TrendPoint]
    let goalMetrics: [MetricBar]
    let strategyPresets: [StrategyPreset]
    let trainingBlocks: [TrainingBlock]
    let insightReports: [InsightReport]

    init() {
        announcements = [
            Announcement(
                title: "Minneapolis spring broomball runs through June 14",
                detail: "The Minneapolis Park and Recreation Board lists a Sunday indoor spring league at Parade South Rink from April 12 to June 14, 2026 with Competitive, Blue Rec, and Green Rec offerings.",
                tag: "Minneapolis"
            ),
            Announcement(
                title: "Saint Paul staged a full 2025-26 municipal season",
                detail: "Saint Paul's city league began the week of December 8, 2025 and offered Men's Upper/Lower, Women's C/D, and Coed D with optional playoffs on February 7-8, 2026.",
                tag: "Saint Paul"
            ),
            Announcement(
                title: "Minnetonka's winter league was an eight-game Thursday run",
                detail: "Minnetonka's men's Thursday season started January 8, 2026 and used Valley Park plus Harley-Hopkins Park before a one-night playoff round.",
                tag: "Minnetonka"
            ),
            Announcement(
                title: "ABA Nationals and AEB State were both on the 2026 calendar",
                detail: "The Minnesota Broomball Program listed AEB Minnesota State for March 12-15 at Augsburg and ABA Nationals for April 16-19 in Minneapolis.",
                tag: "National"
            )
        ]

        leagues = [
            TrackedLeague(
                name: "Woodbury Adult Broomball League",
                season: "Winter 2026",
                city: "Woodbury, Minnesota",
                format: "Co-Rec • 6-game season",
                scheduleWindow: "January 4 - February 8, 2026",
                venue: "M Health Fairview Sports Center / MHFV Ice Rink",
                detail: "Official TeamSideline standings show four clubs in the 2026 CoRec league with weekly fixtures at MHFV Ice Rink.",
                sourceLine: "Woodbury TeamSideline + City of Woodbury"
            ),
            TrackedLeague(
                name: "Des Moines Co-Ed Broomball",
                season: "Winter 2026",
                city: "Des Moines, Iowa",
                format: "Co-Ed municipal league",
                scheduleWindow: "December 21, 2025 - February 15, 2026",
                venue: "Brenton Skating Plaza",
                detail: "The Des Moines TeamSideline listing exposes six clubs, weekly results, byes, and the city playoff ladder.",
                sourceLine: "Des Moines TeamSideline"
            ),
            TrackedLeague(
                name: "Minneapolis Adult Broomball Spring League",
                season: "Spring 2026",
                city: "Minneapolis, Minnesota",
                format: "Sunday Co-Ed 6 • Competitive / Blue Rec / Green Rec",
                scheduleWindow: "April 12 - June 14, 2026",
                venue: "Parade South Rink",
                detail: "MPRB framed spring as the indoor extension of winter play with three Sunday co-ed tiers.",
                sourceLine: "Minneapolis Park and Recreation Board"
            ),
            TrackedLeague(
                name: "Saint Paul Adult Broomball",
                season: "2025-26 Winter",
                city: "Saint Paul, Minnesota",
                format: "Men's Upper/Lower • Women's C/D • Coed D",
                scheduleWindow: "Week of December 8, 2025 - early February 2026",
                venue: "McMurray Fields",
                detail: "Saint Paul centralized league operations at McMurray Fields and published a February 7-8 playoff weekend.",
                sourceLine: "City of Saint Paul"
            ),
            TrackedLeague(
                name: "Minnetonka Men's Thursday League",
                season: "Winter 2026",
                city: "Minnetonka / Hopkins, Minnesota",
                format: "Men's Thursday • 8 regular-season games",
                scheduleWindow: "Starting January 8, 2026",
                venue: "Valley Park and Harley-Hopkins Park",
                detail: "Minnetonka described a six-week outdoor season with two double-header nights and a one-night playoff finish.",
                sourceLine: "City of Minnetonka"
            )
        ]

        teams = [
            Team(
                competition: "Woodbury 2026 CoRec",
                name: "Hurth Homes",
                city: "Woodbury, MN",
                division: "CoRec Broomball",
                record: "1-0-0",
                ranking: 1,
                nationalRanking: 2,
                goalsFor: 9,
                goalsAgainst: 2,
                points: 2,
                manager: "Justin Hayes",
                venue: "MHFV Ice Rink",
                note: "Opened the season with a 9-2 win over The Hustlers and currently owns the best goal differential.",
                styleColor: Color(hex: "#FDBA12"),
                secondaryColor: Color(hex: "#15315F"),
                logoText: "HH",
                established: "2018",
                roster: [
                    PlayerProfile(number: 7, name: "Mason Clark", role: "Captain", shoots: "Left", hometown: "Woodbury", note: "Leads the first forecheck unit."),
                    PlayerProfile(number: 12, name: "Derek Larson", role: "Center", shoots: "Right", hometown: "Stillwater", note: "Primary faceoff specialist."),
                    PlayerProfile(number: 22, name: "Luke Mercer", role: "Wing", shoots: "Left", hometown: "Cottage Grove", note: "Transition driver off the wall."),
                    PlayerProfile(number: 31, name: "Evan Brooks", role: "Goalie", shoots: "Right", hometown: "Saint Paul", note: "Posted 18 saves in Week 1.")
                ]
            ),
            Team(
                competition: "Woodbury 2026 CoRec",
                name: "Scorey Corey's",
                city: "Woodbury, MN",
                division: "CoRec Broomball",
                record: "1-0-0",
                ranking: 2,
                nationalRanking: 4,
                goalsFor: 3,
                goalsAgainst: 1,
                points: 2,
                manager: "Hobey Stanton",
                venue: "MHFV Ice Rink",
                note: "Won the tighter opening fixture 3-1 and sits second on early defense.",
                styleColor: Color(hex: "#E39B00"),
                secondaryColor: Color(hex: "#081A36"),
                logoText: "SC",
                established: "2020",
                roster: [
                    PlayerProfile(number: 9, name: "Corey Bell", role: "Captain", shoots: "Right", hometown: "Woodbury", note: "Top scoring organizer."),
                    PlayerProfile(number: 14, name: "Ty James", role: "Wing", shoots: "Right", hometown: "Maplewood", note: "Fast weak-side release."),
                    PlayerProfile(number: 18, name: "Cole Peterson", role: "Defense", shoots: "Left", hometown: "Oakdale", note: "Runs the breakout shape."),
                    PlayerProfile(number: 30, name: "Nate Hughes", role: "Goalie", shoots: "Left", hometown: "Hudson", note: "Stopped 13 of 14 in opener.")
                ]
            ),
            Team(
                competition: "Woodbury 2026 CoRec",
                name: "Wild Bunch",
                city: "Woodbury, MN",
                division: "CoRec Broomball",
                record: "0-1-0",
                ranking: 3,
                nationalRanking: 8,
                goalsFor: 1,
                goalsAgainst: 3,
                points: 0,
                manager: "Michael Bauer",
                venue: "MHFV Ice Rink",
                note: "A one-goal game separated Wild Bunch from an opening-night result; Week 2 brings Hurth Homes.",
                styleColor: Color(hex: "#5A33A2"),
                secondaryColor: Color(hex: "#102A54"),
                logoText: "WB",
                established: "2017",
                roster: [
                    PlayerProfile(number: 4, name: "Grant Miller", role: "Defense", shoots: "Left", hometown: "Woodbury", note: "Best penalty-kill communicator."),
                    PlayerProfile(number: 11, name: "Ian Blake", role: "Captain", shoots: "Right", hometown: "Afton", note: "Carries most zone entries."),
                    PlayerProfile(number: 17, name: "Alec Ford", role: "Wing", shoots: "Left", hometown: "Saint Paul", note: "Quick-release finisher."),
                    PlayerProfile(number: 35, name: "Chris Nolan", role: "Goalie", shoots: "Right", hometown: "Lakeland", note: "Kept them alive in the third.")
                ]
            ),
            Team(
                competition: "Woodbury 2026 CoRec",
                name: "The Hustlers",
                city: "Woodbury, MN",
                division: "CoRec Broomball",
                record: "0-1-0",
                ranking: 4,
                nationalRanking: 10,
                goalsFor: 2,
                goalsAgainst: 9,
                points: 0,
                manager: "Jameson Heaston",
                venue: "MHFV Ice Rink",
                note: "Needs a rebound against Scorey Corey's after conceding nine in the opener.",
                styleColor: Color(hex: "#44207D"),
                secondaryColor: Color(hex: "#15315F"),
                logoText: "TH",
                established: "2016",
                roster: [
                    PlayerProfile(number: 6, name: "Austin Reeve", role: "Center", shoots: "Right", hometown: "Roseville", note: "Best rush threat on the roster."),
                    PlayerProfile(number: 15, name: "Jason Pike", role: "Wing", shoots: "Left", hometown: "Woodbury", note: "Late-slot finisher."),
                    PlayerProfile(number: 21, name: "Noah Prince", role: "Defense", shoots: "Right", hometown: "Eagan", note: "Heavy first pass under pressure."),
                    PlayerProfile(number: 33, name: "Ben Hall", role: "Goalie", shoots: "Left", hometown: "Saint Paul", note: "Faced the busiest shot volume in Week 1.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "Ice Monkeys",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "4-0-1",
                ranking: 1,
                nationalRanking: 1,
                goalsFor: 9,
                goalsAgainst: 3,
                points: 9,
                manager: "Erickson",
                venue: "Brenton Skating Plaza",
                note: "Unbeaten through five games with only three goals allowed.",
                styleColor: Color(hex: "#7E57C2"),
                secondaryColor: Color(hex: "#0E2246"),
                logoText: "IM",
                established: "2014",
                roster: [
                    PlayerProfile(number: 8, name: "Haley Erickson", role: "Captain", shoots: "Right", hometown: "Des Moines", note: "Directs the top transition line."),
                    PlayerProfile(number: 13, name: "Riley Cook", role: "Center", shoots: "Left", hometown: "Urbandale", note: "Best faceoff rate in the division."),
                    PlayerProfile(number: 19, name: "Cam Wirth", role: "Defense", shoots: "Right", hometown: "Ankeny", note: "Leads exits with control."),
                    PlayerProfile(number: 30, name: "Jess Nolan", role: "Goalie", shoots: "Left", hometown: "Clive", note: "Owns the strongest save profile in league play.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "Ballhawgs",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "4-1-0",
                ranking: 2,
                nationalRanking: 3,
                goalsFor: 12,
                goalsAgainst: 2,
                points: 8,
                manager: "Bolander",
                venue: "Brenton Skating Plaza",
                note: "The most explosive offense in the Des Moines table at +10 goal difference.",
                styleColor: Color(hex: "#FDBA12"),
                secondaryColor: Color(hex: "#081A36"),
                logoText: "BH",
                established: "2015",
                roster: [
                    PlayerProfile(number: 5, name: "Sam Bolander", role: "Captain", shoots: "Left", hometown: "Des Moines", note: "Primary half-wall creator."),
                    PlayerProfile(number: 10, name: "Tori Feldman", role: "Wing", shoots: "Right", hometown: "West Des Moines", note: "Leads the rush finishing group."),
                    PlayerProfile(number: 20, name: "Chris Leen", role: "Defense", shoots: "Left", hometown: "Johnston", note: "Top shot suppression defender."),
                    PlayerProfile(number: 29, name: "Alex Reed", role: "Goalie", shoots: "Right", hometown: "Ames", note: "Only two goals against in the visible slate.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "TBT United",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "2-1-2",
                ranking: 3,
                nationalRanking: 5,
                goalsFor: 4,
                goalsAgainst: 2,
                points: 6,
                manager: "Lagerquist",
                venue: "Brenton Skating Plaza",
                note: "Built its season on low-event games and has conceded just two goals.",
                styleColor: Color(hex: "#A26BFF"),
                secondaryColor: Color(hex: "#102A54"),
                logoText: "TU",
                established: "2019",
                roster: [
                    PlayerProfile(number: 3, name: "Peyton Gray", role: "Defense", shoots: "Left", hometown: "Waukee", note: "Keeps the neutral zone compact."),
                    PlayerProfile(number: 16, name: "Jordan Lagerquist", role: "Captain", shoots: "Right", hometown: "Des Moines", note: "Calm in late-game possessions."),
                    PlayerProfile(number: 22, name: "Mia Corbett", role: "Wing", shoots: "Left", hometown: "Ankeny", note: "Late-game counter threat."),
                    PlayerProfile(number: 32, name: "Cade Moran", role: "Goalie", shoots: "Right", hometown: "Des Moines", note: "Best rebound control among the chase pack.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "Ice Beavers",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "1-3-1",
                ranking: 4,
                nationalRanking: 6,
                goalsFor: 7,
                goalsAgainst: 8,
                points: 3,
                manager: "Johnson",
                venue: "Brenton Skating Plaza",
                note: "Owns the highest single-game output among the lower half after the 6-0 shutout of YPC.",
                styleColor: Color(hex: "#6F6292"),
                secondaryColor: Color(hex: "#15315F"),
                logoText: "IB",
                established: "2013",
                roster: [
                    PlayerProfile(number: 2, name: "Becca Lane", role: "Wing", shoots: "Right", hometown: "Clive", note: "High-motor forechecker."),
                    PlayerProfile(number: 11, name: "Tyler Johnson", role: "Captain", shoots: "Left", hometown: "Des Moines", note: "Drives shot volume from the middle lane."),
                    PlayerProfile(number: 25, name: "Owen Cruz", role: "Defense", shoots: "Right", hometown: "Urbandale", note: "Runs the weak-side switch."),
                    PlayerProfile(number: 41, name: "Nina Hart", role: "Goalie", shoots: "Left", hometown: "Ames", note: "Streaky but high-ceiling stop profile.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "YPC",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "1-4-0",
                ranking: 5,
                nationalRanking: 7,
                goalsFor: 1,
                goalsAgainst: 11,
                points: 2,
                manager: "Lagerquist",
                venue: "Brenton Skating Plaza",
                note: "Opened with a win before running into the league's stronger defensive clubs.",
                styleColor: Color(hex: "#D4A62A"),
                secondaryColor: Color(hex: "#0E2246"),
                logoText: "YP",
                established: "2021",
                roster: [
                    PlayerProfile(number: 7, name: "Eli Warren", role: "Captain", shoots: "Right", hometown: "Des Moines", note: "Main puck carrier."),
                    PlayerProfile(number: 12, name: "Maya Snow", role: "Wing", shoots: "Left", hometown: "Bondurant", note: "Looks to attack off broken play."),
                    PlayerProfile(number: 18, name: "Brent Kelly", role: "Defense", shoots: "Right", hometown: "Norwalk", note: "Penalty-kill specialist."),
                    PlayerProfile(number: 34, name: "Kyle Shea", role: "Goalie", shoots: "Left", hometown: "Johnston", note: "Faces some of the heaviest pressure in the table.")
                ]
            ),
            Team(
                competition: "Des Moines 2026 Co-Ed",
                name: "SSOI",
                city: "Des Moines, IA",
                division: "Co-Ed Broomball",
                record: "1-4-0",
                ranking: 6,
                nationalRanking: 9,
                goalsFor: 4,
                goalsAgainst: 11,
                points: 2,
                manager: "Anderson",
                venue: "Brenton Skating Plaza",
                note: "Displayed under the safe abbreviation SSOI in-app; the official listing uses a stronger nickname.",
                styleColor: Color(hex: "#8F6AD9"),
                secondaryColor: Color(hex: "#15315F"),
                logoText: "SS",
                established: "2022",
                roster: [
                    PlayerProfile(number: 4, name: "Taylor Voss", role: "Center", shoots: "Left", hometown: "Des Moines", note: "Connects the middle of the rink."),
                    PlayerProfile(number: 9, name: "Megan Frost", role: "Wing", shoots: "Right", hometown: "Pleasant Hill", note: "Fastest release on the roster."),
                    PlayerProfile(number: 23, name: "Grant Olson", role: "Defense", shoots: "Left", hometown: "Ankeny", note: "Most stable first pass option."),
                    PlayerProfile(number: 35, name: "Paige Anderson", role: "Goalie", shoots: "Right", hometown: "Des Moines", note: "Carried the lone win with 16 saves.")
                ]
            )
        ]

        matches = [
            Match(competition: "Woodbury 2026 CoRec", week: "Week 1", homeTeam: "Scorey Corey's", awayTeam: "Wild Bunch", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 4, 18, 15), status: .final, homeScore: 3, awayScore: 1, note: "Opening night result", attendance: 94, periodSummary: ["1st: 1-0", "2nd: 2-1", "3rd: 3-1"], headline: "Scorey Corey's controlled the middle frame and locked the game with structured defensive exits.", homeStats: MatchTeamStats(shots: 18, saves: 10, penalties: 2, faceoffWinRate: 56, powerPlay: "1/2"), awayStats: MatchTeamStats(shots: 11, saves: 15, penalties: 3, faceoffWinRate: 44, powerPlay: "0/3"), leaders: [MatchPlayerStat(playerName: "Corey Bell", teamName: "Scorey Corey's", goals: 2, assists: 1, saves: 0, plusMinus: 2), MatchPlayerStat(playerName: "Nate Hughes", teamName: "Scorey Corey's", goals: 0, assists: 0, saves: 10, plusMinus: 0), MatchPlayerStat(playerName: "Ian Blake", teamName: "Wild Bunch", goals: 1, assists: 0, saves: 0, plusMinus: -1)]),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 1", homeTeam: "Hurth Homes", awayTeam: "The Hustlers", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 4, 19, 15), status: .final, homeScore: 9, awayScore: 2, note: "Woodbury's widest opening margin", attendance: 118, periodSummary: ["1st: 3-1", "2nd: 6-2", "3rd: 9-2"], headline: "Hurth Homes broke the game early with heavy slot pressure and never let The Hustlers settle.", homeStats: MatchTeamStats(shots: 27, saves: 18, penalties: 1, faceoffWinRate: 61, powerPlay: "2/3"), awayStats: MatchTeamStats(shots: 20, saves: 18, penalties: 4, faceoffWinRate: 39, powerPlay: "1/2"), leaders: [MatchPlayerStat(playerName: "Mason Clark", teamName: "Hurth Homes", goals: 3, assists: 2, saves: 0, plusMinus: 4), MatchPlayerStat(playerName: "Evan Brooks", teamName: "Hurth Homes", goals: 0, assists: 0, saves: 18, plusMinus: 0), MatchPlayerStat(playerName: "Austin Reeve", teamName: "The Hustlers", goals: 1, assists: 1, saves: 0, plusMinus: -2)]),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 2", homeTeam: "Scorey Corey's", awayTeam: "The Hustlers", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 11, 18, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Official schedule listing", attendance: nil, periodSummary: [], headline: "A control-vs-recovery matchup where the Hustlers need cleaner exits.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 2", homeTeam: "Wild Bunch", awayTeam: "Hurth Homes", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 11, 19, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Official schedule listing", attendance: nil, periodSummary: [], headline: "Wild Bunch need to slow Hurth Homes through the neutral lane.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 3", homeTeam: "Hurth Homes", awayTeam: "Scorey Corey's", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 18, 18, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Potential first-place clash", attendance: nil, periodSummary: [], headline: "A possible early title-shaping clash in Woodbury.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 3", homeTeam: "The Hustlers", awayTeam: "Wild Bunch", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 18, 19, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Bottom-half recovery spot", attendance: nil, periodSummary: [], headline: "Whoever steadies the breakout shape first takes a major recovery step.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 4", homeTeam: "The Hustlers", awayTeam: "Hurth Homes", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 25, 18, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Reverse of Week 1", attendance: nil, periodSummary: [], headline: "The Hustlers get a clean revenge spot.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 4", homeTeam: "Wild Bunch", awayTeam: "Scorey Corey's", venue: "MHFV Ice Rink", start: Self.date(2026, 1, 25, 19, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Official schedule listing", attendance: nil, periodSummary: [], headline: "Wild Bunch need a tighter weak-side seal against Corey's puck movement.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 5", homeTeam: "Hurth Homes", awayTeam: "Wild Bunch", venue: "MHFV Ice Rink", start: Self.date(2026, 2, 1, 18, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Official schedule listing", attendance: nil, periodSummary: [], headline: "Hurth Homes revisit the matchup with likely more tape on Wild Bunch counters.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 5", homeTeam: "The Hustlers", awayTeam: "Scorey Corey's", venue: "MHFV Ice Rink", start: Self.date(2026, 2, 1, 19, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Official schedule listing", attendance: nil, periodSummary: [], headline: "A speed check for The Hustlers against Woodbury's cleanest defensive team.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 6", homeTeam: "Wild Bunch", awayTeam: "The Hustlers", venue: "MHFV Ice Rink", start: Self.date(2026, 2, 8, 18, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Final regular-season Sunday", attendance: nil, periodSummary: [], headline: "Final regular-season positioning game.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Woodbury 2026 CoRec", week: "Week 6", homeTeam: "Scorey Corey's", awayTeam: "Hurth Homes", venue: "MHFV Ice Rink", start: Self.date(2026, 2, 8, 19, 15), status: .scheduled, homeScore: nil, awayScore: nil, note: "Final regular-season Sunday", attendance: nil, periodSummary: [], headline: "Potential league-deciding regular-season finale.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 2", homeTeam: "SSOI", awayTeam: "YPC", venue: "Brenton Skating Plaza", start: Self.date(2025, 12, 21, 18, 0), status: .final, homeScore: 0, awayScore: 1, note: "Official listing uses the full SSOI team name", attendance: 121, periodSummary: ["1st: 0-0", "2nd: 0-1", "3rd: 0-1"], headline: "YPC rode patient transitions and a single clean finish to edge SSOI.", homeStats: MatchTeamStats(shots: 9, saves: 8, penalties: 1, faceoffWinRate: 47, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 10, saves: 9, penalties: 2, faceoffWinRate: 53, powerPlay: "0/2"), leaders: [MatchPlayerStat(playerName: "Maya Snow", teamName: "YPC", goals: 1, assists: 0, saves: 0, plusMinus: 1), MatchPlayerStat(playerName: "Paige Anderson", teamName: "SSOI", goals: 0, assists: 0, saves: 8, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 2", homeTeam: "Ice Beavers", awayTeam: "TBT United", venue: "Brenton Skating Plaza", start: Self.date(2025, 12, 21, 19, 0), status: .final, homeScore: 0, awayScore: 0, note: "Scoreless draw", attendance: 108, periodSummary: ["1st: 0-0", "2nd: 0-0", "3rd: 0-0"], headline: "A disciplined low-event game finished scoreless.", homeStats: MatchTeamStats(shots: 8, saves: 7, penalties: 1, faceoffWinRate: 50, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 7, saves: 8, penalties: 1, faceoffWinRate: 50, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Nina Hart", teamName: "Ice Beavers", goals: 0, assists: 0, saves: 7, plusMinus: 0), MatchPlayerStat(playerName: "Cade Moran", teamName: "TBT United", goals: 0, assists: 0, saves: 8, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 2", homeTeam: "Ballhawgs", awayTeam: "Ice Monkeys", venue: "Brenton Skating Plaza", start: Self.date(2025, 12, 21, 20, 0), status: .final, homeScore: 0, awayScore: 1, note: "Early statement from Ice Monkeys", attendance: 147, periodSummary: ["1st: 0-0", "2nd: 0-1", "3rd: 0-1"], headline: "Ice Monkeys showed the league's cleanest defensive shape in a statement win.", homeStats: MatchTeamStats(shots: 12, saves: 10, penalties: 2, faceoffWinRate: 48, powerPlay: "0/2"), awayStats: MatchTeamStats(shots: 11, saves: 12, penalties: 2, faceoffWinRate: 52, powerPlay: "1/2"), leaders: [MatchPlayerStat(playerName: "Haley Erickson", teamName: "Ice Monkeys", goals: 1, assists: 0, saves: 0, plusMinus: 1), MatchPlayerStat(playerName: "Alex Reed", teamName: "Ballhawgs", goals: 0, assists: 0, saves: 10, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 4", homeTeam: "Ice Monkeys", awayTeam: "SSOI", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 4, 18, 0), status: .final, homeScore: 4, awayScore: 2, note: "Highest Ice Monkeys output in the archive", attendance: 156, periodSummary: ["1st: 2-1", "2nd: 3-2", "3rd: 4-2"], headline: "Ice Monkeys stretched SSOI with pace through the middle and cleaner late possession.", homeStats: MatchTeamStats(shots: 16, saves: 9, penalties: 1, faceoffWinRate: 58, powerPlay: "1/2"), awayStats: MatchTeamStats(shots: 11, saves: 12, penalties: 2, faceoffWinRate: 42, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Haley Erickson", teamName: "Ice Monkeys", goals: 2, assists: 1, saves: 0, plusMinus: 3), MatchPlayerStat(playerName: "Paige Anderson", teamName: "SSOI", goals: 0, assists: 0, saves: 12, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 4", homeTeam: "TBT United", awayTeam: "Ballhawgs", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 4, 19, 0), status: .final, homeScore: 0, awayScore: 1, note: "Ballhawgs stole a one-goal grinder", attendance: 112, periodSummary: ["1st: 0-0", "2nd: 0-1", "3rd: 0-1"], headline: "Ballhawgs found one special-teams finish and defended the lead.", homeStats: MatchTeamStats(shots: 8, saves: 9, penalties: 3, faceoffWinRate: 49, powerPlay: "0/3"), awayStats: MatchTeamStats(shots: 10, saves: 8, penalties: 2, faceoffWinRate: 51, powerPlay: "1/2"), leaders: [MatchPlayerStat(playerName: "Sam Bolander", teamName: "Ballhawgs", goals: 1, assists: 0, saves: 0, plusMinus: 1), MatchPlayerStat(playerName: "Cade Moran", teamName: "TBT United", goals: 0, assists: 0, saves: 9, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 4", homeTeam: "Ice Beavers", awayTeam: "YPC", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 4, 20, 0), status: .final, homeScore: 6, awayScore: 0, note: "Largest Des Moines result in the source set", attendance: 134, periodSummary: ["1st: 2-0", "2nd: 4-0", "3rd: 6-0"], headline: "Ice Beavers piled up controlled entries and buried their best finishing night.", homeStats: MatchTeamStats(shots: 19, saves: 6, penalties: 0, faceoffWinRate: 60, powerPlay: "2/2"), awayStats: MatchTeamStats(shots: 6, saves: 13, penalties: 2, faceoffWinRate: 40, powerPlay: "0/0"), leaders: [MatchPlayerStat(playerName: "Tyler Johnson", teamName: "Ice Beavers", goals: 3, assists: 1, saves: 0, plusMinus: 4), MatchPlayerStat(playerName: "Nina Hart", teamName: "Ice Beavers", goals: 0, assists: 0, saves: 6, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 5", homeTeam: "YPC", awayTeam: "TBT United", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 11, 18, 0), status: .final, homeScore: 0, awayScore: 1, note: "TBT keeps climbing", attendance: 96, periodSummary: ["1st: 0-0", "2nd: 0-1", "3rd: 0-1"], headline: "TBT kept the game narrow and waited for one decisive middle-lane chance.", homeStats: MatchTeamStats(shots: 7, saves: 8, penalties: 1, faceoffWinRate: 45, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 9, saves: 7, penalties: 1, faceoffWinRate: 55, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Jordan Lagerquist", teamName: "TBT United", goals: 1, assists: 0, saves: 0, plusMinus: 1)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 5", homeTeam: "Ballhawgs", awayTeam: "SSOI", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 11, 19, 0), status: .final, homeScore: 4, awayScore: 0, note: "Ballhawgs offense expands the gap", attendance: 123, periodSummary: ["1st: 1-0", "2nd: 3-0", "3rd: 4-0"], headline: "Ballhawgs attacked wide and collapsed the slot for a clean shutout.", homeStats: MatchTeamStats(shots: 17, saves: 8, penalties: 1, faceoffWinRate: 57, powerPlay: "1/2"), awayStats: MatchTeamStats(shots: 8, saves: 13, penalties: 2, faceoffWinRate: 43, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Sam Bolander", teamName: "Ballhawgs", goals: 2, assists: 1, saves: 0, plusMinus: 3)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 5", homeTeam: "Ice Monkeys", awayTeam: "Ice Beavers", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 11, 20, 0), status: .final, homeScore: 2, awayScore: 0, note: "Second straight clean sheet for the Monkeys", attendance: 142, periodSummary: ["1st: 1-0", "2nd: 1-0", "3rd: 2-0"], headline: "Ice Monkeys again suffocated the middle lane and won through patient control.", homeStats: MatchTeamStats(shots: 13, saves: 11, penalties: 1, faceoffWinRate: 54, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 11, saves: 11, penalties: 1, faceoffWinRate: 46, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Riley Cook", teamName: "Ice Monkeys", goals: 1, assists: 1, saves: 0, plusMinus: 2), MatchPlayerStat(playerName: "Jess Nolan", teamName: "Ice Monkeys", goals: 0, assists: 0, saves: 11, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 6", homeTeam: "TBT United", awayTeam: "Ice Monkeys", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 18, 18, 0), status: .final, homeScore: 1, awayScore: 1, note: "Top-three draw", attendance: 151, periodSummary: ["1st: 0-0", "2nd: 1-1", "3rd: 1-1"], headline: "TBT slowed the best team in the table by forcing outside possessions.", homeStats: MatchTeamStats(shots: 10, saves: 10, penalties: 2, faceoffWinRate: 51, powerPlay: "0/2"), awayStats: MatchTeamStats(shots: 11, saves: 9, penalties: 2, faceoffWinRate: 49, powerPlay: "0/2"), leaders: [MatchPlayerStat(playerName: "Jordan Lagerquist", teamName: "TBT United", goals: 1, assists: 0, saves: 0, plusMinus: 1), MatchPlayerStat(playerName: "Haley Erickson", teamName: "Ice Monkeys", goals: 1, assists: 0, saves: 0, plusMinus: 1)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 6", homeTeam: "SSOI", awayTeam: "Ice Beavers", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 18, 19, 0), status: .final, homeScore: 2, awayScore: 0, note: "SSOI's lone win in the visible slate", attendance: 93, periodSummary: ["1st: 1-0", "2nd: 1-0", "3rd: 2-0"], headline: "SSOI finally got rewarded for tighter transition spacing and better goaltending support.", homeStats: MatchTeamStats(shots: 10, saves: 12, penalties: 1, faceoffWinRate: 52, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 12, saves: 8, penalties: 1, faceoffWinRate: 48, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Taylor Voss", teamName: "SSOI", goals: 1, assists: 1, saves: 0, plusMinus: 2), MatchPlayerStat(playerName: "Paige Anderson", teamName: "SSOI", goals: 0, assists: 0, saves: 12, plusMinus: 0)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 6", homeTeam: "YPC", awayTeam: "Ballhawgs", venue: "Brenton Skating Plaza", start: Self.date(2026, 1, 18, 20, 0), status: .final, homeScore: 0, awayScore: 3, note: "Ballhawgs continue their surge", attendance: 106, periodSummary: ["1st: 0-1", "2nd: 0-2", "3rd: 0-3"], headline: "Ballhawgs stretched the game and found layered support around the net.", homeStats: MatchTeamStats(shots: 6, saves: 12, penalties: 2, faceoffWinRate: 41, powerPlay: "0/2"), awayStats: MatchTeamStats(shots: 15, saves: 6, penalties: 1, faceoffWinRate: 59, powerPlay: "1/1"), leaders: [MatchPlayerStat(playerName: "Tori Feldman", teamName: "Ballhawgs", goals: 2, assists: 0, saves: 0, plusMinus: 2)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 8", homeTeam: "Ice Beavers", awayTeam: "Ballhawgs", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 1, 18, 0), status: .final, homeScore: 1, awayScore: 4, note: "Ballhawgs complete the season-series edge", attendance: 115, periodSummary: ["1st: 1-1", "2nd: 1-3", "3rd: 1-4"], headline: "Ballhawgs separated late with the cleanest depth finishing sequence on the slate.", homeStats: MatchTeamStats(shots: 9, saves: 11, penalties: 2, faceoffWinRate: 46, powerPlay: "0/2"), awayStats: MatchTeamStats(shots: 15, saves: 8, penalties: 2, faceoffWinRate: 54, powerPlay: "1/2"), leaders: [MatchPlayerStat(playerName: "Sam Bolander", teamName: "Ballhawgs", goals: 1, assists: 2, saves: 0, plusMinus: 3)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 8", homeTeam: "Ice Monkeys", awayTeam: "YPC", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 1, 19, 0), status: .final, homeScore: 1, awayScore: 0, note: "Narrow lead preserved", attendance: 128, periodSummary: ["1st: 1-0", "2nd: 1-0", "3rd: 1-0"], headline: "Ice Monkeys again won the tiny margins and protected a one-goal edge.", homeStats: MatchTeamStats(shots: 10, saves: 7, penalties: 1, faceoffWinRate: 55, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 7, saves: 9, penalties: 1, faceoffWinRate: 45, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Riley Cook", teamName: "Ice Monkeys", goals: 1, assists: 0, saves: 0, plusMinus: 1)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 8", homeTeam: "TBT United", awayTeam: "SSOI", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 1, 20, 0), status: .final, homeScore: 2, awayScore: 0, note: "TBT ends the visible run on a win", attendance: 101, periodSummary: ["1st: 1-0", "2nd: 1-0", "3rd: 2-0"], headline: "TBT finished the visible slate by controlling pace and limiting slot chaos.", homeStats: MatchTeamStats(shots: 12, saves: 8, penalties: 1, faceoffWinRate: 53, powerPlay: "0/1"), awayStats: MatchTeamStats(shots: 8, saves: 10, penalties: 1, faceoffWinRate: 47, powerPlay: "0/1"), leaders: [MatchPlayerStat(playerName: "Jordan Lagerquist", teamName: "TBT United", goals: 1, assists: 1, saves: 0, plusMinus: 2)]),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 10", homeTeam: "Ballhawgs", awayTeam: "Ice Beavers", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 15, 18, 0), status: .scheduled, homeScore: nil, awayScore: nil, note: "Week 10 official schedule", attendance: nil, periodSummary: [], headline: "Ballhawgs can lock in their chase position with another fast-start performance.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 10", homeTeam: "YPC", awayTeam: "Ice Monkeys", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 15, 19, 0), status: .scheduled, homeScore: nil, awayScore: nil, note: "Week 10 official schedule", attendance: nil, periodSummary: [], headline: "YPC need to slow the best defensive team in the league.", homeStats: nil, awayStats: nil, leaders: []),
            Match(competition: "Des Moines 2026 Co-Ed", week: "Week 10", homeTeam: "SSOI", awayTeam: "TBT United", venue: "Brenton Skating Plaza", start: Self.date(2026, 2, 15, 20, 0), status: .scheduled, homeScore: nil, awayScore: nil, note: "Week 10 official schedule", attendance: nil, periodSummary: [], headline: "A late-season control matchup with direct seeding implications.", homeStats: nil, awayStats: nil, leaders: [])
        ]

        events = [
            CalendarEvent(title: "Minneapolis Spring League opens", date: Self.date(2026, 4, 12, 12, 0), location: "Parade South Rink, Minneapolis", category: "League", detail: "MPRB listed the indoor spring season from April 12 to June 14."),
            CalendarEvent(title: "ABA Nationals", date: Self.date(2026, 4, 16, 9, 0), location: "Minneapolis, MN", category: "Tournament", detail: "Minnesota Broomball Program listed ABA Nationals for April 16-19, 2026."),
            CalendarEvent(title: "AEB Minnesota State", date: Self.date(2026, 3, 12, 9, 0), location: "Augsburg Ice Arena, Minneapolis", category: "Tournament", detail: "AEB Minnesota State was listed for March 12-15, 2026."),
            CalendarEvent(title: "Saint Paul playoff weekend", date: Self.date(2026, 2, 7, 10, 0), location: "McMurray Fields, Saint Paul", category: "Playoffs", detail: "The city page listed optional postseason play for February 7-8, 2026."),
            CalendarEvent(title: "Minnetonka Thursday opener", date: Self.date(2026, 1, 8, 18, 0), location: "Valley Park / Harley-Hopkins Park", category: "League", detail: "Minnetonka published January 8 as the start date for Winter 2026.")
        ]

        venues = [
            VenueProfile(name: "M Health Fairview Sports Center", city: "Woodbury, MN", detail: "Woodbury says the sports center houses two indoor sheets measuring 200 by 85 feet and serves as the city's core ice hub.", venueNote: "Featured broomball schedule venue: MHFV Ice Rink", sourceLine: "City of Woodbury ice arenas page"),
            VenueProfile(name: "Brenton Skating Plaza", city: "Des Moines, IA", detail: "Des Moines uses Brenton as the city-center sheet for co-ed league play and postseason bracket games.", venueNote: "Featured venue for Des Moines Co-Ed Broomball", sourceLine: "Des Moines TeamSideline / city records"),
            VenueProfile(name: "Parade South Rink", city: "Minneapolis, MN", detail: "MPRB's spring 2026 indoor league is anchored here on Sundays in Competitive, Blue Rec, and Green Rec tiers.", venueNote: "Current-season spring venue", sourceLine: "MPRB spring league page"),
            VenueProfile(name: "McMurray Fields", city: "Saint Paul, MN", detail: "Saint Paul's entire adult season and playoffs are centralized at McMurray Fields.", venueNote: "Municipal winter league base", sourceLine: "City of Saint Paul"),
            VenueProfile(name: "Valley Park / Harley-Hopkins Park", city: "Hopkins, MN", detail: "Minnetonka lists both sites as the winter homes of its men's Thursday league.", venueNote: "Outdoor Thursday league rinks", sourceLine: "City of Minnetonka"),
            VenueProfile(name: "Augsburg Ice Arena", city: "Minneapolis, MN", detail: "The Minnesota Broomball Program calendar places multiple 2026 tournaments here, including the International and AEB Minnesota State.", venueNote: "Major tournament anchor", sourceLine: "Minnesota Broomball Program")
        ]

        momentum = [
            TrendPoint(series: "Ice Monkeys", label: "W2", step: 2, value: 2),
            TrendPoint(series: "Ice Monkeys", label: "W4", step: 4, value: 4),
            TrendPoint(series: "Ice Monkeys", label: "W5", step: 5, value: 6),
            TrendPoint(series: "Ice Monkeys", label: "W6", step: 6, value: 7),
            TrendPoint(series: "Ice Monkeys", label: "W8", step: 8, value: 9),
            TrendPoint(series: "Ballhawgs", label: "W2", step: 2, value: 0),
            TrendPoint(series: "Ballhawgs", label: "W4", step: 4, value: 2),
            TrendPoint(series: "Ballhawgs", label: "W5", step: 5, value: 4),
            TrendPoint(series: "Ballhawgs", label: "W6", step: 6, value: 6),
            TrendPoint(series: "Ballhawgs", label: "W8", step: 8, value: 8),
            TrendPoint(series: "TBT United", label: "W2", step: 2, value: 1),
            TrendPoint(series: "TBT United", label: "W4", step: 4, value: 1),
            TrendPoint(series: "TBT United", label: "W5", step: 5, value: 3),
            TrendPoint(series: "TBT United", label: "W6", step: 6, value: 4),
            TrendPoint(series: "TBT United", label: "W8", step: 8, value: 6),
            TrendPoint(series: "Ice Beavers", label: "W2", step: 2, value: 1),
            TrendPoint(series: "Ice Beavers", label: "W4", step: 4, value: 3),
            TrendPoint(series: "Ice Beavers", label: "W5", step: 5, value: 3),
            TrendPoint(series: "Ice Beavers", label: "W6", step: 6, value: 3),
            TrendPoint(series: "Ice Beavers", label: "W8", step: 8, value: 3)
        ]

        goalMetrics = teams.flatMap { team in
            [
                MetricBar(team: team.name, category: "GF", value: Double(team.goalsFor), color: team.styleColor),
                MetricBar(team: team.name, category: "GA", value: Double(team.goalsAgainst), color: team.secondaryColor.opacity(0.9))
            ]
        }

        strategyPresets = [
            StrategyPreset(
                title: "High Press 2-1-2",
                emphasis: "Aggressive puck pressure with quick inside support once possession flips.",
                zoneNotes: [
                    RinkZoneNote(zone: "Forecheck", title: "First touch pressure", detail: "F1 drives the strong-side corner while F2 seals the reverse lane."),
                    RinkZoneNote(zone: "Neutral", title: "Middle lane trap", detail: "Center stays high enough to block the first outlet and force chips."),
                    RinkZoneNote(zone: "Defensive", title: "Fast bump support", detail: "Weak-side defender rotates under the goal line to shorten the first pass.")
                ]
            ),
            StrategyPreset(
                title: "Controlled 1-2-2",
                emphasis: "Compact neutral shape designed for lower-event matches and late-game protection.",
                zoneNotes: [
                    RinkZoneNote(zone: "Forecheck", title: "Delayed pressure", detail: "F1 angles the puck carrier wide while the second line protects center ice."),
                    RinkZoneNote(zone: "Neutral", title: "Stacked middle", detail: "Two skaters sit inside the dots to kill direct entries."),
                    RinkZoneNote(zone: "Defensive", title: "Low support exit", detail: "Wings collapse lower before stretching wide for the first clean pass.")
                ]
            ),
            StrategyPreset(
                title: "Quick Strike Transition",
                emphasis: "Designed for training days focused on turning stops into immediate attacks.",
                zoneNotes: [
                    RinkZoneNote(zone: "Forecheck", title: "Second wave join", detail: "Weak-side wing arrives late for a soft-area finish."),
                    RinkZoneNote(zone: "Neutral", title: "Stretch timing", detail: "Center must delay until the puck is fully won to avoid offside pressure."),
                    RinkZoneNote(zone: "Defensive", title: "Goalie outlet cue", detail: "Goalie looks middle first only when the center lane is open.")
                ]
            )
        ]

        trainingBlocks = [
            TrainingBlock(title: "Low-slot protection", duration: "18 min", intensity: "Medium", objective: "Shrink the scoring area and improve inside sticks."),
            TrainingBlock(title: "3-pass breakout ladder", duration: "14 min", intensity: "High", objective: "Build cleaner exits under mild pressure."),
            TrainingBlock(title: "Half-rink free play", duration: "20 min", intensity: "Light", objective: "Keep the session fun while rehearsing spacing cues.")
        ]

        insightReports = [
            InsightReport(kind: .momentum, title: "Momentum Tracker", summary: "See who is carrying form week over week across the Des Moines slate.", metric: "Ice Monkeys +9 form points", bullets: ["Ice Monkeys remain the cleanest late-game team.", "Ballhawgs produce the strongest attacking chase line.", "TBT United own the steadiest climb among the middle clubs."]),
            InsightReport(kind: .scoring, title: "Scoring Profile", summary: "Breaks down goals for, goals against, and whether wins come from volume or suppression.", metric: "Ballhawgs +10 goal differential", bullets: ["Ballhawgs drive the sharpest offense.", "Ice Monkeys pair quality scoring with elite shot suppression.", "Woodbury leaders show the highest single-game ceiling."]),
            InsightReport(kind: .venue, title: "Venue Edge", summary: "Highlights where teams are most stable and how venue context shifts match rhythm.", metric: "Brenton hosts 18 tracked fixtures", bullets: ["Brenton supports the deepest completed sample.", "MHFV games trend higher in shot count.", "Parade South is the spring anchor for future scheduling."]),
            InsightReport(kind: .availability, title: "Availability Pulse", summary: "Tracks your own schedule load against league, tournament, and training pressure.", metric: "3 personal sessions this week", bullets: ["Training and league play can be balanced inside one view.", "Own-match notes keep private prep separate from public schedules.", "Strategy sessions can be staged before every major fixture."])
        ]

        personalPlans = [
            PersonalPlan(title: "Thursday skills training", date: Self.date(2026, 1, 15, 20, 0), location: "Pleasant Hill Outdoor Pad", type: "Training", note: "Edgework, passing ladders, and six quick-strike reps."),
            PersonalPlan(title: "Captain chalk talk", date: Self.date(2026, 1, 17, 18, 30), location: "Brenton lounge", type: "Strategy", note: "Review 1-2-2 and late-game line management."),
            PersonalPlan(title: "Pickup game", date: Self.date(2026, 1, 20, 19, 0), location: "Augsburg Ice Arena", type: "Free Play", note: "Lighter session with mixed rosters.")
        ]

        selectedStrategyID = strategyPresets.first?.id
    }

    var featuredWoodburyTeams: [Team] {
        teams.filter { $0.competition == "Woodbury 2026 CoRec" }
            .sorted { $0.ranking < $1.ranking }
    }

    var groupedTeams: [(String, [Team])] {
        [
            ("Woodbury 2026 CoRec", teams.filter { $0.competition == "Woodbury 2026 CoRec" }.sorted { $0.ranking < $1.ranking }),
            ("Des Moines 2026 Co-Ed", teams.filter { $0.competition == "Des Moines 2026 Co-Ed" }.sorted { $0.ranking < $1.ranking })
        ]
    }

    var powerRankedTeams: [Team] {
        teams.sorted { lhs, rhs in
            if lhs.nationalRanking == rhs.nationalRanking {
                return lhs.points > rhs.points
            }
            return lhs.nationalRanking < rhs.nationalRanking
        }
    }

    var completedMatches: [Match] {
        matches.filter(\.isCompleted).sorted { $0.start > $1.start }
    }

    var upcomingMatches: [Match] {
        matches.filter { !$0.isCompleted }.sorted { $0.start < $1.start }
    }

    var groupedMatches: [(String, [Match])] {
        Dictionary(grouping: matches, by: \.competition)
            .map { ($0.key, $0.value.sorted { $0.start < $1.start }) }
            .sorted { $0.0 < $1.0 }
    }

    var selectedStrategy: StrategyPreset? {
        strategyPresets.first { $0.id == selectedStrategyID }
    }

    func team(named name: String) -> Team? {
        teams.first { $0.name == name }
    }

    func matches(for team: Team) -> [Match] {
        matches.filter { $0.homeTeam == team.name || $0.awayTeam == team.name }
            .sorted { $0.start > $1.start }
    }

    func addPersonalPlan(title: String, date: Date, location: String, type: String, note: String) {
        personalPlans.insert(
            PersonalPlan(title: title, date: date, location: location, type: type, note: note),
            at: 0
        )
    }

    private static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "America/Chicago")
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return components.date ?? .now
    }
}
