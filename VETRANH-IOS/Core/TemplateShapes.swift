//
//  TemplateShapes.swift
//  VETRANH-IOS
//

import UIKit

fileprivate func *(lhs: CGFloat, rhs: Int) -> CGFloat { lhs * CGFloat(rhs) }
fileprivate func *(lhs: Int, rhs: CGFloat) -> CGFloat { CGFloat(lhs) * rhs }
fileprivate func /(lhs: CGFloat, rhs: Int) -> CGFloat { lhs / CGFloat(rhs) }
fileprivate func +(lhs: CGFloat, rhs: Int) -> CGFloat { lhs + CGFloat(rhs) }
fileprivate func -(lhs: CGFloat, rhs: Int) -> CGFloat { lhs - CGFloat(rhs) }
fileprivate func cos(_ x: CGFloat) -> CGFloat { Darwin.cos(x) }
fileprivate func sin(_ x: CGFloat) -> CGFloat { Darwin.sin(x) }

public struct TemplateShapes {

    public static func createPath(type: StencilType, bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        if type == .none { return path }

        let cx = bounds.midX
        let cy = bounds.midY
        let w = bounds.width
        let h = bounds.height
        let s = min(w, h) * 0.46

        switch type {
        case .none:
            break

            // ==========================================
            // --- DỄ THƯƠNG (25 MẪU) ---
            // ==========================================

        case .heart:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.45), controlPoint1: CGPoint(x: cx - r * 1.35, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.8, y: cy - r * 1.25))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.85), controlPoint1: CGPoint(x: cx + r * 0.8, y: cy - r * 1.25), controlPoint2: CGPoint(x: cx + r * 1.35, y: cy - r * 0.2))

                let inR = r * 0.5
                path.move(to: CGPoint(x: cx, y: cy + inR * 0.8))
                path.addCurve(to: CGPoint(x: cx, y: cy - inR * 0.45), controlPoint1: CGPoint(x: cx - inR * 1.35, y: cy - inR * 0.2), controlPoint2: CGPoint(x: cx - inR * 0.8, y: cy - inR * 1.25))
                path.addCurve(to: CGPoint(x: cx, y: cy + inR * 0.8), controlPoint1: CGPoint(x: cx + inR * 0.8, y: cy - inR * 1.25), controlPoint2: CGPoint(x: cx + inR * 1.35, y: cy - inR * 0.2))

                addStar(path, cx + r * 0.85, cy - r * 0.65, r * 0.2)
                addStar(path, cx - r * 0.9, cy + r * 0.2, r * 0.14)
            }

        case .star:
            do {
                addStar(path, cx, cy, s * 0.95)
                addStar(path, cx, cy, s * 0.52)
                addCircle(path, cx - s * 0.16, cy - s * 0.05, s * 0.05)
                addCircle(path, cx + s * 0.16, cy - s * 0.05, s * 0.05)
                addArc(path, cx - s * 0.14, cy - s * 0.02, cx + s * 0.14, cy + s * 0.16, 0.0, 180.0)
            }

        case .rainbowCloud:
            do {
                let r = s * 0.85
                let arcs = 4
                for _i in 0..<arcs {
                    let i = CGFloat(_i)
                    let stepR = r * (1.0 - i * 0.16)
                    addArc(path, cx - stepR, cy - stepR * 0.8, cx + stepR, cy + stepR * 0.8, 180.0, 180.0)
                }
                addCloud(path, cx - r * 0.65, cy + r * 0.25, r * 0.38)
                addCloud(path, cx + r * 0.65, cy + r * 0.25, r * 0.38)
            }

        case .cupcake:
            do {
                let r = s * 0.8
                path.move(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy + r * 0.05))
                path.close()
                path.move(to: CGPoint(x: cx - r * 0.25, y: cy + r * 0.08))
                path.addLine(to: CGPoint(x: cx - r * 0.18, y: cy + r * 0.92))
                path.move(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.08))
                path.addLine(to: CGPoint(x: cx + r * 0.18, y: cy + r * 0.92))
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.05))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.9, y: cy - r * 0.35), controlPoint2: CGPoint(x: cx - r * 0.3, y: cy - r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.75, y: cy + r * 0.05), controlPoint1: CGPoint(x: cx + r * 0.3, y: cy - r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.9, y: cy - r * 0.35))
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.4))
                path.addCurve(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.4), controlPoint1: CGPoint(x: cx - r * 0.4, y: cy - r * 0.8), controlPoint2: CGPoint(x: cx + r * 0.4, y: cy - r * 0.8))
                addCircle(path, cx, cy - r * 0.92, r * 0.15)
                path.move(to: CGPoint(x: cx, y: cy - r * 1.05))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.35, y: cy - r * 1.25), controlPoint: CGPoint(x: cx + r * 0.2, y: cy - r * 1.35))
            }

        case .iceCream:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy + r * 1.05))
                path.addLine(to: CGPoint(x: cx - r * 0.5, y: cy))
                path.addLine(to: CGPoint(x: cx + r * 0.5, y: cy))
                path.close()
                path.move(to: CGPoint(x: cx - r * 0.35, y: cy + r * 0.3))
                path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.8))
                path.move(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.3))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.8))
                addCircle(path, cx, cy - r * 0.25, r * 0.45)
                addCircle(path, cx, cy - r * 0.65, r * 0.35)
                addCircle(path, cx, cy - r * 1.05, r * 0.14)
            }

        case .strawberry:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy + r * 0.95))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.55), controlPoint1: CGPoint(x: cx - r * 1.1, y: cy + r * 0.4), controlPoint2: CGPoint(x: cx - r * 0.95, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.95, y: cy - r * 0.65), controlPoint2: CGPoint(x: cx + r * 1.1, y: cy + r * 0.4))
                path.move(to: CGPoint(x: cx, y: cy - r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.4, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.65))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.65))
                path.addLine(to: CGPoint(x: cx + r * 0.4, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.55))
                path.move(to: CGPoint(x: cx, y: cy - r * 0.95))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.3, y: cy - r * 1.2), controlPoint: CGPoint(x: cx + r * 0.15, y: cy - r * 1.25))
                let dotPositions = [
                    (-0.35, -0.1), (0.0, -0.2), (0.35, -0.1),
                    (-0.25, 0.25), (0.25, 0.25), (0.0, 0.55)
                ]
                for (dx, dy) in dotPositions {
                    addCircle(path, cx + r * dx, cy + r * dy, r * 0.05)
                }
            }

        case .cherry:
            do {
                let r = s * 0.8
                // 2 cherries
                addCircle(path, cx - r * 0.45, cy + r * 0.45, r * 0.42)
                addCircle(path, cx + r * 0.45, cy + r * 0.35, r * 0.42)
                // Left stem
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.05))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.95), controlPoint1: CGPoint(x: cx - r * 0.3, y: cy - r * 0.5), controlPoint2: CGPoint(x: cx - r * 0.1, y: cy - r * 0.85))
                // Right stem
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.05))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.3, y: cy - r * 0.5), controlPoint2: CGPoint(x: cx + r * 0.1, y: cy - r * 0.85))
                // Leaf at junction
                addLeaf(path, cx, cy - r * 0.95, cx + r * 0.65, cy - r * 1.15, r * 0.25)
            }

        case .donut:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r)
                addCircle(path, cx, cy, r * 0.38)
                // Wavy frosting outline
                let points = 16
                for _i in 0..<points {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / points
                    let fr = r * (0.75 + 0.12 * sin(i * 3.0))
                    let px = (cx + cos(a) * fr)
                    let py = (cy + sin(a) * fr)
                    if (i == 0) path.move(to: CGPoint(x: px, y: py)) else path.addLine(to: CGPoint(x: px, y: py))
                }
                path.close()
                // Sprinkles
                for _i in 0..<8 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 8 + 0.2
                    let px = (cx + cos(a) * r * 0.58)
                    let py = (cy + sin(a) * r * 0.58)
                    path.move(to: CGPoint(x: px - r * 0.04, y: py))
                    path.addLine(to: CGPoint(x: px + r * 0.04, y: py))
                }
            }

        case .watermelon:
            do {
                let r = s * 0.9
                // Sliced slice
                path.move(to: CGPoint(x: cx, y: cy - r * 0.6))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.65))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.65), controlPoint: CGPoint(x: cx, y: cy + r * 0.95))
                path.close()
                // Rind inner arc
                path.move(to: CGPoint(x: cx - r * 0.72, y: cy + r * 0.55))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.72, y: cy + r * 0.55), controlPoint: CGPoint(x: cx, y: cy + r * 0.8))
                // Seeds
                let seeds = [(-0.25, 0.1), (0.25, 0.1), (0.0, -0.1), (-0.1, 0.35), (0.1, 0.35)]
                for (dx, dy) in seeds {
                    addCircle(path, cx + r * dx, cy + r * dy, r * 0.04)
                }
            }

        case .avocado:
            do {
                let r = s * 0.85
                // Pear-shaped avocado body
                path.move(to: CGPoint(x: cx, y: cy - r * 0.95))
                path.addCurve(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.35), controlPoint1: CGPoint(x: cx - r * 0.6, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx - r * 0.5, y: cy - r * 0.2))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 1.05), controlPoint1: CGPoint(x: cx - r * 0.95, y: cy + r * 0.85), controlPoint2: CGPoint(x: cx - r * 0.45, y: cy + r * 1.05))
                path.addCurve(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.35), controlPoint1: CGPoint(x: cx + r * 0.45, y: cy + r * 1.05), controlPoint2: CGPoint(x: cx + r * 0.95, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.5, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx + r * 0.6, y: cy - r * 0.95))
                // Inner flesh ring
                addCircle(path, cx, cy + r * 0.45, r * 0.45)
                // Pit (seed)
                addCircle(path, cx, cy + r * 0.45, r * 0.28)
            }

        case .apple:
            do {
                let r = s * 0.82
                path.move(to: CGPoint(x: cx, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx - r * 0.95, y: cy + r * 0.2), controlPoint1: CGPoint(x: cx - r * 0.5, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx - r * 1.05, y: cy - r * 0.4))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.75), controlPoint1: CGPoint(x: cx - r * 0.9, y: cy + r * 0.85), controlPoint2: CGPoint(x: cx - r * 0.3, y: cy + r * 0.95))
                path.addCurve(to: CGPoint(x: cx + r * 0.95, y: cy + r * 0.2), controlPoint1: CGPoint(x: cx + r * 0.3, y: cy + r * 0.95), controlPoint2: CGPoint(x: cx + r * 0.9, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.65), controlPoint1: CGPoint(x: cx + r * 1.05, y: cy - r * 0.4), controlPoint2: CGPoint(x: cx + r * 0.5, y: cy - r * 0.95))
                // Stem
                path.move(to: CGPoint(x: cx, y: cy - r * 0.65))
                path.addQuadCurve(to: CGPoint(x: cx - r * 0.2, y: cy - r * 1.2), controlPoint: CGPoint(x: cx - r * 0.1, y: cy - r * 1.15))
                // Leaf
                addLeaf(path, cx, cy - r * 0.85, cx + r * 0.5, cy - r * 1.1, r * 0.22)
            }

        case .banana:
            do {
                let r = s * 0.88
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.55))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.45), controlPoint: CGPoint(x: cx, y: cy + r * 0.95))
                path.addQuadCurve(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.55), controlPoint: CGPoint(x: cx, y: cy + r * 0.6))
                // Inner ridge line
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy - r * 0.45))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.35), controlPoint: CGPoint(x: cx, y: cy + r * 0.75))
                // Stem tips
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.95, y: cy - r * 0.65))
                path.move(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.92, y: cy - r * 0.52))
            }

        case .candy:
            do {
                let r = s * 0.78
                // Center wrapped oval
                addOval(path, cx - r * 0.55, cy - r * 0.35, cx + r * 0.55, cy + r * 0.35)
                // Stripes on wrapper
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.32))
                path.addLine(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.32))
                path.move(to: CGPoint(x: cx + r * 0.1, y: cy - r * 0.32))
                path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy + r * 0.32))
                // Left twist
                path.move(to: CGPoint(x: cx - r * 0.55, y: cy))
                path.addLine(to: CGPoint(x: cx - r * 1.0, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 1.0, y: cy + r * 0.45))
                path.close()
                // Right twist
                path.move(to: CGPoint(x: cx + r * 0.55, y: cy))
                path.addLine(to: CGPoint(x: cx + r * 1.0, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 1.0, y: cy + r * 0.45))
                path.close()
            }

        case .lollipop:
            do {
                let r = s * 0.85
                // Candy spiral circle
                addCircle(path, cx, cy - r * 0.25, r * 0.58)
                addCircle(path, cx, cy - r * 0.25, r * 0.38)
                addCircle(path, cx, cy - r * 0.25, r * 0.18)
                // Stick
                path.move(to: CGPoint(x: cx, y: cy + r * 0.33))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 1.15))
                // Bow tie on stick
                path.move(to: CGPoint(x: cx, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.25, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx - r * 0.25, y: cy + r * 0.55))
                path.close()
                path.move(to: CGPoint(x: cx, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.55))
                path.close()
            }

        case .milkTea:
            do {
                let r = s * 0.82
                // Cup
                path.move(to: CGPoint(x: cx - r * 0.5, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.38, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.38, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.5, y: cy - r * 0.45))
                path.close()
                // Domed lid
                addArc(path, cx - r * 0.52, cy - r * 0.75, cx + r * 0.52, cy - r * 0.45, 180.0, 180.0)
                // Straw
                path.move(to: CGPoint(x: cx + r * 0.05, y: cy - r * 0.6))
                path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy - r * 1.15))
                // Tapioca pearls
                let boba = [(-0.2, 0.75), (0.0, 0.75), (0.2, 0.75), (-0.1, 0.85), (0.1, 0.85)]
                for (dx, dy) in boba {
                    addCircle(path, cx + r * dx, cy + r * dy, r * 0.06)
                }
            }

        case .hamburger:
            do {
                let r = s * 0.82
                // Top bun (dome)
                addArc(path, cx - r * 0.75, cy - r * 0.65, cx + r * 0.75, cy - r * 0.15, 180.0, 180.0)
                path.addLine(to: CGPoint(x: cx - r * 0.75, y: cy - r * 0.15))
                // Sesame seeds on top bun
                addCircle(path, cx - r * 0.3, cy - r * 0.35, r * 0.03)
                addCircle(path, cx, cy - r * 0.45, r * 0.03)
                addCircle(path, cx + r * 0.3, cy - r * 0.35, r * 0.03)
                // Lettuce (wavy)
                path.move(to: CGPoint(x: cx - r * 0.8, y: cy - r * 0.05))
                for _i in 0..<6 {
                    let i = CGFloat(_i)
                    let x1 = cx - r * 0.8 + r * (i + 1) * 0.26
                    let y1 = cy - r * 0.05 + (if (i % 2 == 0) r * 0.08 else -r * 0.05)
                    path.addLine(to: CGPoint(x: x1, y: y1))
                }
                // Meat patty
                addOval(path, cx - r * 0.75, cy + r * 0.08, cx + r * 0.75, cy + r * 0.28)
                // Bottom bun
                path.move(to: CGPoint(x: cx - r * 0.7, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.7, y: cy + r * 0.35))
                path.addQuadCurve(to: CGPoint(x: cx - r * 0.7, y: cy + r * 0.35), controlPoint: CGPoint(x: cx, y: cy + r * 0.65))
            }

        case .pizza:
            do {
                let r = s * 0.88
                // Slice triangle
                path.move(to: CGPoint(x: cx, y: cy + r * 0.85))
                path.addLine(to: CGPoint(x: cx - r * 0.75, y: cy - r * 0.65))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.65), controlPoint: CGPoint(x: cx, y: cy - r * 0.85))
                path.close()
                // Crust line
                path.move(to: CGPoint(x: cx - r * 0.68, y: cy - r * 0.52))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.68, y: cy - r * 0.52), controlPoint: CGPoint(x: cx, y: cy - r * 0.72))
                // Pepperoni slices
                addCircle(path, cx, cy - r * 0.2, r * 0.12)
                addCircle(path, cx - r * 0.25, cy + r * 0.15, r * 0.11)
                addCircle(path, cx + r * 0.25, cy + r * 0.15, r * 0.11)
            }

        case .bowTie:
            do {
                let r = s * 0.85
                // Center knot
                addCircle(path, cx, cy, r * 0.18)
                // Left wing
                path.move(to: CGPoint(x: cx - r * 0.18, y: cy))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.55))
                path.close()
                // Right wing
                path.move(to: CGPoint(x: cx + r * 0.18, y: cy))
                path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.55))
                path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.55))
                path.close()
                // Ribbon tails
                path.move(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.15))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.2, y: cy + r * 0.9))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 0.18))
                path.move(to: CGPoint(x: cx + r * 0.1, y: cy + r * 0.15))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy + r * 0.9))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 0.18))
            }

        case .balloon:
            do {
                let r = s * 0.8
                // Main middle balloon
                addOval(path, cx - r * 0.45, cy - r * 0.95, cx + r * 0.45, cy + r * 0.15)
                // Left balloon
                addOval(path, cx - r * 0.85, cy - r * 0.75, cx - r * 0.15, cy + r * 0.25)
                // Right balloon
                addOval(path, cx + r * 0.15, cy - r * 0.75, cx + r * 0.85, cy + r * 0.25)
                // Knot & string
                path.move(to: CGPoint(x: cx, y: cy + r * 0.15))
                path.addLine(to: CGPoint(x: cx - r * 0.08, y: cy + r * 0.25))
                path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy + r * 0.25))
                path.close()
                path.move(to: CGPoint(x: cx, y: cy + r * 0.25))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 1.15), controlPoint1: CGPoint(x: cx - r * 0.2, y: cy + r * 0.5), controlPoint2: CGPoint(x: cx + r * 0.2, y: cy + r * 0.8))
            }

        case .sunglasses:
            do {
                let r = s * 0.82
                // Left heart lens
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.4))
                path.addCurve(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.25), controlPoint1: CGPoint(x: cx - r * 0.9, y: cy - r * 0.1), controlPoint2: CGPoint(x: cx - r * 0.75, y: cy - r * 0.55))
                path.addCurve(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.4), controlPoint1: CGPoint(x: cx - r * 0.15, y: cy - r * 0.55), controlPoint2: CGPoint(x: cx, y: cy - r * 0.1))
                // Right heart lens
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.4))
                path.addCurve(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.25), controlPoint1: CGPoint(x: cx, y: cy - r * 0.1), controlPoint2: CGPoint(x: cx + r * 0.15, y: cy - r * 0.55))
                path.addCurve(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.4), controlPoint1: CGPoint(x: cx + r * 0.75, y: cy - r * 0.55), controlPoint2: CGPoint(x: cx + r * 0.9, y: cy - r * 0.1))
                // Bridge
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.15))
                path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.15))
                // Left arm
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.25))
                path.addLine(to: CGPoint(x: cx - r * 1.0, y: cy - r * 0.45))
                // Right arm
                path.move(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.25))
                path.addLine(to: CGPoint(x: cx + r * 1.0, y: cy - r * 0.45))
            }

        case .coffeeCup:
            do {
                let r = s * 0.8
                // Cup body
                path.move(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.25))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.55))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.55), controlPoint: CGPoint(x: cx, y: cy + r * 0.65))
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.25))
                path.close()
                // Handle
                addArc(path, cx + r * 0.45, cy - r * 0.15, cx + r * 0.85, cy + r * 0.35, -90.0, 180.0)
                // Saucer
                addOval(path, cx - r * 0.75, cy + r * 0.55, cx + r * 0.75, cy + r * 0.75)
                // Steam curves
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.4))
                path.addCurve(to: CGPoint(x: cx - r * 0.2, y: cy - r * 1.05), controlPoint1: CGPoint(x: cx - r * 0.3, y: cy - r * 0.6), controlPoint2: CGPoint(x: cx - r * 0.1, y: cy - r * 0.8))
                path.move(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.4))
                path.addCurve(to: CGPoint(x: cx + r * 0.15, y: cy - r * 1.05), controlPoint1: CGPoint(x: cx + r * 0.05, y: cy - r * 0.6), controlPoint2: CGPoint(x: cx + r * 0.25, y: cy - r * 0.8))
            }

        case .giftBox:
            do {
                let r = s * 0.8
                // Box base
                addRect(path, cx - r * 0.65, cy - r * 0.25, cx + r * 0.65, cy + r * 0.85)
                // Lid
                addRect(path, cx - r * 0.75, cy - r * 0.45, cx + r * 0.75, cy - r * 0.25)
                // Vertical ribbon
                path.move(to: CGPoint(x: cx - r * 0.1, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.85))
                path.move(to: CGPoint(x: cx + r * 0.1, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.1, y: cy + r * 0.85))
                // Bow loops on top
                addOval(path, cx - r * 0.4, cy - r * 0.85, cx, cy - r * 0.45)
                addOval(path, cx, cy - r * 0.85, cx + r * 0.4, cy - r * 0.45)
            }

        case .umbrella:
            do {
                let r = s * 0.85
                // Umbrella canopy dome
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy))
                path.addCurve(to: CGPoint(x: cx + r * 0.85, y: cy), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy - r * 0.85), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy - r * 0.85))
                // Scallop bottom
                for _i in 0..<4 {
                    let i = CGFloat(_i)
                    let p1 = cx + r * 0.85 - r * i * 0.425
                    let p2 = cx + r * 0.85 - r * (i + 1) * 0.425
                    path.addQuadCurve(to: CGPoint(x: p2, y: cy), controlPoint: CGPoint(x: (p1 + p2) / 2, y: cy - r * 0.12))
                }
                // Handle shaft
                path.move(to: CGPoint(x: cx, y: cy - r * 0.8))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 0.75))
                // J hook handle
                addArc(path, cx - r * 0.25, cy + r * 0.55, cx + r * 0.05, cy + r * 0.95, 0.0, 180.0)
                // Tip
                path.move(to: CGPoint(x: cx, y: cy - r * 0.8))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.98))
            }

        case .bell:
            do {
                let r = s * 0.82
                // Top loop
                addArc(path, cx - r * 0.18, cy - r * 0.95, cx + r * 0.18, cy - r * 0.65, 180.0, 180.0)
                // Bell body
                path.move(to: CGPoint(x: cx - r * 0.25, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.6), controlPoint1: CGPoint(x: cx - r * 0.35, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.75, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy + r * 0.6))
                path.addCurve(to: CGPoint(x: cx + r * 0.25, y: cy - r * 0.65), controlPoint1: CGPoint(x: cx + r * 0.75, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.35, y: cy - r * 0.2))
                path.close()
                // Clapper
                addCircle(path, cx, cy + r * 0.8, r * 0.16)
            }

        case .flowerTulip:
            do {
                let r = s * 0.85
                // Tulip petal cups
                path.move(to: CGPoint(x: cx, y: cy + r * 0.35))
                path.addCurve(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.75), controlPoint1: CGPoint(x: cx - r * 0.65, y: cy + r * 0.35), controlPoint2: CGPoint(x: cx - r * 0.65, y: cy - r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.4))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.4))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.75))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.35), controlPoint1: CGPoint(x: cx + r * 0.65, y: cy - r * 0.55), controlPoint2: CGPoint(x: cx + r * 0.65, y: cy + r * 0.35))
                // Stem
                path.move(to: CGPoint(x: cx, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 1.05))
                // Leaves
                addLeaf(path, cx, cy + r * 0.95, cx - r * 0.55, cy + r * 0.45, r * 0.25)
                addLeaf(path, cx, cy + r * 0.85, cx + r * 0.55, cy + r * 0.35, r * 0.25)
            }

            // ==========================================
            // --- ĐỘNG VẬT (25 MẪU) ---
            // ==========================================

        case .cat:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy + r * 0.32, r * 0.52)
                addCircle(path, cx, cy - r * 0.35, r * 0.42)
                path.move(to: CGPoint(x: cx - r * 0.38, y: cy - r * 0.5))
                path.addLine(to: CGPoint(x: cx - r * 0.48, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.12, y: cy - r * 0.72))
                path.close()
                path.move(to: CGPoint(x: cx + r * 0.38, y: cy - r * 0.5))
                path.addLine(to: CGPoint(x: cx + r * 0.48, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.12, y: cy - r * 0.72))
                path.close()
                addCircle(path, cx - r * 0.16, cy - r * 0.4, r * 0.05)
                addCircle(path, cx + r * 0.16, cy - r * 0.4, r * 0.05)
                path.move(to: CGPoint(x: cx - r * 0.06, y: cy - r * 0.28))
                path.addLine(to: CGPoint(x: cx + r * 0.06, y: cy - r * 0.28))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.22))
                path.close()
                path.move(to: CGPoint(x: cx, y: cy - r * 0.22))
                path.addQuadCurve(to: CGPoint(x: cx - r * 0.12, y: cy - r * 0.18), controlPoint: CGPoint(x: cx - r * 0.08, y: cy - r * 0.14))
                path.move(to: CGPoint(x: cx, y: cy - r * 0.22))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.12, y: cy - r * 0.18), controlPoint: CGPoint(x: cx + r * 0.08, y: cy - r * 0.14))
                path.move(to: CGPoint(x: cx - r * 0.22, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.32))
                path.move(to: CGPoint(x: cx - r * 0.22, y: cy - r * 0.2)); path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.18))
                path.move(to: CGPoint(x: cx + r * 0.22, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.32))
                path.move(to: CGPoint(x: cx + r * 0.22, y: cy - r * 0.2)); path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.18))
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.55))
                path.addCurve(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.25), controlPoint1: CGPoint(x: cx + r * 0.9, y: cy + r * 0.55), controlPoint2: CGPoint(x: cx + r * 0.95, y: cy - r * 0.1))
            }

        case .dog:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy - r * 0.25, r * 0.5)
                addCircle(path, cx, cy + r * 0.45, r * 0.45)
                // Left floppy ear
                path.move(to: CGPoint(x: cx - r * 0.4, y: cy - r * 0.45))
                path.addCurve(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.05), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy - r * 0.45), controlPoint2: CGPoint(x: cx - r * 0.85, y: cy + r * 0.15))
                // Right floppy ear
                path.move(to: CGPoint(x: cx + r * 0.4, y: cy - r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.05), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy - r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy + r * 0.15))
                addCircle(path, cx - r * 0.18, cy - r * 0.3, r * 0.06)
                addCircle(path, cx + r * 0.18, cy - r * 0.3, r * 0.06)
                addOval(path, cx - r * 0.15, cy - r * 0.15, cx + r * 0.15, cy)
                path.move(to: CGPoint(x: cx, y: cy))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 0.1))
                addArc(path, cx - r * 0.14, cy + r * 0.02, cx + r * 0.14, cy + r * 0.18, 0.0, 180.0)
                // Tail
                path.move(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.65))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.25), controlPoint: CGPoint(x: cx + r * 0.85, y: cy + r * 0.45))
            }

        case .butterfly:
            do {
                let r = s * 0.88
                // Center body
                addOval(path, cx - r * 0.08, cy - r * 0.45, cx + r * 0.08, cy + r * 0.45)
                addCircle(path, cx, cy - r * 0.55, r * 0.12)
                // Antennae
                path.move(to: CGPoint(x: cx, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx - r * 0.35, y: cy - r * 0.75), controlPoint1: CGPoint(x: cx - r * 0.15, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx - r * 0.4, y: cy - r * 0.85))
                path.move(to: CGPoint(x: cx, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.75), controlPoint1: CGPoint(x: cx + r * 0.15, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx + r * 0.4, y: cy - r * 0.85))
                // Top wings
                path.move(to: CGPoint(x: cx - r * 0.08, y: cy - r * 0.2))
                path.addCurve(to: CGPoint(x: cx - r * 0.65, y: cy), controlPoint1: CGPoint(x: cx - r * 0.65, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx - r * 0.98, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.08, y: cy))
                path.move(to: CGPoint(x: cx + r * 0.08, y: cy - r * 0.2))
                path.addCurve(to: CGPoint(x: cx + r * 0.65, y: cy), controlPoint1: CGPoint(x: cx + r * 0.65, y: cy - r * 0.95), controlPoint2: CGPoint(x: cx + r * 0.98, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy))
                // Bottom wings
                path.move(to: CGPoint(x: cx - r * 0.08, y: cy))
                path.addCurve(to: CGPoint(x: cx - r * 0.08, y: cy + r * 0.45), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.6, y: cy + r * 0.85))
                path.move(to: CGPoint(x: cx + r * 0.08, y: cy))
                path.addCurve(to: CGPoint(x: cx + r * 0.08, y: cy + r * 0.45), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx + r * 0.6, y: cy + r * 0.85))
                // Wing spots
                addCircle(path, cx - r * 0.45, cy - r * 0.35, r * 0.12)
                addCircle(path, cx + r * 0.45, cy - r * 0.35, r * 0.12)
            }

        case .dino:
            do {
                let r = s * 0.85
                // Dino body
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.15))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.75), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy - r * 0.65), controlPoint2: CGPoint(x: cx - r * 0.25, y: cy - r * 0.75))
                path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.75))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.55), controlPoint: CGPoint(x: cx + r * 0.55, y: cy - r * 0.75))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy - r * 0.4))
                path.addCurve(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx + r * 0.25, y: cy - r * 0.1), controlPoint2: CGPoint(x: cx + r * 0.55, y: cy + r * 0.1))
                // Legs
                path.addLine(to: CGPoint(x: cx + r * 0.4, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.65))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.65))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.3, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.35, y: cy + r * 0.6))
                // Tail
                path.addCurve(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.15), controlPoint1: CGPoint(x: cx - r * 0.65, y: cy + r * 0.65), controlPoint2: CGPoint(x: cx - r * 1.05, y: cy + r * 0.35))
                // Eye & smile
                addCircle(path, cx + r * 0.4, cy - r * 0.65, r * 0.05)
            }

        case .dolphin:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.15), controlPoint1: CGPoint(x: cx - r * 0.45, y: cy - r * 0.85), controlPoint2: CGPoint(x: cx + r * 0.45, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.92, y: cy - r * 0.1))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.65, y: cy + r * 0.1), controlPoint: CGPoint(x: cx + r * 0.75, y: cy + r * 0.05))
                path.addCurve(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.45), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy + r * 0.4), controlPoint2: CGPoint(x: cx - r * 0.2, y: cy + r * 0.4))
                // Tail flukes
                path.addLine(to: CGPoint(x: cx - r * 1.05, y: cy + r * 0.25))
                path.addLine(to: CGPoint(x: cx - r * 0.92, y: cy + r * 0.48))
                path.addLine(to: CGPoint(x: cx - r * 1.05, y: cy + r * 0.7))
                path.close()
                // Dorsal fin
                path.move(to: CGPoint(x: cx + r * 0.1, y: cy - r * 0.75))
                path.addCurve(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.7), controlPoint1: CGPoint(x: cx + r * 0.05, y: cy - r * 1.05), controlPoint2: CGPoint(x: cx - r * 0.15, y: cy - r * 1.0))
                // Flipper
                path.move(to: CGPoint(x: cx + r * 0.3, y: cy + r * 0.1))
                path.addCurve(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.15), controlPoint1: CGPoint(x: cx + r * 0.25, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.05, y: cy + r * 0.4))
                addCircle(path, cx + r * 0.62, cy - r * 0.22, r * 0.04)
            }

        case .penguin:
            do {
                let r = s * 0.85
                addOval(path, cx - r * 0.5, cy - r * 0.85, cx + r * 0.5, cy + r * 0.75)
                addOval(path, cx - r * 0.3, cy - r * 0.35, cx + r * 0.3, cy + r * 0.65)
                // Flippers
                path.move(to: CGPoint(x: cx - r * 0.48, y: cy - r * 0.2))
                path.addCurve(to: CGPoint(x: cx - r * 0.4, y: cy + r * 0.35), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy + r * 0.05), controlPoint2: CGPoint(x: cx - r * 0.75, y: cy + r * 0.45))
                path.move(to: CGPoint(x: cx + r * 0.48, y: cy - r * 0.2))
                path.addCurve(to: CGPoint(x: cx + r * 0.4, y: cy + r * 0.35), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy + r * 0.05), controlPoint2: CGPoint(x: cx + r * 0.75, y: cy + r * 0.45))
                // Eyes & beak
                addCircle(path, cx - r * 0.15, cy - r * 0.5, r * 0.05)
                addCircle(path, cx + r * 0.15, cy - r * 0.5, r * 0.05)
                path.move(to: CGPoint(x: cx - r * 0.08, y: cy - r * 0.42))
                path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy - r * 0.42))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.3))
                path.close()
                // Feet
                path.move(to: CGPoint(x: cx - r * 0.3, y: cy + r * 0.75)); path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.95)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.75))
                path.move(to: CGPoint(x: cx, y: cy + r * 0.75)); path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.95)); path.addLine(to: CGPoint(x: cx + r * 0.3, y: cy + r * 0.75))
            }

        case .rabbit:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy + r * 0.35, r * 0.48)
                addCircle(path, cx, cy - r * 0.22, r * 0.38)
                // Long ears
                addOval(path, cx - r * 0.32, cy - r * 1.05, cx - r * 0.08, cy - r * 0.45)
                addOval(path, cx + r * 0.08, cy - r * 1.05, cx + r * 0.32, cy - r * 0.45)
                // Inner ears
                addOval(path, cx - r * 0.26, cy - r * 0.95, cx - r * 0.14, cy - r * 0.55)
                addOval(path, cx + r * 0.14, cy - r * 0.95, cx + r * 0.26, cy - r * 0.55)
                // Eyes & nose
                addCircle(path, cx - r * 0.15, cy - r * 0.25, r * 0.05)
                addCircle(path, cx + r * 0.15, cy - r * 0.25, r * 0.05)
                addCircle(path, cx, cy - r * 0.12, r * 0.04)
                // Whiskers
                path.move(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.1)); path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.12))
                path.move(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.1)); path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.12))
            }

        case .panda:
            do {
                let r = s * 0.85
                // Head
                addCircle(path, cx, cy, r * 0.65)
                // Ears
                addCircle(path, cx - r * 0.52, cy - r * 0.52, r * 0.22)
                addCircle(path, cx + r * 0.52, cy - r * 0.52, r * 0.22)
                // Eye patches
                addOval(path, cx - r * 0.35, cy - r * 0.2, cx - r * 0.1, cy + r * 0.1)
                addOval(path, cx + r * 0.1, cy - r * 0.2, cx + r * 0.35, cy + r * 0.1)
                addCircle(path, cx - r * 0.22, cy - r * 0.05, r * 0.05)
                addCircle(path, cx + r * 0.22, cy - r * 0.05, r * 0.05)
                // Nose & mouth
                addOval(path, cx - r * 0.1, cy + r * 0.18, cx + r * 0.1, cy + r * 0.28)
                addArc(path, cx - r * 0.12, cy + r * 0.25, cx + r * 0.12, cy + r * 0.4, 0.0, 180.0)
            }

        case .bear:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy + r * 0.05, r * 0.62)
                addCircle(path, cx - r * 0.52, cy - r * 0.48, r * 0.2)
                addCircle(path, cx + r * 0.52, cy - r * 0.48, r * 0.2)
                addCircle(path, cx - r * 0.2, cy - r * 0.08, r * 0.05)
                addCircle(path, cx + r * 0.2, cy - r * 0.08, r * 0.05)
                // Snout
                addOval(path, cx - r * 0.25, cy + r * 0.12, cx + r * 0.25, cy + r * 0.48)
                addOval(path, cx - r * 0.1, cy + r * 0.18, cx + r * 0.1, cy + r * 0.3)
                addArc(path, cx - r * 0.12, cy + r * 0.28, cx + r * 0.12, cy + r * 0.42, 0.0, 180.0)
            }

        case .lion:
            do {
                let r = s * 0.85
                // Mane sun-like petals
                for _i in 0..<12 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 12
                    let px = (cx + cos(a) * r * 0.72)
                    let py = (cy + sin(a) * r * 0.72)
                    addCircle(path, px, py, r * 0.22)
                }
                // Center face
                addCircle(path, cx, cy, r * 0.5)
                addCircle(path, cx - r * 0.18, cy - r * 0.12, r * 0.05)
                addCircle(path, cx + r * 0.18, cy - r * 0.12, r * 0.05)
                path.move(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.08))
                path.addLine(to: CGPoint(x: cx + r * 0.1, y: cy + r * 0.08))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 0.2))
                path.close()
                addArc(path, cx - r * 0.14, cy + r * 0.15, cx + r * 0.14, cy + r * 0.32, 0.0, 180.0)
            }

        case .tiger:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.62)
                addCircle(path, cx - r * 0.52, cy - r * 0.45, r * 0.18)
                addCircle(path, cx + r * 0.52, cy - r * 0.45, r * 0.18)
                // Forehead stripes
                path.move(to: CGPoint(x: cx, y: cy - r * 0.55)); path.addLine(to: CGPoint(x: cx, y: cy - r * 0.35))
                path.move(to: CGPoint(x: cx - r * 0.18, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx - r * 0.08, y: cy - r * 0.35))
                path.move(to: CGPoint(x: cx + r * 0.18, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy - r * 0.35))
                // Eyes & nose
                addCircle(path, cx - r * 0.2, cy - r * 0.05, r * 0.05)
                addCircle(path, cx + r * 0.2, cy - r * 0.05, r * 0.05)
                path.move(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.12)); path.addLine(to: CGPoint(x: cx + r * 0.1, y: cy + r * 0.12)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.24)); path.close()
            }

        case .monkey:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.55)
                // Big ears
                addCircle(path, cx - r * 0.6, cy, r * 0.25)
                addCircle(path, cx + r * 0.6, cy, r * 0.25)
                // Heart-shaped face
                addCircle(path, cx - r * 0.18, cy - r * 0.08, r * 0.22)
                addCircle(path, cx + r * 0.18, cy - r * 0.08, r * 0.22)
                addCircle(path, cx - r * 0.18, cy - r * 0.08, r * 0.05)
                addCircle(path, cx + r * 0.18, cy - r * 0.08, r * 0.05)
                addOval(path, cx - r * 0.3, cy + r * 0.1, cx + r * 0.3, cy + r * 0.45)
                addArc(path, cx - r * 0.16, cy + r * 0.2, cx + r * 0.16, cy + r * 0.38, 0.0, 180.0)
            }

        case .elephant:
            do {
                let r = s * 0.85
                // Head
                addCircle(path, cx, cy - r * 0.15, r * 0.45)
                // Big ears
                addOval(path, cx - r * 0.95, cy - r * 0.45, cx - r * 0.35, cy + r * 0.25)
                addOval(path, cx + r * 0.35, cy - r * 0.45, cx + r * 0.95, cy + r * 0.25)
                // Trunk curled up
                path.move(to: CGPoint(x: cx - r * 0.12, y: cy + r * 0.1))
                path.addCurve(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.65), controlPoint1: CGPoint(x: cx - r * 0.15, y: cy + r * 0.75), controlPoint2: CGPoint(x: cx + r * 0.25, y: cy + r * 0.95))
                path.addCurve(to: CGPoint(x: cx + r * 0.1, y: cy + r * 0.1), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.1, y: cy + r * 0.45))
                addCircle(path, cx - r * 0.2, cy - r * 0.15, r * 0.05)
                addCircle(path, cx + r * 0.2, cy - r * 0.15, r * 0.05)
            }

        case .giraffe:
            do {
                let r = s * 0.85
                // Head
                addOval(path, cx - r * 0.25, cy - r * 0.85, cx + r * 0.25, cy - r * 0.35)
                // Horns (ossicones)
                path.move(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.82)); path.addLine(to: CGPoint(x: cx - r * 0.18, y: cy - r * 1.05))
                addCircle(path, cx - r * 0.18, cy - r * 1.05, r * 0.06)
                path.move(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.82)); path.addLine(to: CGPoint(x: cx + r * 0.18, y: cy - r * 1.05))
                addCircle(path, cx + r * 0.18, cy - r * 1.05, r * 0.06)
                // Long neck
                path.move(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.38)); path.addLine(to: CGPoint(x: cx - r * 0.25, y: cy + r * 1.05))
                path.move(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.38)); path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 1.05))
                // Spots on neck
                addCircle(path, cx, cy + r * 0.15, r * 0.1)
                addCircle(path, cx - r * 0.05, cy + r * 0.55, r * 0.11)
                addCircle(path, cx + r * 0.05, cy + r * 0.85, r * 0.11)
            }

        case .fox:
            do {
                let r = s * 0.85
                // Triangular head
                path.move(to: CGPoint(x: cx, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy - r * 0.15))
                path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy - r * 0.15))
                path.close()
                // Nose
                addCircle(path, cx, cy + r * 0.4, r * 0.07)
                // Eyes
                path.move(to: CGPoint(x: cx - r * 0.3, y: cy - r * 0.05)); path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy))
                path.move(to: CGPoint(x: cx + r * 0.3, y: cy - r * 0.05)); path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy))
            }

        case .owl:
            do {
                let r = s * 0.85
                // Body & ear tufts
                path.move(to: CGPoint(x: cx - r * 0.5, y: cy - r * 0.75))
                path.addLine(to: CGPoint(x: cx - r * 0.35, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.5, y: cy - r * 0.75))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.85), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx + r * 0.45, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx - r * 0.5, y: cy - r * 0.75), controlPoint1: CGPoint(x: cx - r * 0.45, y: cy + r * 0.85), controlPoint2: CGPoint(x: cx - r * 0.85, y: cy + r * 0.2))
                // Big eyes
                addCircle(path, cx - r * 0.25, cy - r * 0.15, r * 0.2)
                addCircle(path, cx + r * 0.25, cy - r * 0.15, r * 0.2)
                addCircle(path, cx - r * 0.25, cy - r * 0.15, r * 0.08)
                addCircle(path, cx + r * 0.25, cy - r * 0.15, r * 0.08)
                // Beak
                path.move(to: CGPoint(x: cx - r * 0.08, y: cy - r * 0.05)); path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy - r * 0.05)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.1)); path.close()
            }

        case .frog:
            do {
                let r = s * 0.85
                // Big eyes on top
                addCircle(path, cx - r * 0.42, cy - r * 0.45, r * 0.24)
                addCircle(path, cx + r * 0.42, cy - r * 0.45, r * 0.24)
                addCircle(path, cx - r * 0.42, cy - r * 0.45, r * 0.08)
                addCircle(path, cx + r * 0.42, cy - r * 0.45, r * 0.08)
                // Wide oval face
                addOval(path, cx - r * 0.75, cy - r * 0.35, cx + r * 0.75, cy + r * 0.45)
                // Wide frog smile
                addArc(path, cx - r * 0.45, cy - r * 0.1, cx + r * 0.45, cy + r * 0.35, 0.0, 180.0)
                // Rosy cheeks
                addCircle(path, cx - r * 0.48, cy + r * 0.1, r * 0.06)
                addCircle(path, cx + r * 0.48, cy + r * 0.1, r * 0.06)
            }

        case .chick:
            do {
                let r = s * 0.85
                // Round body
                addCircle(path, cx, cy + r * 0.15, r * 0.58)
                // Cute head fluff
                path.move(to: CGPoint(x: cx, y: cy - r * 0.43)); path.addLine(to: CGPoint(x: cx - r * 0.08, y: cy - r * 0.65)); path.addLine(to: CGPoint(x: cx, y: cy - r * 0.48))
                path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy - r * 0.65)); path.addLine(to: CGPoint(x: cx, y: cy - r * 0.43))
                // Big eyes
                addCircle(path, cx - r * 0.2, cy, r * 0.06)
                addCircle(path, cx + r * 0.2, cy, r * 0.06)
                // Beak
                path.move(to: CGPoint(x: cx - r * 0.08, y: cy + r * 0.08)); path.addLine(to: CGPoint(x: cx + r * 0.08, y: cy + r * 0.08)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.22)); path.close()
                // Wings
                addArc(path, cx - r * 0.65, cy, cx - r * 0.35, cy + r * 0.45, 90.0, 180.0)
                addArc(path, cx + r * 0.35, cy, cx + r * 0.65, cy + r * 0.45, -90.0, 180.0)
            }

        case .duck:
            do {
                let r = s * 0.85
                // Floating body
                path.move(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.15))
                path.addQuadCurve(to: CGPoint(x: cx - r * 0.95, y: cy - r * 0.15), controlPoint: CGPoint(x: cx - r * 0.85, y: cy + r * 0.05))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.55), controlPoint: CGPoint(x: cx - r * 0.75, y: cy + r * 0.55))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.15), controlPoint: CGPoint(x: cx + r * 0.65, y: cy + r * 0.55))
                path.close()
                // Head
                addCircle(path, cx + r * 0.35, cy - r * 0.25, r * 0.28)
                // Duck bill
                path.move(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.28))
                path.addLine(to: CGPoint(x: cx + r * 0.95, y: cy - r * 0.2))
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.12))
                path.close()
                addCircle(path, cx + r * 0.42, cy - r * 0.32, r * 0.04)
            }

        case .fish:
            do {
                let r = s * 0.85
                // Fish body outline
                path.move(to: CGPoint(x: cx + r * 0.85, y: cy))
                path.addCurve(to: CGPoint(x: cx - r * 0.65, y: cy), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy - r * 0.65), controlPoint2: CGPoint(x: cx - r * 0.45, y: cy - r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.85, y: cy), controlPoint1: CGPoint(x: cx - r * 0.45, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.35, y: cy + r * 0.65))
                // Tail fin
                path.move(to: CGPoint(x: cx - r * 0.65, y: cy))
                path.addLine(to: CGPoint(x: cx - r * 1.05, y: cy - r * 0.45))
                path.addQuadCurve(to: CGPoint(x: cx - r * 1.05, y: cy + r * 0.45), controlPoint: CGPoint(x: cx - r * 0.85, y: cy))
                path.close()
                // Eye & gill
                addCircle(path, cx + r * 0.55, cy - r * 0.08, r * 0.06)
                addArc(path, cx + r * 0.25, cy - r * 0.3, cx + r * 0.45, cy + r * 0.3, -90.0, 180.0)
            }

        case .octopus:
            do {
                let r = s * 0.85
                // Dome head
                addArc(path, cx - r * 0.55, cy - r * 0.85, cx + r * 0.55, cy + r * 0.15, 180.0, 180.0)
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy))
                path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy))
                // Eyes
                addCircle(path, cx - r * 0.2, cy - r * 0.25, r * 0.06)
                addCircle(path, cx + r * 0.2, cy - r * 0.25, r * 0.06)
                // 5 Curly tentacles
                for _i in 0..<5 {
                    let i = CGFloat(_i)
                    let tx = cx - r * 0.48 + r * i * 0.24
                    path.move(to: CGPoint(x: tx, y: cy))
                    path.addCurve(to: CGPoint(x: tx - r * 0.05, y: cy + r * 0.95), controlPoint1: CGPoint(x: tx - r * 0.15, y: cy + r * 0.5), controlPoint2: CGPoint(x: tx + r * 0.15, y: cy + r * 0.75))
                }
            }

        case .whale:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.15))
                path.addCurve(to: CGPoint(x: cx - r * 0.55, y: cy), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy - r * 0.55), controlPoint2: CGPoint(x: cx - r * 0.15, y: cy - r * 0.55))
                path.addCurve(to: CGPoint(x: cx - r * 1.05, y: cy - r * 0.15), controlPoint1: CGPoint(x: cx - r * 0.75, y: cy + r * 0.25), controlPoint2: CGPoint(x: cx - r * 0.95, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx - r * 0.95, y: cy + r * 0.25))
                path.addLine(to: CGPoint(x: cx - r * 1.05, y: cy + r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.75, y: cy + r * 0.35), controlPoint2: CGPoint(x: cx - r * 0.25, y: cy + r * 0.65))
                path.close()
                // Eye & spout
                addCircle(path, cx + r * 0.65, cy - r * 0.05, r * 0.04)
                path.move(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.85))
                path.move(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.7)); path.addLine(to: CGPoint(x: cx + r * 0.05, y: cy - r * 0.95))
                path.move(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.7)); path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.95))
            }

        case .crab:
            do {
                let r = s * 0.85
                // Oval shell
                addOval(path, cx - r * 0.55, cy - r * 0.15, cx + r * 0.55, cy + r * 0.45)
                // Eyes on stalks
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.15)); path.addLine(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.38))
                addCircle(path, cx - r * 0.2, cy - r * 0.42, r * 0.08)
                path.move(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.15)); path.addLine(to: CGPoint(x: cx + r * 0.2, y: cy - r * 0.38))
                addCircle(path, cx + r * 0.2, cy - r * 0.42, r * 0.08)
                // Claws
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy)); path.addCurve(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.95, y: cy - r * 0.15), controlPoint2: CGPoint(x: cx - r * 0.85, y: cy - r * 0.75))
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy)); path.addCurve(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.55), controlPoint1: CGPoint(x: cx + r * 0.95, y: cy - r * 0.15), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy - r * 0.75))
            }

        case .snail:
            do {
                let r = s * 0.85
                // Shell concentric spiral
                addCircle(path, cx - r * 0.15, cy - r * 0.15, r * 0.52)
                addCircle(path, cx - r * 0.15, cy - r * 0.15, r * 0.34)
                addCircle(path, cx - r * 0.15, cy - r * 0.15, r * 0.16)
                // Body
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy + r * 0.45))
                path.addCurve(to: CGPoint(x: cx + r * 0.65, y: cy), controlPoint1: CGPoint(x: cx + r * 0.95, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy - r * 0.05))
                path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.25))
                // Tentacles (antennae)
                path.move(to: CGPoint(x: cx + r * 0.65, y: cy)); path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.35))
                addCircle(path, cx + r * 0.75, cy - r * 0.38, r * 0.04)
                path.move(to: CGPoint(x: cx + r * 0.58, y: cy)); path.addLine(to: CGPoint(x: cx + r * 0.62, y: cy - r * 0.32))
                addCircle(path, cx + r * 0.62, cy - r * 0.35, r * 0.04)
            }

        case .bee:
            do {
                let r = s * 0.85
                // Striped oval body
                addOval(path, cx - r * 0.45, cy - r * 0.25, cx + r * 0.45, cy + r * 0.45)
                // Stripes
                path.move(to: CGPoint(x: cx - r * 0.15, y: cy - r * 0.22)); path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.42))
                path.move(to: CGPoint(x: cx + r * 0.15, y: cy - r * 0.22)); path.addLine(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.42))
                // Stinger
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.1)); path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.1)); path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.18)); path.close()
                // Wings
                addOval(path, cx - r * 0.25, cy - r * 0.85, cx + r * 0.1, cy - r * 0.15)
                addOval(path, cx + r * 0.05, cy - r * 0.85, cx + r * 0.4, cy - r * 0.15)
            }

            // ==========================================
            // --- VŨ TRỤ & PHÉP THUẬT (25 MẪU) ---
            // ==========================================

        case .rocket:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy - r * 1.15))
                path.addCurve(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.45), controlPoint1: CGPoint(x: cx - r * 0.5, y: cy - r * 0.65), controlPoint2: CGPoint(x: cx - r * 0.45, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.45))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 1.15), controlPoint1: CGPoint(x: cx + r * 0.45, y: cy + r * 0.35), controlPoint2: CGPoint(x: cx + r * 0.5, y: cy - r * 0.65))
                // Left wing
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy + r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.45))
                // Right wing
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy + r * 0.55))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.45))
                // Window & exhaust flame
                addCircle(path, cx, cy - r * 0.25, r * 0.2)
                path.move(to: CGPoint(x: cx - r * 0.25, y: cy + r * 0.45))
                path.addLine(to: CGPoint(x: cx, y: cy + r * 1.15))
                path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.45))
            }

        case .moonStars:
            do {
                let r = s * 0.85
                // Crescent moon
                path.move(to: CGPoint(x: cx - r * 0.1, y: cy - r * 0.95))
                path.addCurve(to: CGPoint(x: cx - r * 0.1, y: cy + r * 0.95), controlPoint1: CGPoint(x: cx - r * 0.95, y: cy - r * 0.6), controlPoint2: CGPoint(x: cx - r * 0.95, y: cy + r * 0.6))
                path.addCurve(to: CGPoint(x: cx - r * 0.1, y: cy - r * 0.95), controlPoint1: CGPoint(x: cx - r * 0.55, y: cy + r * 0.45), controlPoint2: CGPoint(x: cx - r * 0.55, y: cy - r * 0.45))
                // Sparkle stars
                addStar(path, cx + r * 0.45, cy - r * 0.45, r * 0.32)
                addStar(path, cx + r * 0.65, cy + r * 0.35, r * 0.22)
                addStar(path, cx + r * 0.15, cy + r * 0.15, r * 0.14)
            }

        case .crown:
            do {
                let r = s * 0.82
                // 5 peaks crown
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.55))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx - r * 0.42, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx, y: cy - r * 0.75))
                path.addLine(to: CGPoint(x: cx + r * 0.42, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.45))
                path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy + r * 0.55))
                path.close()
                // Jewels on tips
                addCircle(path, cx - r * 0.85, cy - r * 0.45, r * 0.08)
                addCircle(path, cx, cy - r * 0.75, r * 0.08)
                addCircle(path, cx + r * 0.85, cy - r * 0.45, r * 0.08)
                // Base band
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.38)); path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy + r * 0.38))
            }

        case .diamond:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.25))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.25))
                path.close()
                // Facets
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.25))
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.85)); path.addLine(to: CGPoint(x: cx - r * 0.25, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.95))
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.85)); path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.95))
            }

        case .music:
            do {
                let r = s * 0.82
                // Note heads
                addCircle(path, cx - r * 0.4, cy + r * 0.45, r * 0.22)
                addCircle(path, cx + r * 0.35, cy + r * 0.25, r * 0.22)
                // Stems
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy + r * 0.45)); path.addLine(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.55))
                path.move(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.25)); path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.75))
                // Connecting beam
                path.move(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.65))
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.78)); path.addLine(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.58)); path.close()
            }

        case .saturn:
            do {
                let r = s * 0.85
                // Planet sphere
                addCircle(path, cx, cy, r * 0.55)
                // Tilted ring
                addOval(path, cx - r * 0.98, cy - r * 0.32, cx + r * 0.98, cy + r * 0.32)
                addOval(path, cx - r * 0.78, cy - r * 0.22, cx + r * 0.78, cy + r * 0.22)
            }

        case .ufo:
            do {
                let r = s * 0.82
                // Glass cockpit dome
                addArc(path, cx - r * 0.45, cy - r * 0.65, cx + r * 0.45, cy - r * 0.05, 180.0, 180.0)
                // Saucer disc
                addOval(path, cx - r * 0.95, cy - r * 0.15, cx + r * 0.95, cy + r * 0.25)
                // Porthole lights
                for _i in -2...2 {
                    let i = CGFloat(_i)
                    addCircle(path, cx + r * i * 0.32, cy + r * 0.05, r * 0.06)
                }
                // Tractor beam
                path.move(to: CGPoint(x: cx - r * 0.35, y: cy + r * 0.25)); path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.95))
                path.move(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.25)); path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy + r * 0.95))
            }

        case .astronaut:
            do {
                let r = s * 0.85
                // Helmet
                addOval(path, cx - r * 0.55, cy - r * 0.85, cx + r * 0.55, cy - r * 0.05)
                // Visor
                addOval(path, cx - r * 0.4, cy - r * 0.7, cx + r * 0.4, cy - r * 0.2)
                // Torso & backpack
                addRect(path, cx - r * 0.45, cy - r * 0.05, cx + r * 0.45, cy + r * 0.65)
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.65)); path.addLine(to: CGPoint(x: cx - r * 0.3, y: cy + r * 1.05))
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.65)); path.addLine(to: CGPoint(x: cx + r * 0.3, y: cy + r * 1.05))
            }

        case .meteor:
            do {
                let r = s * 0.85
                // Meteor rock
                addCircle(path, cx - r * 0.45, cy + r * 0.45, r * 0.35)
                // Crater dots
                addCircle(path, cx - r * 0.5, cy + r * 0.38, r * 0.08)
                addCircle(path, cx - r * 0.35, cy + r * 0.52, r * 0.06)
                // Flame tail
                path.move(to: CGPoint(x: cx - r * 0.35, y: cy + r * 0.2))
                path.addLine(to: CGPoint(x: cx + r * 0.95, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.4))
                path.move(to: CGPoint(x: cx - r * 0.25, y: cy + r * 0.3))
                path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.55))
            }

        case .telescope:
            do {
                let r = s * 0.82
                // Barrel tube angled
                path.move(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.15)); path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy - r * 0.65))
                path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy + r * 0.35)); path.close()
                // Lens flare star at end
                addStar(path, cx + r * 0.85, cy - r * 0.75, r * 0.2)
                // Tripod legs
                path.move(to: CGPoint(x: cx, y: cy + r * 0.05)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.95))
                path.move(to: CGPoint(x: cx, y: cy + r * 0.05)); path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy + r * 0.95))
                path.move(to: CGPoint(x: cx, y: cy + r * 0.05)); path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.95))
            }

        case .earth:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.75)
                // Equator & meridian lines
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy)); path.addLine(to: CGPoint(x: cx + r * 0.75, y: cy))
                addOval(path, cx - r * 0.35, cy - r * 0.75, cx + r * 0.35, cy + r * 0.75)
                // Cute mini moon orbiting
                addCircle(path, cx + r * 0.85, cy - r * 0.65, r * 0.12)
            }

        case .comet:
            do {
                let r = s * 0.85
                addCircle(path, cx + r * 0.45, cy - r * 0.45, r * 0.32)
                // 3 sweeping tail curves
                path.move(to: CGPoint(x: cx + r * 0.25, y: cy - r * 0.35))
                path.addCurve(to: CGPoint(x: cx - r * 0.95, y: cy + r * 0.75), controlPoint1: CGPoint(x: cx, y: cy), controlPoint2: CGPoint(x: cx - r * 0.45, y: cy + r * 0.35))
                path.move(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.15))
                path.addCurve(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.1, y: cy + r * 0.15), controlPoint2: CGPoint(x: cx - r * 0.25, y: cy + r * 0.55))
                path.move(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.25))
                path.addCurve(to: CGPoint(x: cx - r * 0.95, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.1, y: cy + r * 0.05), controlPoint2: CGPoint(x: cx - r * 0.5, y: cy + r * 0.35))
            }

        case .lightning:
            do {
                let r = s * 0.88
                // Sharp zig-zag bolt
                path.move(to: CGPoint(x: cx + r * 0.25, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.45, y: cy - r * 0.05))
                path.addLine(to: CGPoint(x: cx - r * 0.05, y: cy - r * 0.05))
                path.addLine(to: CGPoint(x: cx - r * 0.35, y: cy + r * 0.95))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.05))
                path.addLine(to: CGPoint(x: cx + r * 0.05, y: cy + r * 0.05))
                path.close()
            }

        case .galaxySpiral:
            do {
                let r = s * 0.88
                // Archimedean spiral arms
                for _arm in 0..<2 {
                    let arm = CGFloat(_arm)
                    let baseA = arm * CGFloat.pi
                    for _step in 1...40 {
                        let step = CGFloat(_step)
                        let angle = baseA + step * 0.18
                        let rad = r * (step / 40.0) * 0.92
                        let nx = (cx + cos(angle) * rad)
                        let ny = (cy + sin(angle) * rad)
                        if (step == 1) path.move(to: CGPoint(x: nx, y: ny)) else path.addLine(to: CGPoint(x: nx, y: ny))
                    }
                }
                addCircle(path, cx, cy, r * 0.15)
            }

        case .magicWand:
            do {
                let r = s * 0.85
                // Wand stick
                path.move(to: CGPoint(x: cx - r * 0.75, y: cy + r * 0.75)); path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy - r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.25)); path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.85)); path.close()
                // Star at tip
                addStar(path, cx + r * 0.55, cy - r * 0.55, r * 0.35)
                // Sparkles around
                addStar(path, cx + r * 0.85, cy - r * 0.2, r * 0.14)
                addStar(path, cx + r * 0.2, cy - r * 0.85, r * 0.14)
            }

        case .crystalBall:
            do {
                let r = s * 0.82
                // Sphere
                addCircle(path, cx, cy - r * 0.15, r * 0.58)
                // Star inside ball
                addStar(path, cx, cy - r * 0.15, r * 0.22)
                // Stand base
                path.move(to: CGPoint(x: cx - r * 0.45, y: cy + r * 0.42))
                path.addLine(to: CGPoint(x: cx + r * 0.45, y: cy + r * 0.42))
                path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy + r * 0.85))
                path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.85))
                path.close()
            }

        case .shield:
            do {
                let r = s * 0.85
                path.move(to: CGPoint(x: cx, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy - r * 0.85))
                path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy + r * 0.15))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.65, y: cy + r * 0.65), controlPoint2: CGPoint(x: cx, y: cy + r * 0.95))
                path.addCurve(to: CGPoint(x: cx - r * 0.65, y: cy + r * 0.15), controlPoint1: CGPoint(x: cx, y: cy + r * 0.95), controlPoint2: CGPoint(x: cx - r * 0.65, y: cy + r * 0.65))
                path.addLine(to: CGPoint(x: cx - r * 0.65, y: cy - r * 0.85))
                path.close()
                // Emblem star in center
                addStar(path, cx, cy - r * 0.1, r * 0.3)
            }

        case .sword:
            do {
                let r = s * 0.85
                // Blade
                path.move(to: CGPoint(x: cx, y: cy - r * 1.15))
                path.addLine(to: CGPoint(x: cx - r * 0.12, y: cy - r * 0.95))
                path.addLine(to: CGPoint(x: cx - r * 0.12, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.12, y: cy + r * 0.35))
                path.addLine(to: CGPoint(x: cx + r * 0.12, y: cy - r * 0.95))
                path.close()
                // Center fuller groove
                path.move(to: CGPoint(x: cx, y: cy - r * 0.95)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.3))
                // Crossguard
                addOval(path, cx - r * 0.45, cy + r * 0.35, cx + r * 0.45, cy + r * 0.48)
                // Handle & pommel
                addRect(path, cx - r * 0.08, cy + r * 0.48, cx + r * 0.08, cy + r * 0.85)
                addCircle(path, cx, cy + r * 0.92, r * 0.1)
            }

        case .castle:
            do {
                let r = s * 0.85
                // Main base
                addRect(path, cx - r * 0.55, cy - r * 0.15, cx + r * 0.55, cy + r * 0.85)
                // Left tower
                addRect(path, cx - r * 0.85, cy - r * 0.45, cx - r * 0.55, cy + r * 0.85)
                path.move(to: CGPoint(x: cx - r * 0.85, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx - r * 0.7, y: cy - r * 0.85)); path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.45)); path.close()
                // Right tower
                addRect(path, cx + r * 0.55, cy - r * 0.45, cx + r * 0.85, cy + r * 0.85)
                path.move(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.45)); path.addLine(to: CGPoint(x: cx + r * 0.7, y: cy - r * 0.85)); path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy - r * 0.45)); path.close()
                // Center door
                addArc(path, cx - r * 0.18, cy + r * 0.45, cx + r * 0.18, cy + r * 0.85, 180.0, 180.0)
            }

        case .fireFlame:
            do {
                let r = s * 0.85
                // Outer flame
                path.move(to: CGPoint(x: cx, y: cy + r * 0.95))
                path.addCurve(to: CGPoint(x: cx - r * 0.2, y: cy - r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.85, y: cy + r * 0.75), controlPoint2: CGPoint(x: cx - r * 0.85, y: cy - r * 0.15))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 1.15), controlPoint1: CGPoint(x: cx - r * 0.1, y: cy - r * 0.75), controlPoint2: CGPoint(x: cx - r * 0.1, y: cy - r * 1.05))
                path.addCurve(to: CGPoint(x: cx + r * 0.45, y: cy - r * 0.15), controlPoint1: CGPoint(x: cx + r * 0.1, y: cy - r * 0.75), controlPoint2: CGPoint(x: cx + r * 0.65, y: cy - r * 0.55))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.95), controlPoint1: CGPoint(x: cx + r * 0.85, y: cy + r * 0.15), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy + r * 0.75))
                // Inner core flame
                path.move(to: CGPoint(x: cx, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.45), controlPoint1: CGPoint(x: cx - r * 0.35, y: cy + r * 0.65), controlPoint2: CGPoint(x: cx - r * 0.35, y: cy + r * 0.15))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.85), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy + r * 0.15), controlPoint2: CGPoint(x: cx + r * 0.35, y: cy + r * 0.65))
            }

        case .snowflake:
            do {
                let r = s * 0.88
                // 6 spokes with chevrons
                for _i in 0..<6 {
                    let i = CGFloat(_i)
                    let a = i * CGFloat.pi / 3
                    let x2 = (cx + cos(a) * r * 0.95)
                    let y2 = (cy + sin(a) * r * 0.95)
                    path.move(to: CGPoint(x: cx, y: cy)); path.addLine(to: CGPoint(x: x2, y: y2))
                    // Chevrons
                    let c1 = 0.55
                    let cx1 = (cx + cos(a) * r * c1)
                    let cy1 = (cy + sin(a) * r * c1)
                    let bAngle1 = a + CGFloat.pi / 4
                    let bAngle2 = a - CGFloat.pi / 4
                    path.move(to: CGPoint(x: cx1, y: cy1)); path.addLine(to: CGPoint(x: (cx1 + cos(bAngle1) * r * 0.2), y: (cy1 + sin(bAngle1)) * r * 0.2))
                    path.move(to: CGPoint(x: cx1, y: cy1)); path.addLine(to: CGPoint(x: (cx1 + cos(bAngle2) * r * 0.2), y: (cy1 + sin(bAngle2)) * r * 0.2))
                }
            }

        case .hourglass:
            do {
                let r = s * 0.82
                // Top & bottom caps
                addRect(path, cx - r * 0.65, cy - r * 0.95, cx + r * 0.65, cy - r * 0.8)
                addRect(path, cx - r * 0.65, cy + r * 0.8, cx + r * 0.65, cy + r * 0.95)
                // Glass bulb contour
                path.move(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.8))
                path.addLine(to: CGPoint(x: cx + r * 0.55, y: cy - r * 0.8))
                path.addCurve(to: CGPoint(x: cx, y: cy), controlPoint1: CGPoint(x: cx + r * 0.45, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx + r * 0.15, y: cy))
                path.addCurve(to: CGPoint(x: cx - r * 0.55, y: cy - r * 0.8), controlPoint1: CGPoint(x: cx - r * 0.15, y: cy), controlPoint2: CGPoint(x: cx - r * 0.45, y: cy - r * 0.2))
                path.move(to: CGPoint(x: cx, y: cy))
                path.addCurve(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.8), controlPoint1: CGPoint(x: cx + r * 0.15, y: cy), controlPoint2: CGPoint(x: cx + r * 0.45, y: cy + r * 0.2))
                path.addLine(to: CGPoint(x: cx - r * 0.55, y: cy + r * 0.8))
                path.addCurve(to: CGPoint(x: cx, y: cy), controlPoint1: CGPoint(x: cx - r * 0.45, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.15, y: cy))
            }

        case .compass:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.85)
                addCircle(path, cx, cy, r * 0.68)
                // 4-Point compass star
                path.move(to: CGPoint(x: cx, y: cy - r * 0.65)); path.addLine(to: CGPoint(x: cx + r * 0.12, y: cy)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.65)); path.addLine(to: CGPoint(x: cx - r * 0.12, y: cy)); path.close()
                path.move(to: CGPoint(x: cx - r * 0.65, y: cy)); path.addLine(to: CGPoint(x: cx, y: cy - r * 0.12)); path.addLine(to: CGPoint(x: cx + r * 0.65, y: cy)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.12)); path.close()
            }

        case .keyMagic:
            do {
                let r = s * 0.85
                // Top decorative heart loop
                addCircle(path, cx, cy - r * 0.55, r * 0.35)
                addCircle(path, cx, cy - r * 0.55, r * 0.18)
                // Shaft
                path.move(to: CGPoint(x: cx, y: cy - r * 0.2)); path.addLine(to: CGPoint(x: cx, y: cy + r * 0.95))
                // Key teeth
                path.move(to: CGPoint(x: cx, y: cy + r * 0.65)); path.addLine(to: CGPoint(x: cx + r * 0.25, y: cy + r * 0.65))
                path.move(to: CGPoint(x: cx, y: cy + r * 0.85)); path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.85)); path.addLine(to: CGPoint(x: cx + r * 0.35, y: cy + r * 0.75))
            }

        case .potion:
            do {
                let r = s * 0.85
                // Cork stopper
                addRect(path, cx - r * 0.18, cy - r * 0.95, cx + r * 0.18, cy - r * 0.75)
                // Neck
                addRect(path, cx - r * 0.14, cy - r * 0.75, cx + r * 0.14, cy - r * 0.35)
                // Round flask body
                path.move(to: CGPoint(x: cx - r * 0.14, y: cy - r * 0.35))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.85), controlPoint1: CGPoint(x: cx - r * 0.75, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.75, y: cy + r * 0.85))
                path.addCurve(to: CGPoint(x: cx + r * 0.14, y: cy - r * 0.35), controlPoint1: CGPoint(x: cx + r * 0.75, y: cy + r * 0.85), controlPoint2: CGPoint(x: cx + r * 0.75, y: cy - r * 0.2))
                // Bubbles
                addCircle(path, cx - r * 0.2, cy + r * 0.35, r * 0.08)
                addCircle(path, cx + r * 0.18, cy + r * 0.45, r * 0.06)
                addCircle(path, cx, cy + r * 0.15, r * 0.05)
            }

            // ==========================================
            // --- MANDALA & HỌA TIẾT (25 MẪU) ---
            // ==========================================

        case .lotus:
            do {
                let r = s * 0.85
                // Center petal
                path.move(to: CGPoint(x: cx, y: cy + r * 0.55))
                path.addCurve(to: CGPoint(x: cx, y: cy - r * 0.95), controlPoint1: CGPoint(x: cx - r * 0.35, y: cy), controlPoint2: CGPoint(x: cx - r * 0.35, y: cy - r * 0.65))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy - r * 0.65), controlPoint2: CGPoint(x: cx + r * 0.35, y: cy))
                // Left petals
                path.move(to: CGPoint(x: cx, y: cy + r * 0.55))
                path.addCurve(to: CGPoint(x: cx - r * 0.65, y: cy - r * 0.65), controlPoint1: CGPoint(x: cx - r * 0.65, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx - r * 0.85, y: cy - r * 0.35))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx - r * 0.35, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx, y: cy + r * 0.1))
                // Right petals
                path.move(to: CGPoint(x: cx, y: cy + r * 0.55))
                path.addCurve(to: CGPoint(x: cx + r * 0.65, y: cy - r * 0.65), controlPoint1: CGPoint(x: cx + r * 0.65, y: cy + r * 0.2), controlPoint2: CGPoint(x: cx + r * 0.85, y: cy - r * 0.35))
                path.addCurve(to: CGPoint(x: cx, y: cy + r * 0.55), controlPoint1: CGPoint(x: cx + r * 0.35, y: cy - r * 0.2), controlPoint2: CGPoint(x: cx, y: cy + r * 0.1))
                // Base curve
                path.move(to: CGPoint(x: cx - r * 0.55, y: cy + r * 0.55))
                path.addQuadCurve(to: CGPoint(x: cx + r * 0.55, y: cy + r * 0.55), controlPoint: CGPoint(x: cx, y: cy + r * 0.85))
            }

        case .mandalaSun:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r * 0.3)
                addCircle(path, cx, cy, r * 0.48)
                let rays = 12
                for _i in 0..<rays {
                    let i = CGFloat(_i)
                    let a = i * (2 * CGFloat.pi / rays)
                    let x1 = (cx + cos(a) * r * 0.48)
                    let y1 = (cy + sin(a) * r * 0.48)
                    let x2 = (cx + cos(a) * r * 0.95)
                    let y2 = (cy + sin(a) * r * 0.95)
                    path.move(to: CGPoint(x: x1, y: y1)); path.addLine(to: CGPoint(x: x2, y: y2))
                    addStar(path, x2, y2, r * 0.1)
                }
            }

        case .spiderWeb:
            do {
                let maxR = s * 0.95
                let spokes = 8
                for _i in 0..<spokes {
                    let i = CGFloat(_i)
                    let a = i * (2 * CGFloat.pi / spokes)
                    path.move(to: CGPoint(x: cx, y: cy)); path.addLine(to: CGPoint(x: (cx + cos(a) * maxR), y: (cy + sin(a)) * maxR))
                }
                for _ring in 1...4 {
                    let ring = CGFloat(_ring)
                    let curR = maxR * (ring / 4.0)
                    for _i in 0..<spokes {
                        let i = CGFloat(_i)
                        let a1 = i * (2 * CGFloat.pi / spokes)
                        let a2 = (i + 1) * (2 * CGFloat.pi / spokes)
                        let p1x = (cx + cos(a1) * curR)
                        let p1y = (cy + sin(a1) * curR)
                        let p2x = (cx + cos(a2) * curR)
                        let p2y = (cy + sin(a2) * curR)
                        if (i == 0) path.move(to: CGPoint(x: p1x, y: p1y))
                        let midA = (a1 + a2) / 2
                        path.addQuadCurve(to: CGPoint(x: p2x, y: p2y), controlPoint: CGPoint(x: (cx + cos(midA) * (curR * 0.88)), y: (cy + sin(midA) * (curR * 0.88))))
                    }
                }
                path.move(to: CGPoint(x: cx + maxR * 0.5, y: cy + maxR * 0.25)); path.addLine(to: CGPoint(x: cx + maxR * 0.5, y: cy + maxR * 0.65))
                addCircle(path, cx + maxR * 0.5, cy + maxR * 0.65, maxR * 0.08)
            }

        case .mandalaFlower8:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r * 0.2)
                for _i in 0..<8 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 8
                    addPetal(path, cx, cy, r * 0.85, r * 0.35, a)
                }
                addCircle(path, cx, cy, r * 0.85)
            }

        case .mandalaStar12:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r * 0.3)
                addStar(path, cx, cy, r * 0.95, spikes = 12, innerRatio = 0.6)
                addStar(path, cx, cy, r * 0.65, spikes = 12, innerRatio = 0.45)
            }

        case .mandalaRose:
            do {
                let r = s * 0.85
                for _ring in 1...4 {
                    let ring = CGFloat(_ring)
                    let cr = r * (ring / 4.0)
                    let petals = ring * 4
                    for _i in 0..<petals {
                        let i = CGFloat(_i)
                        let a = i * 2 * CGFloat.pi / petals
                        let px = (cx + cos(a) * cr * 0.7)
                        let py = (cy + sin(a) * cr * 0.7)
                        addArc(path, px - cr * 0.4, py - cr * 0.4, px + cr * 0.4, py + cr * 0.4, (a * 180 / CGFloat.pi), 180.0)
                    }
                }
            }

        case .mandalaHeartRing:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.25)
                let count = 8
                for _i in 0..<count {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / count
                    let hx = (cx + cos(a) * r * 0.62)
                    let hy = (cy + sin(a) * r * 0.62)
                    addHeartShape(path, hx, hy, r * 0.25, (a + CGFloat.pi / 2))
                }
            }

        case .mandalaKaleido6:
            do {
                let r = s * 0.88
                for _i in 0..<6 {
                    let i = CGFloat(_i)
                    let a = i * CGFloat.pi / 3
                    path.move(to: CGPoint(x: cx, y: cy))
                    path.addLine(to: CGPoint(x: (cx + cos(a) * r * 0.95), y: (cy + sin(a)) * r * 0.95))
                    let midX = (cx + cos(a) * r * 0.5)
                    let midY = (cy + sin(a) * r * 0.5)
                    addCircle(path, midX, midY, r * 0.18)
                }
                addCircle(path, cx, cy, r * 0.95)
            }

        case .mandalaSunflower:
            do {
                let r = s * 0.88
                // Seed center lattice
                addCircle(path, cx, cy, r * 0.45)
                for _i in 0..<16 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 16
                    addPetal(path, cx, cy, r * 0.92, r * 0.2, a)
                }
            }

        case .mandalaPeacock:
            do {
                let r = s * 0.85
                // Peacock fan array
                for _i in -4...4 {
                    let i = CGFloat(_i)
                    let a = -CGFloat.pi / 2 + i * (CGFloat.pi / 10)
                    let ex = (cx + cos(a) * r * 0.9)
                    let ey = (cy + sin(a) * r * 0.9)
                    path.move(to: CGPoint(x: cx, y: cy + r * 0.35)); path.addLine(to: CGPoint(x: ex, y: ey))
                    addCircle(path, ex, ey, r * 0.12)
                    addCircle(path, ex, ey, r * 0.05)
                }
                // Bird body in front
                addCircle(path, cx, cy + r * 0.4, r * 0.22)
            }

        case .mandalaGeometric:
            do {
                let r = s * 0.88
                // Overlapping squares rotated 45 deg
                addSquare(path, cx, cy, r * 0.88, 0.0)
                addSquare(path, cx, cy, r * 0.88, 45.0)
                addSquare(path, cx, cy, r * 0.55, 0.0)
                addSquare(path, cx, cy, r * 0.55, 45.0)
                addCircle(path, cx, cy, r * 0.25)
            }

        case .mandalaInfinity:
            do {
                let r = s * 0.85
                // Figure 8 infinity loop
                for _t in 0...100 {
                    let t = CGFloat(_t)
                    let a = t * 2 * CGFloat.pi / 100
                    let scale = r * 0.85
                    let denom = 1 + sin(a) * sin(a)
                    let ix = (cx + scale * cos(a) / denom)
                    let iy = (cy + scale * sin(a) * cos(a) / denom)
                    if (t == 0) path.move(to: CGPoint(x: ix, y: iy)) else path.addLine(to: CGPoint(x: ix, y: iy))
                }
                path.close()
                // Starburst around center
                addStar(path, cx, cy, r * 0.22)
            }

        case .mandalaYinYang:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r)
                // S curve
                addArc(path, cx - r * 0.5, cy - r, cx + r * 0.5, cy, 90.0, 180.0)
                addArc(path, cx - r * 0.5, cy, cx + r * 0.5, cy + r, -90.0, 180.0)
                // Small circles
                addCircle(path, cx, cy - r * 0.5, r * 0.15)
                addCircle(path, cx, cy + r * 0.5, r * 0.15)
            }

        case .mandalaCelticKnot:
            do {
                let r = s * 0.85
                // Triquetra (3 overlapping arcs)
                for _i in 0..<3 {
                    let i = CGFloat(_i)
                    let a = -CGFloat.pi / 2 + i * 2 * CGFloat.pi / 3
                    let ax = (cx + cos(a) * r * 0.35)
                    let ay = (cy + sin(a) * r * 0.35)
                    addCircle(path, ax, ay, r * 0.52)
                }
                addCircle(path, cx, cy, r * 0.48)
            }

        case .mandalaChakra:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r * 0.3)
                for _i in 0..<16 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 16
                    addPetal(path, cx, cy, r * 0.88, r * 0.18, a)
                }
                addCircle(path, cx, cy, r * 0.9)
            }

        case .mandalaLeafWreath:
            do {
                let r = s * 0.85
                addCircle(path, cx, cy, r * 0.65)
                let leaves = 12
                for _i in 0..<leaves {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / leaves
                    let lx = (cx + cos(a) * r * 0.65)
                    let ly = (cy + sin(a) * r * 0.65)
                    addLeaf(path, lx, ly, (lx + cos(a + 0.4) * r * 0.25), (ly + sin(a + 0.4) * r * 0.25), r * 0.12)
                }
            }

        case .mandalaWave:
            do {
                let r = s * 0.88
                for _ring in 1...3 {
                    let ring = CGFloat(_ring)
                    let cr = r * (ring / 3.0)
                    let waves = ring * 6
                    for _i in 0..<waves {
                        let i = CGFloat(_i)
                        let a1 = i * 2 * CGFloat.pi / waves
                        let a2 = (i + 1) * 2 * CGFloat.pi / waves
                        let p1x = (cx + cos(a1) * cr)
                        let p1y = (cy + sin(a1) * cr)
                        let p2x = (cx + cos(a2) * cr)
                        let p2y = (cy + sin(a2) * cr)
                        if (i == 0) path.move(to: CGPoint(x: p1x, y: p1y))
                        path.addQuadCurve(to: CGPoint(x: p2x, y: p2y), controlPoint: CGPoint(x: (p1x + p2x) / 2 + cr * 0.1, y: (p1y + p2y) / 2 - cr * 0.1))
                    }
                }
            }

        case .mandalaHexagon:
            do {
                let r = s * 0.88
                addPolygon(path, cx, cy, r * 0.92, 6)
                addPolygon(path, cx, cy, r * 0.68, 6)
                addPolygon(path, cx, cy, r * 0.44, 6)
                addPolygon(path, cx, cy, r * 0.2, 6)
                for _i in 0..<6 {
                    let i = CGFloat(_i)
                    let a = i * CGFloat.pi / 3
                    path.move(to: CGPoint(x: cx, y: cy)); path.addLine(to: CGPoint(x: (cx + cos(a) * r * 0.92), y: (cy + sin(a)) * r * 0.92))
                }
            }

        case .mandalaStarOfDavid:
            do {
                let r = s * 0.88
                // 2 Equilateral triangles rotated 60 deg
                addPolygon(path, cx, cy, r * 0.9, 3, -CGFloat.pi / 2)
                addPolygon(path, cx, cy, r * 0.9, 3, CGFloat.pi / 2)
                addCircle(path, cx, cy, r * 0.92)
                addCircle(path, cx, cy, r * 0.52)
            }

        case .mandalaDiamondGrid:
            do {
                let r = s * 0.88
                for _i in -3...3 {
                    let i = CGFloat(_i)
                    let offset = i * r * 0.28
                    path.move(to: CGPoint(x: cx + offset, y: cy - r * 0.85)); path.addLine(to: CGPoint(x: cx + offset, y: cy + r * 0.85))
                    path.move(to: CGPoint(x: cx - r * 0.85, y: cy + offset)); path.addLine(to: CGPoint(x: cx + r * 0.85, y: cy + offset))
                }
                addCircle(path, cx, cy, r * 0.92)
            }

        case .mandalaSpiralShell:
            do {
                let r = s * 0.88
                for _i in 1...80 {
                    let i = CGFloat(_i)
                    let a = i * 0.18
                    let rad = r * (i / 80.0) * 0.95
                    let nx = (cx + cos(a) * rad)
                    let ny = (cy + sin(a) * rad)
                    if (i == 1) path.move(to: CGPoint(x: nx, y: ny)) else path.addLine(to: CGPoint(x: nx, y: ny))
                }
                addCircle(path, cx, cy, r * 0.95)
            }

        case .mandalaButterflyWing:
            do {
                let r = s * 0.88
                for _i in 0..<4 {
                    let i = CGFloat(_i)
                    let a = i * CGFloat.pi / 2 + CGFloat.pi / 4
                    let wx = (cx + cos(a) * r * 0.55)
                    let wy = (cy + sin(a) * r * 0.55)
                    addPetal(path, cx, cy, r * 0.9, r * 0.35, a)
                    addCircle(path, wx, wy, r * 0.15)
                }
                addCircle(path, cx, cy, r * 0.3)
            }

        case .mandalaSunBurst:
            do {
                let r = s * 0.88
                addCircle(path, cx, cy, r * 0.35)
                for _i in 0..<24 {
                    let i = CGFloat(_i)
                    let a = i * 2 * CGFloat.pi / 24
                    let len = if (i % 2 == 0) r * 0.95 else r * 0.65
                    path.move(to: CGPoint(x: (cx + cos(a) * r * 0.35), y: (cy + sin(a)) * r * 0.35))
                    path.addLine(to: CGPoint(x: (cx + cos(a) * len), y: (cy + sin(a)) * len))
                }
            }

        case .mandalaFlowerOfLife:
            do {
                let r = s * 0.85
                let cr = r * 0.45
                // Center circle
                addCircle(path, cx, cy, cr)
                // 6 Surrounding intersecting circles
                for _i in 0..<6 {
                    let i = CGFloat(_i)
                    let a = i * CGFloat.pi / 3
                    addCircle(path, (cx + cos(a) * cr), (cy + sin(a) * cr), cr)
                }
                addCircle(path, cx, cy, r * 0.92)
            }

        case .mandalaZenCircle:
            do {
                let r = s * 0.85
                // Open Zen Enso calligraphic circle
                addArc(path, cx - r * 0.85, cy - r * 0.85, cx + r * 0.85, cy + r * 0.85, 25.0, 320.0)
                addArc(path, cx - r * 0.7, cy - r * 0.7, cx + r * 0.7, cy + r * 0.7, 35.0, 300.0)
                // Small serene dot
                addCircle(path, cx, cy, r * 0.08)
            }
        }

        return path
    }

    private static func addCircle(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat) {
        path.append(UIBezierPath(ovalIn: CGRect(x: cx - radius, y: cy - radius, width: radius * 2, height: radius * 2)))
    }

    private static func addRect(_ path: UIBezierPath, _ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        path.append(UIBezierPath(rect: CGRect(x: left, y: top, width: right - left, height: bottom - top)))
    }

    private static func addStar(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat, _ spikes: Int = 5, _ innerRatio: CGFloat = 0.45) {
        let rot = CGFloat.pi / 2.0 * 3.0
        let step = CGFloat.pi / CGFloat(spikes)
        let innerRadius = radius * innerRatio
        path.move(to: CGPoint(x: cx, y: cy - radius))
        for i in 0..<spikes {
            let x1 = cx + cos(rot + CGFloat(i * 2) * step) * radius
            let y1 = cy + sin(rot + CGFloat(i * 2) * step) * radius
            path.addLine(to: CGPoint(x: x1, y: y1))
            let x2 = cx + cos(rot + CGFloat(i * 2 + 1) * step) * innerRadius
            let y2 = cy + sin(rot + CGFloat(i * 2 + 1) * step) * innerRadius
            path.addLine(to: CGPoint(x: x2, y: y2))
        }
        path.close()
    }

    private static func addCloud(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat) {
        addCircle(path, cx - radius * 0.5, cy, radius * 0.6)
        addCircle(path, cx, cy - radius * 0.35, radius * 0.75)
        addCircle(path, cx + radius * 0.5, cy, radius * 0.6)
    }

    private static func addOval(_ path: UIBezierPath, _ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat) {
        path.append(UIBezierPath(ovalIn: CGRect(x: left, y: top, width: right - left, height: bottom - top)))
    }

    private static func addArc(_ path: UIBezierPath, _ left: CGFloat, _ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat, _ startAngleDeg: CGFloat, _ sweepAngleDeg: CGFloat) {
        let rect = CGRect(x: left, y: top, width: right - left, height: bottom - top)
        let cx = rect.midX
        let cy = rect.midY
        let rx = rect.width / 2.0
        let ry = rect.height / 2.0
        if rx <= 0 || ry <= 0 { return }

        let startRad = startAngleDeg * .pi / 180.0
        let sweepRad = sweepAngleDeg * .pi / 180.0
        let endRad = startRad + sweepRad
        let clockwise = sweepAngleDeg >= 0

        let transform = CGAffineTransform(translationX: cx, y: cy).scaledBy(x: rx, y: ry)
        let arcPath = CGMutablePath()
        arcPath.addArc(center: .zero, radius: 1.0, startAngle: startRad, endAngle: endRad, clockwise: !clockwise, transform: transform)
        path.append(UIBezierPath(cgPath: arcPath))
    }

    private static func addLeaf(_ path: UIBezierPath, _ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ bend: CGFloat) {
        let mx = (x1 + x2) / 2
        let my = (y1 + y2) / 2
        let dx = x2 - x1
        let dy = y2 - y1
        let len = max(sqrt(dx * dx + dy * dy), 1.0)
        let nx = -dy / len * bend
        let ny = dx / len * bend
        path.move(to: CGPoint(x: x1, y: y1))
        path.addQuadCurve(to: CGPoint(x: x2, y: y2), controlPoint: CGPoint(x: mx + nx, y: my + ny))
        path.addQuadCurve(to: CGPoint(x: x1, y: y1), controlPoint: CGPoint(x: mx - nx, y: my - ny))
    }

    private static func addPetal(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ length: CGFloat, _ width: CGFloat, _ angle: Double) {
        let cAngle = CGFloat(angle)
        let tipX = cx + cos(cAngle) * length
        let tipY = cy + sin(cAngle) * length
        let midR = length * 0.5
        let perpAngle = cAngle + CGFloat.pi / 2.0
        let p1x = cx + cos(cAngle) * midR + cos(perpAngle) * width * 0.5
        let p1y = cy + sin(cAngle) * midR + sin(perpAngle) * width * 0.5
        let p2x = cx + cos(cAngle) * midR - cos(perpAngle) * width * 0.5
        let p2y = cy + sin(cAngle) * midR - sin(perpAngle) * width * 0.5
        path.move(to: CGPoint(x: cx, y: cy))
        path.addQuadCurve(to: CGPoint(x: tipX, y: tipY), controlPoint: CGPoint(x: p1x, y: p1y))
        path.addQuadCurve(to: CGPoint(x: cx, y: cy), controlPoint: CGPoint(x: p2x, y: p2y))
    }

    private static func addPolygon(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat, _ sides: Int, _ startAngle: Double = -Double.pi / 2.0) {
        let step = 2.0 * CGFloat.pi / CGFloat(sides)
        let cStart = CGFloat(startAngle)
        for i in 0..<sides {
            let a = cStart + CGFloat(i) * step
            let px = cx + cos(a) * radius
            let py = cy + sin(a) * radius
            if i == 0 {
                path.move(to: CGPoint(x: px, y: py))
            } else {
                path.addLine(to: CGPoint(x: px, y: py))
            }
        }
        path.close()
    }

    private static func addSquare(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ size: CGFloat, _ rotDegrees: CGFloat) {
        let half = size / 2.0
        let rad = rotDegrees * .pi / 180.0
        let cosA = cos(rad)
        let sinA = sin(rad)
        let pts: [(CGFloat, CGFloat)] = [
            (-half, -half),
            (half, -half),
            (half, half),
            (-half, half)
        ]
        for (i, pt) in pts.enumerated() {
            let rx = cx + pt.0 * cosA - pt.1 * sinA
            let ry = cy + pt.0 * sinA + pt.1 * cosA
            if i == 0 {
                path.move(to: CGPoint(x: rx, y: ry))
            } else {
                path.addLine(to: CGPoint(x: rx, y: ry))
            }
        }
        path.close()
    }

    private static func addHeartShape(_ path: UIBezierPath, _ cx: CGFloat, _ cy: CGFloat, _ radius: CGFloat, _ rotRad: CGFloat = 0) {
        let r = radius * 0.6
        var pts: [CGPoint] = []
        for i in 0...30 {
            let t = CGFloat(i) * 2.0 * .pi / 30.0
            let hx = (16.0 * pow(sin(t), 3.0)) / 16.0 * r
            let hy = -(13.0 * cos(t) - 5.0 * cos(2.0 * t) - 2.0 * cos(3.0 * t) - cos(4.0 * t)) / 16.0 * r
            let rx = cx + hx * cos(rotRad) - hy * sin(rotRad)
            let ry = cy + hx * sin(rotRad) + hy * cos(rotRad)
            pts.append(CGPoint(x: rx, y: ry))
        }
        for (idx, pt) in pts.enumerated() {
            if idx == 0 {
                path.move(to: pt)
            } else {
                path.addLine(to: pt)
            }
        }
        path.close()
    }
}
