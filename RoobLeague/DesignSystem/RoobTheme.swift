import SwiftUI

enum RoobTheme {
    static let ink = Color(hex: "#170528")
    static let royal = Color(hex: "#2A0D55")
    static let plum = Color(hex: "#4A1788")
    static let navy = Color(hex: "#12051F")
    static let cream = Color(hex: "#FFF7E8")
    static let gold = Color(hex: "#F0B61B")
    static let goldDeep = Color(hex: "#C98900")
    static let mist = Color(hex: "#5B3B8B")
    static let slate = Color(hex: "#CABDE3")
    static let surface = Color(hex: "#241046")
    static let surfaceRaised = Color(hex: "#331762")

    static let pageGradient = LinearGradient(
        colors: [Color(hex: "#12041D"), Color(hex: "#241046"), Color(hex: "#1A0830")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        var int: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xff) / 255
        let green = Double((int >> 8) & 0xff) / 255
        let blue = Double(int & 0xff) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
