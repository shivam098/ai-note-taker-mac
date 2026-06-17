import SwiftUI

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }

    static let appBg = Color(hex: "#0E0F1A")
    static let appSurface = Color(hex: "#1A1B29")
    static let appSurfaceElevated = Color(hex: "#23253A")
    static let appPrimary = Color(hex: "#7C6FF0")
    static let appText = Color(hex: "#F4F5FB")
    static let appTextSecondary = Color(hex: "#9A9DB5")
    static let appTextMuted = Color(hex: "#6C6F88")
}
