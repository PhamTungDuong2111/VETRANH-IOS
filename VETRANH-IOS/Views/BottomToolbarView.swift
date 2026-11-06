//
//  BottomToolbarView.swift
//  VETRANH-IOS
//

import SwiftUI

public struct BottomToolbarView: View {
    @ObservedObject var loc = LocalizationManager.shared

    @Binding public var currentBrushType: BrushType
    @Binding public var currentBrushWidth: CGFloat
    @Binding public var currentColorIndex: Int

    public let onClearTapped: () -> Void

    private let colors = Color.neonPalette

    public var body: some View {
        VStack(spacing: 8) {
            // Row 1: Brush Types
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(BrushType.allCases) { type in
                        let isSelected = (type == currentBrushType)
                        Button(action: {
                            currentBrushType = type
                        }) {
                            Text(type.title(isVietnamese: loc.isVietnamese))
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .foregroundColor(isSelected ? Color.neonCyan : .white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color.neonCyan.opacity(0.25) : Color.white.opacity(0.12))
                                        .overlay(
                                            Capsule()
                                                .stroke(isSelected ? Color.neonCyan : Color.white.opacity(0.25), lineWidth: isSelected ? 2 : 1)
                                        )
                                )
                        }
                    }
                }
                .padding(.horizontal, 4)
            }

            // Row 2: Brush Size Slider & Clear Button
            HStack(spacing: 10) {
                // Live preview dot
                let dotSize = min(max(currentBrushWidth * 0.9, 14.0), 34.0)
                ZStack {
                    Circle()
                        .fill(colors[currentColorIndex])
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .frame(width: dotSize, height: dotSize)
                }
                .frame(width: 36, height: 36)

                // Slider
                Slider(
                    value: $currentBrushWidth,
                    in: 8...80,
                    step: 1
                )
                .accentColor(colors[currentColorIndex])

                // Size Label
                Text("\(Int(currentBrushWidth)) px")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(Color(hex: "#AAAAAA"))
                    .frame(width: 44, alignment: .trailing)

                // Clear Canvas Button
                Button(action: onClearTapped) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#FF3B30"))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.12))
                                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        )
                }
            }
            .padding(.horizontal, 4)

            // Row 3: Neon Color Palette
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach(0..<colors.count, id: \.self) { idx in
                        let isSelected = (idx == currentColorIndex)
                        Button(action: {
                            currentColorIndex = idx
                        }) {
                            ZStack {
                                Circle()
                                    .fill(colors[idx])
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(isSelected ? Color.white : Color.white.opacity(0.25), lineWidth: isSelected ? 4 : 1.5)
                                    )
                                    .shadow(color: colors[idx].opacity(isSelected ? 0.9 : 0.3), radius: isSelected ? 6 : 2)
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "#1A1A28").opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: -4)
        )
        .padding(.horizontal, 10)
    }
}
