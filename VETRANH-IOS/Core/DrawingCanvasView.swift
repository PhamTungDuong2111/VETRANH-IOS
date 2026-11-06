//
//  DrawingCanvasView.swift
//  VETRANH-IOS
//

import UIKit
import SwiftUI

public final class DrawingCanvasUIView: UIView {

    public var onHistoryChanged: ((_ canUndo: Bool, _ canRedo: Bool) -> Void)?

    private var strokes: [Stroke] = []
    private var undoneStrokes: [Stroke] = []

    private var currentPoints: [CGPoint] = []
    private var currentColor: UIColor = .neonCyan
    private var currentStrokeWidth: CGFloat = 24.0
    private var currentBrushType: BrushType = .neon
    private var currentSymmetryMode: SymmetryMode = .none
    private var isRainbowMode: Bool = false

    private var currentStencil: StencilType = .none
    private var isStencilGuideVisible: Bool = true

    private var backgroundPhoto: UIImage? = nil
    private var offscreenBuffer: UIImage? = nil

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .black
        isMultipleTouchEnabled = false
        isUserInteractionEnabled = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width > 0 && bounds.height > 0 {
            rebuildOffscreenBuffer()
        }
    }

    // MARK: - Public Controls

    public func setBrushColor(_ color: UIColor) {
        self.currentColor = color
        self.isRainbowMode = false
    }

    public func getBrushColor() -> UIColor {
        return currentColor
    }

    public func setBrushWidth(_ width: CGFloat) {
        self.currentStrokeWidth = max(8.0, min(width, 100.0))
    }

    public func getBrushWidth() -> CGFloat {
        return currentStrokeWidth
    }

    public func setBrushType(_ type: BrushType) {
        self.currentBrushType = type
        if type == .rainbow {
            self.isRainbowMode = true
        } else {
            self.isRainbowMode = false
        }
    }

    public func getBrushType() -> BrushType {
        return currentBrushType
    }

    public func setSymmetryMode(_ mode: SymmetryMode) {
        self.currentSymmetryMode = mode
    }

    public func getSymmetryMode() -> SymmetryMode {
        return currentSymmetryMode
    }

    public func setStencil(_ stencil: StencilType) {
        self.currentStencil = stencil
        self.isStencilGuideVisible = (stencil != .none)
        setNeedsDisplay()
    }

    public func getStencil() -> StencilType {
        return currentStencil
    }

    public func toggleStencilGuideVisibility() -> Bool {
        isStencilGuideVisible.toggle()
        setNeedsDisplay()
        return isStencilGuideVisible
    }

    public func isStencilVisible() -> Bool {
        return isStencilGuideVisible
    }

    public func setBackgroundPhoto(_ image: UIImage?) {
        self.backgroundPhoto = image
        rebuildOffscreenBuffer()
        setNeedsDisplay()
    }

    public func hasBackgroundPhoto() -> Bool {
        return backgroundPhoto != nil
    }

    public func canUndo() -> Bool {
        return !strokes.isEmpty
    }

    public func canRedo() -> Bool {
        return !undoneStrokes.isEmpty
    }

    public func undo() {
        guard !strokes.isEmpty else { return }
        let last = strokes.removeLast()
        undoneStrokes.append(last)
        rebuildOffscreenBuffer()
        setNeedsDisplay()
        notifyHistory()
    }

    public func redo() {
        guard !undoneStrokes.isEmpty else { return }
        let restored = undoneStrokes.removeLast()
        strokes.append(restored)
        rebuildOffscreenBuffer()
        setNeedsDisplay()
        notifyHistory()
    }

    public func clear() {
        strokes.removeAll()
        undoneStrokes.removeAll()
        currentPoints.removeAll()
        backgroundPhoto = nil
        offscreenBuffer = nil
        rebuildOffscreenBuffer()
        setNeedsDisplay()
        notifyHistory()
    }

    private func notifyHistory() {
        onHistoryChanged?(canUndo(), canRedo())
    }

    // MARK: - Touch Handling

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let pt = touch.location(in: self)
        currentPoints = [pt]
        setNeedsDisplay()
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let pt = touch.location(in: self)
        currentPoints.append(pt)
        setNeedsDisplay()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let pt = touch.location(in: self)
        currentPoints.append(pt)

        if currentPoints.count >= 2 {
            let completedStroke = Stroke(
                points: currentPoints,
                color: currentColor,
                strokeWidth: currentStrokeWidth,
                brushType: currentBrushType,
                symmetryMode: currentSymmetryMode,
                isRainbow: isRainbowMode
            )
            strokes.append(completedStroke)
            undoneStrokes.removeAll()

            // Draw incrementally into offscreen buffer
            drawStrokeIntoBuffer(completedStroke)
            notifyHistory()
        }

        currentPoints.removeAll()
        setNeedsDisplay()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoints.removeAll()
        setNeedsDisplay()
    }

    // MARK: - Offscreen Buffer

    private func rebuildOffscreenBuffer() {
        guard bounds.width > 0, bounds.height > 0 else { return }
        let size = bounds.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        offscreenBuffer = renderer.image { ctx in
            let cg = ctx.cgContext

            // 1. Black background
            cg.setFillColor(UIColor.black.cgColor)
            cg.fill(CGRect(origin: .zero, size: size))

            // 2. User background photo if present
            if let photo = backgroundPhoto {
                drawAspectFit(image: photo, in: CGRect(origin: .zero, size: size), context: cg)
            }

            // 3. Render all committed strokes
            for stroke in strokes {
                drawStroke(stroke, in: cg, canvasSize: size)
            }
        }
    }

    private func drawStrokeIntoBuffer(_ stroke: Stroke) {
        guard bounds.width > 0, bounds.height > 0 else { return }
        let size = bounds.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        offscreenBuffer = renderer.image { ctx in
            let cg = ctx.cgContext
            if let existing = offscreenBuffer {
                existing.draw(in: CGRect(origin: .zero, size: size))
            } else {
                cg.setFillColor(UIColor.black.cgColor)
                cg.fill(CGRect(origin: .zero, size: size))
                if let photo = backgroundPhoto {
                    drawAspectFit(image: photo, in: CGRect(origin: .zero, size: size), context: cg)
                }
            }
            drawStroke(stroke, in: cg, canvasSize: size)
        }
    }

    // MARK: - Main Draw

    public override func draw(_ rect: CGRect) {
        guard let cg = UIGraphicsGetCurrentContext() else { return }
        let size = bounds.size

        // 1. Draw cached buffer
        if let buffer = offscreenBuffer {
            buffer.draw(in: bounds)
        } else {
            cg.setFillColor(UIColor.black.cgColor)
            cg.fill(bounds)
            if let photo = backgroundPhoto {
                drawAspectFit(image: photo, in: bounds, context: cg)
            }
        }

        // 2. Draw currently in-progress active stroke
        if currentPoints.count >= 2 {
            let activeStroke = Stroke(
                points: currentPoints,
                color: currentColor,
                strokeWidth: currentStrokeWidth,
                brushType: currentBrushType,
                symmetryMode: currentSymmetryMode,
                isRainbow: isRainbowMode
            )
            drawStroke(activeStroke, in: cg, canvasSize: size)
        }

        // 3. Draw stencil guide lines
        if currentStencil != .none && isStencilGuideVisible {
            drawStencilGuide(in: cg, canvasSize: size)
        }
    }

    // MARK: - Stroke Drawing Engine

    private func drawStroke(_ stroke: Stroke, in cg: CGContext, canvasSize: CGSize) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }

        let cx = canvasSize.width / 2.0
        let cy = canvasSize.height / 2.0
        let symCount = stroke.symmetryMode.count

        for i in 0..<symCount {
            cg.saveGState()

            switch stroke.symmetryMode {
            case .none:
                break
            case .mirror2:
                if i == 1 {
                    cg.translateBy(x: canvasSize.width, y: 0)
                    cg.scaleBy(x: -1.0, y: 1.0)
                }
            case .mirror4:
                let angle = CGFloat(i) * (.pi / 2.0)
                cg.translateBy(x: cx, y: cy)
                cg.rotate(by: angle)
                if i % 2 == 1 {
                    cg.scaleBy(x: 1.0, y: -1.0)
                }
                cg.translateBy(x: -cx, y: -cy)
            case .kaleidoscope8:
                let angle = CGFloat(i) * (.pi / 4.0)
                cg.translateBy(x: cx, y: cy)
                cg.rotate(by: angle)
                if i % 2 == 1 {
                    cg.scaleBy(x: 1.0, y: -1.0)
                }
                cg.translateBy(x: -cx, y: -cy)
            }

            renderStrokeBrush(stroke, in: cg)
            cg.restoreGState()
        }
    }

    private func renderStrokeBrush(_ stroke: Stroke, in cg: CGContext) {
        switch stroke.brushType {
        case .neon:
            drawNeonPath(stroke, in: cg)
        case .rainbow:
            drawRainbowPath(stroke, in: cg)
        case .stars:
            drawStarPath(stroke, in: cg)
        case .beads:
            drawBeadsPath(stroke, in: cg)
        case .ribbon:
            drawRibbonPath(stroke, in: cg)
        case .fireworks:
            drawFireworksPath(stroke, in: cg)
        }
    }

    // 1. Neon Brush: Smooth bezier curve with wide outer glow + mid glow + white core
    private func drawNeonPath(_ stroke: Stroke, in cg: CGContext) {
        let bezier = createSmoothedBezierPath(stroke.points)
        let cgPath = bezier.cgPath

        cg.setLineCap(.round)
        cg.setLineJoin(.round)

        // Outer Glow
        cg.saveGState()
        cg.setShadow(offset: .zero, blur: stroke.strokeWidth * 0.9, color: stroke.color.withAlphaComponent(0.65).cgColor)
        cg.setStrokeColor(stroke.color.withAlphaComponent(0.6).cgColor)
        cg.setLineWidth(stroke.strokeWidth * 1.8)
        cg.addPath(cgPath)
        cg.strokePath()
        cg.restoreGState()

        // Mid Glow
        cg.saveGState()
        cg.setShadow(offset: .zero, blur: stroke.strokeWidth * 0.35, color: stroke.color.cgColor)
        cg.setStrokeColor(stroke.color.cgColor)
        cg.setLineWidth(stroke.strokeWidth)
        cg.addPath(cgPath)
        cg.strokePath()
        cg.restoreGState()

        // Crisp White Core
        cg.saveGState()
        cg.setStrokeColor(UIColor.white.cgColor)
        cg.setLineWidth(max(stroke.strokeWidth * 0.35, 3.0))
        cg.addPath(cgPath)
        cg.strokePath()
        cg.restoreGState()
    }

    // 2. Rainbow Brush: Hue cycling across segments with outer glow & white core
    private func drawRainbowPath(_ stroke: Stroke, in cg: CGContext) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }

        cg.setLineCap(.round)
        cg.setLineJoin(.round)

        for i in 0..<(pts.count - 1) {
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let hue = CGFloat((Double(i) * 12.0).truncatingRemainder(dividingBy: 360.0) / 360.0)
            let segColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)

            // Outer glow line
            cg.saveGState()
            cg.setShadow(offset: .zero, blur: stroke.strokeWidth * 0.7, color: segColor.withAlphaComponent(0.7).cgColor)
            cg.setStrokeColor(segColor.withAlphaComponent(0.7).cgColor)
            cg.setLineWidth(stroke.strokeWidth * 1.5)
            cg.move(to: p1)
            cg.addLine(to: p2)
            cg.strokePath()
            cg.restoreGState()

            // Main line
            cg.saveGState()
            cg.setStrokeColor(segColor.cgColor)
            cg.setLineWidth(stroke.strokeWidth)
            cg.move(to: p1)
            cg.addLine(to: p2)
            cg.strokePath()
            cg.restoreGState()

            // White core line
            cg.saveGState()
            cg.setStrokeColor(UIColor.white.cgColor)
            cg.setLineWidth(max(stroke.strokeWidth * 0.3, 2.0))
            cg.move(to: p1)
            cg.addLine(to: p2)
            cg.strokePath()
            cg.restoreGState()
        }
    }

    // 3. Stars Brush: 5-pointed glowing stars along the stroke
    private func drawStarPath(_ stroke: Stroke, in cg: CGContext) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }
        let step = max(stroke.strokeWidth * 1.5, 20.0)
        var distAccum: CGFloat = 0.0

        for i in 0..<(pts.count - 1) {
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let d = hypot(p2.x - p1.x, p2.y - p1.y)
            distAccum += d
            if distAccum >= step || i == 0 {
                distAccum = 0.0
                let col: UIColor
                if stroke.isRainbow {
                    let hue = CGFloat((Double(i) * 18.0).truncatingRemainder(dividingBy: 360.0) / 360.0)
                    col = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                } else {
                    col = stroke.color
                }
                drawGlowStar(in: cg, cx: p2.x, cy: p2.y, radius: stroke.strokeWidth * 0.9, color: col)
            }
        }
    }

    private func drawGlowStar(in cg: CGContext, cx: CGFloat, cy: CGFloat, radius: CGFloat, color: UIColor) {
        let starPath = UIBezierPath()
        let spikes = 5
        let rot = CGFloat.pi / 2.0 * 3.0
        let step = CGFloat.pi / CGFloat(spikes)
        let innerRadius = radius * 0.45

        starPath.move(to: CGPoint(x: cx, y: cy - radius))
        for i in 0..<spikes {
            let a1 = rot + CGFloat(i * 2) * step
            starPath.addLine(to: CGPoint(x: cx + cos(a1) * radius, y: cy + sin(a1) * radius))
            let a2 = rot + CGFloat(i * 2 + 1) * step
            starPath.addLine(to: CGPoint(x: cx + cos(a2) * innerRadius, y: cy + sin(a2) * innerRadius))
        }
        starPath.close()

        // Outer Glow
        cg.saveGState()
        cg.setShadow(offset: .zero, blur: radius * 0.6, color: color.cgColor)
        cg.setFillColor(color.cgColor)
        cg.addPath(starPath.cgPath)
        cg.fillPath()
        cg.restoreGState()

        // Crisp White Core
        cg.saveGState()
        cg.setFillColor(UIColor.white.cgColor)
        cg.addPath(starPath.cgPath)
        cg.fillPath()
        cg.restoreGState()
    }

    // 4. Beads Brush: Glowing pearls with white glossy highlight dot
    private func drawBeadsPath(_ stroke: Stroke, in cg: CGContext) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }
        let step = max(stroke.strokeWidth * 1.1, 15.0)
        var distAccum: CGFloat = 0.0

        for i in 0..<(pts.count - 1) {
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let d = hypot(p2.x - p1.x, p2.y - p1.y)
            distAccum += d
            if distAccum >= step || i == 0 {
                distAccum = 0.0
                let col: UIColor
                if stroke.isRainbow {
                    let hue = CGFloat((Double(i) * 15.0).truncatingRemainder(dividingBy: 360.0) / 360.0)
                    col = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                } else {
                    col = stroke.color
                }
                let r = stroke.strokeWidth * 0.5

                // Glow circle
                cg.saveGState()
                cg.setShadow(offset: .zero, blur: r * 0.8, color: col.cgColor)
                cg.setFillColor(col.cgColor)
                cg.fillEllipse(in: CGRect(x: p2.x - r * 1.3, y: p2.y - r * 1.3, width: r * 2.6, height: r * 2.6))
                cg.restoreGState()

                // Base bead circle
                cg.saveGState()
                cg.setFillColor(col.cgColor)
                cg.fillEllipse(in: CGRect(x: p2.x - r, y: p2.y - r, width: r * 2.0, height: r * 2.0))
                cg.restoreGState()

                // Shiny white offset highlight dot
                cg.saveGState()
                cg.setFillColor(UIColor.white.cgColor)
                let dotR = r * 0.35
                cg.fillEllipse(in: CGRect(x: p2.x - r * 0.25 - dotR / 2, y: p2.y - r * 0.25 - dotR / 2, width: dotR, height: dotR))
                cg.restoreGState()
            }
        }
    }

    // 5. Ribbon Brush: Parallel dual ribbons on both sides of touch path
    private func drawRibbonPath(_ stroke: Stroke, in cg: CGContext) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }

        let offset = stroke.strokeWidth * 0.5
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()

        for i in 0..<(pts.count - 1) {
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let angle = atan2(p2.y - p1.y, p2.x - p1.x) + .pi / 2.0
            let ox = cos(angle) * offset
            let oy = sin(angle) * offset

            if i == 0 {
                path1.move(to: CGPoint(x: p1.x + ox, y: p1.y + oy))
                path2.move(to: CGPoint(x: p1.x - ox, y: p1.y - oy))
            }
            path1.addLine(to: CGPoint(x: p2.x + ox, y: p2.y + oy))
            path2.addLine(to: CGPoint(x: p2.x - ox, y: p2.y - oy))
        }

        let ribbonWidth = max(stroke.strokeWidth * 0.4, 4.0)

        // Glow lines
        cg.saveGState()
        cg.setShadow(offset: .zero, blur: ribbonWidth, color: stroke.color.cgColor)
        cg.setStrokeColor(stroke.color.cgColor)
        cg.setLineWidth(ribbonWidth * 2.0)
        cg.addPath(path1.cgPath)
        cg.addPath(path2.cgPath)
        cg.strokePath()
        cg.restoreGState()

        // Core lines
        cg.saveGState()
        cg.setStrokeColor(UIColor.white.cgColor)
        cg.setLineWidth(ribbonWidth * 0.5)
        cg.addPath(path1.cgPath)
        cg.addPath(path2.cgPath)
        cg.strokePath()
        cg.restoreGState()
    }

    // 6. Fireworks Brush: 8 radial sparks shooting outward + center star dot
    private func drawFireworksPath(_ stroke: Stroke, in cg: CGContext) {
        let pts = stroke.points
        guard pts.count >= 2 else { return }
        let step = max(stroke.strokeWidth * 1.8, 25.0)
        var distAccum: CGFloat = 0.0

        for i in 0..<(pts.count - 1) {
            let p1 = pts[i]
            let p2 = pts[i + 1]
            let d = hypot(p2.x - p1.x, p2.y - p1.y)
            distAccum += d
            if distAccum >= step || i == 0 {
                distAccum = 0.0
                let col: UIColor
                if stroke.isRainbow {
                    let hue = CGFloat((Double(i) * 20.0).truncatingRemainder(dividingBy: 360.0) / 360.0)
                    col = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
                } else {
                    col = stroke.color
                }

                let sparks = 8
                let sparkRadius = stroke.strokeWidth * 1.4

                cg.saveGState()
                cg.setShadow(offset: .zero, blur: 4.0, color: col.cgColor)
                cg.setStrokeColor(col.cgColor)
                cg.setLineWidth(3.0)
                cg.setLineCap(.round)

                for s in 0..<spikes(sparks) {
                    let a = CGFloat(s) * (2.0 * .pi / CGFloat(sparks))
                    let sx = p2.x + cos(a) * sparkRadius
                    let sy = p2.y + sin(a) * sparkRadius
                    cg.move(to: p2)
                    cg.addLine(to: CGPoint(x: sx, y: sy))
                }
                cg.strokePath()
                cg.restoreGState()

                // Center white shiny circle
                cg.saveGState()
                cg.setFillColor(UIColor.white.cgColor)
                let dotR = stroke.strokeWidth * 0.35
                cg.fillEllipse(in: CGRect(x: p2.x - dotR, y: p2.y - dotR, width: dotR * 2.0, height: dotR * 2.0))
                cg.restoreGState()
            }
        }
    }

    private func spikes(_ count: Int) -> Int { count }

    // MARK: - Smoothed Bezier Path

    private func createSmoothedBezierPath(_ points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        guard !points.isEmpty else { return path }
        path.move(to: points[0])
        for i in 1..<points.count {
            let prev = points[i - 1]
            let curr = points[i]
            let mid = CGPoint(x: (prev.x + curr.x) / 2.0, y: (prev.y + curr.y) / 2.0)
            path.addQuadCurve(to: mid, controlPoint: prev)
        }
        if points.count > 1 {
            path.addLine(to: points.last!)
        }
        return path
    }

    // MARK: - Stencil Guideline Overlay

    private func drawStencilGuide(in cg: CGContext, canvasSize: CGSize) {
        guard currentStencil != .none, isStencilGuideVisible else { return }

        let padW = canvasSize.width * 0.10
        let padH = canvasSize.height * 0.16
        let bounds = CGRect(
            x: padW,
            y: padH,
            width: canvasSize.width - padW * 2.0,
            height: canvasSize.height - padH * 2.0
        )

        let bezier = TemplateShapes.createPath(type: currentStencil, bounds: bounds)
        let glowColor = currentStencil.glowUIColor

        // Outer glow guideline
        cg.saveGState()
        cg.setShadow(offset: .zero, blur: 6.0, color: glowColor.withAlphaComponent(0.8).cgColor)
        cg.setStrokeColor(glowColor.withAlphaComponent(0.7).cgColor)
        cg.setLineWidth(4.5)
        cg.setLineCap(.round)
        cg.setLineJoin(.round)
        cg.addPath(bezier.cgPath)
        cg.strokePath()
        cg.restoreGState()

        // Crisp white core guideline
        cg.saveGState()
        cg.setStrokeColor(UIColor.white.withAlphaComponent(0.95).cgColor)
        cg.setLineWidth(2.0)
        cg.setLineCap(.round)
        cg.setLineJoin(.round)
        cg.addPath(bezier.cgPath)
        cg.strokePath()
        cg.restoreGState()
    }

    private func drawAspectFit(image: UIImage, in rect: CGRect, context: CGContext) {
        let imgSize = image.size
        guard imgSize.width > 0, imgSize.height > 0 else { return }
        let hRatio = rect.width / imgSize.width
        let vRatio = rect.height / imgSize.height
        let ratio = max(hRatio, vRatio) // Fill canvas aspect
        let newWidth = imgSize.width * ratio
        let newHeight = imgSize.height * ratio
        let originX = rect.midX - newWidth / 2.0
        let originY = rect.midY - newHeight / 2.0
        let targetRect = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
        image.draw(in: targetRect)
    }

    // MARK: - Export

    public func exportBitmap() -> UIImage {
        let size = bounds.size.width > 0 ? bounds.size : CGSize(width: 1080, height: 1920)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 2.0
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            let cg = ctx.cgContext

            // 1. Black background
            cg.setFillColor(UIColor.black.cgColor)
            cg.fill(CGRect(origin: .zero, size: size))

            // 2. Photo background if any
            if let photo = backgroundPhoto {
                drawAspectFit(image: photo, in: CGRect(origin: .zero, size: size), context: cg)
            }

            // 3. Render all strokes (NO stencil guide lines, artwork is clean)
            for stroke in strokes {
                drawStroke(stroke, in: cg, canvasSize: size)
            }
        }
    }
}

// MARK: - SwiftUI Representable Wrapper

public struct DrawingCanvasRepresentable: UIViewRepresentable {
    @Binding public var canvasView: DrawingCanvasUIView
    public var onHistoryChanged: ((_ canUndo: Bool, _ canRedo: Bool) -> Void)?

    public func makeUIView(context: Context) -> DrawingCanvasUIView {
        canvasView.onHistoryChanged = onHistoryChanged
        return canvasView
    }

    public func updateUIView(_ uiView: DrawingCanvasUIView, context: Context) {
        uiView.onHistoryChanged = onHistoryChanged
    }
}
