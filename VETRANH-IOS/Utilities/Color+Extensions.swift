//
//  Color+Extensions.swift
//  VETRANH-IOS
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // Neon Palette Colors
    public static let neonCyan = Color(hex: "#00FFFF")
    public static let neonPink = Color(hex: "#FF007F")
    public static let limeGreen = Color(hex: "#39FF14")
    public static let electricYellow = Color(hex: "#FFE600")
    public static let neonOrange = Color(hex: "#FF5F1F")
    public static let electricPurple = Color(hex: "#BC13FE")
    public static let skyAzure = Color(hex: "#007FFF")
    public static let deepRose = Color(hex: "#FF1493")
    public static let mintGlow = Color(hex: "#00FF80")
    public static let neonRed = Color(hex: "#FF3131")
    public static let neonViolet = Color(hex: "#9D00FF")
    public static let glowingWhite = Color(hex: "#FFFFFF")

    public static let neonPalette: [Color] = [
        .neonCyan,
        .neonPink,
        .limeGreen,
        .electricYellow,
        .neonOrange,
        .electricPurple,
        .skyAzure,
        .deepRose,
        .mintGlow,
        .neonRed,
        .neonViolet,
        .glowingWhite
    ]
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    public static let neonCyan = UIColor(hex: "#00FFFF")
    public static let neonPink = UIColor(hex: "#FF007F")
    public static let limeGreen = UIColor(hex: "#39FF14")
    public static let electricYellow = UIColor(hex: "#FFE600")
    public static let neonOrange = UIColor(hex: "#FF5F1F")
    public static let electricPurple = UIColor(hex: "#BC13FE")
    public static let skyAzure = UIColor(hex: "#007FFF")
    public static let deepRose = UIColor(hex: "#FF1493")
    public static let mintGlow = UIColor(hex: "#00FF80")
    public static let neonRed = UIColor(hex: "#FF3131")
    public static let neonViolet = UIColor(hex: "#9D00FF")
    public static let glowingWhite = UIColor(hex: "#FFFFFF")

    public static let neonPaletteUI: [UIColor] = [
        .neonCyan,
        .neonPink,
        .limeGreen,
        .electricYellow,
        .neonOrange,
        .electricPurple,
        .skyAzure,
        .deepRose,
        .mintGlow,
        .neonRed,
        .neonViolet,
        .glowingWhite
    ]
}
