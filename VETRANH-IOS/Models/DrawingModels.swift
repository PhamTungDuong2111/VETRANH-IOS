//
//  DrawingModels.swift
//  VETRANH-IOS
//

import UIKit
import SwiftUI

public enum BrushType: String, CaseIterable, Identifiable {
    case neon = "neon"
    case rainbow = "rainbow"
    case stars = "stars"
    case beads = "beads"
    case ribbon = "ribbon"
    case fireworks = "fireworks"

    public var id: String { rawValue }

    public func title(isVietnamese: Bool) -> String {
        switch self {
        case .neon: return isVietnamese ? "Neon" : "Neon"
        case .rainbow: return isVietnamese ? "Cầu vồng" : "Rainbow"
        case .stars: return isVietnamese ? "Ngôi sao" : "Stars"
        case .beads: return isVietnamese ? "Chuỗi hạt" : "Beads"
        case .ribbon: return isVietnamese ? "Ruy băng" : "Ribbon"
        case .fireworks: return isVietnamese ? "Pháo hoa" : "Fireworks"
        }
    }
}

public enum SymmetryMode: Int, CaseIterable, Identifiable {
    case none = 1
    case mirror2 = 2
    case mirror4 = 4
    case kaleidoscope8 = 8

    public var id: Int { rawValue }

    public var count: Int { rawValue }

    public var label: String {
        switch self {
        case .none: return "1x"
        case .mirror2: return "2x"
        case .mirror4: return "4x"
        case .kaleidoscope8: return "8x"
        }
    }

    public var next: SymmetryMode {
        switch self {
        case .none: return .mirror2
        case .mirror2: return .mirror4
        case .mirror4: return .kaleidoscope8
        case .kaleidoscope8: return .none
        }
    }
}

public struct Stroke {
    public var points: [CGPoint]
    public var color: UIColor
    public var strokeWidth: CGFloat
    public var brushType: BrushType
    public var symmetryMode: SymmetryMode
    public var isRainbow: Bool

    public init(
        points: [CGPoint],
        color: UIColor,
        strokeWidth: CGFloat,
        brushType: BrushType,
        symmetryMode: SymmetryMode,
        isRainbow: Bool = false
    ) {
        self.points = points
        self.color = color
        self.strokeWidth = strokeWidth
        self.brushType = brushType
        self.symmetryMode = symmetryMode
        self.isRainbow = isRainbow
    }
}
