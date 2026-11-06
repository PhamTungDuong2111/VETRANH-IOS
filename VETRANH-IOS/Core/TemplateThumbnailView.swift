//
//  TemplateThumbnailView.swift
//  VETRANH-IOS
//

import SwiftUI
import UIKit

public struct TemplateThumbnailView: View {
    public let stencil: StencilType
    public let glowColor: Color
    public var size: CGFloat = 68

    public init(stencil: StencilType, glowColor: Color? = nil, size: CGFloat = 68) {
        self.stencil = stencil
        self.glowColor = glowColor ?? stencil.glowColor
        self.size = size
    }

    public var body: some View {
        Canvas { context, canvasSize in
            guard stencil != .none else { return }
            let pad = canvasSize.width * 0.12
            let bounds = CGRect(
                x: pad,
                y: pad,
                width: canvasSize.width - pad * 2,
                height: canvasSize.height - pad * 2
            )
            let bezier = TemplateShapes.createPath(type: stencil, bounds: bounds)
            let path = Path(bezier.cgPath)

            // Outer wide glow
            context.drawLayer { ctx in
                ctx.addFilter(.blur(radius: 3.5))
                ctx.stroke(
                    path,
                    with: .color(glowColor.opacity(0.85)),
                    style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                )
            }

            // Crisp inner white core line
            context.stroke(
                path,
                with: .color(.white),
                style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round)
            )
        }
        .frame(width: size, height: size)
    }
}

