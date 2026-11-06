//
//  TopToolbarView.swift
//  VETRANH-IOS
//

import SwiftUI

public struct TopToolbarView: View {
    @ObservedObject var loc = LocalizationManager.shared

    public let canUndo: Bool
    public let canRedo: Bool
    public let symmetryMode: SymmetryMode
    public let currentStencil: StencilType
    public let isStencilVisible: Bool

    public let onUndo: () -> Void
    public let onRedo: () -> Void
    public let onCycleSymmetry: () -> Void
    public let onLanguageTapped: () -> Void
    public let onStencilTapped: () -> Void
    public let onToggleStencilGuide: () -> Void
    public let onPhotoTapped: () -> Void
    public let onShareTapped: () -> Void
    public let onSaveTapped: () -> Void

    public var body: some View {
        HStack(spacing: 6) {
            // Undo Button
            Button(action: onUndo) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
            }
            .disabled(!canUndo)
            .opacity(canUndo ? 1.0 : 0.35)

            // Redo Button
            Button(action: onRedo) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
            }
            .disabled(!canRedo)
            .opacity(canRedo ? 1.0 : 0.35)

            // Symmetry Pill
            Button(action: onCycleSymmetry) {
                HStack(spacing: 3) {
                    Image(systemName: "circle.grid.cross")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(symmetryMode == .none ? .white : Color.neonCyan)
                    Text(symmetryMode.label)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(symmetryMode == .none ? .white : Color.neonCyan)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
            }

            Spacer(minLength: 2)

            // Language Switcher
            Button(action: onLanguageTapped) {
                HStack(spacing: 2) {
                    Text(loc.isVietnamese ? "🇻🇳" : "🇬🇧")
                        .font(.system(size: 12))
                    Text(loc.isVietnamese ? "VI" : "EN")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
            }

            // Stencil Templates Badge Button
            Button(action: onStencilTapped) {
                HStack(spacing: 3) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.electricYellow)
                    Text(currentStencil == .none ? loc.text("stencil_badge") : currentStencil.localizedTitle(isVietnamese: loc.isVietnamese))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color.electricYellow)
                        .lineLimit(1)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .overlay(
                            Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
            }

            // Stencil Guide Visibility Eye Toggle Button (visible when stencil is active)
            if currentStencil != .none {
                Button(action: onToggleStencilGuide) {
                    Image(systemName: isStencilVisible ? "eye" : "eye.slash")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.neonCyan)
                        .frame(width: 32, height: 32)
                }
            }

            // Photo Background Button
            Button(action: onPhotoTapped) {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
            }

            // Share Button
            Button(action: onShareTapped) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.neonPink)
                    .frame(width: 34, height: 34)
            }

            // Save Artwork Button
            Button(action: onSaveTapped) {
                Image(systemName: "tray.and.arrow.down.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color.limeGreen)
                    .frame(width: 34, height: 34)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    )
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "#1A1A28").opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 10)
    }
}
