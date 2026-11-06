//
//  TopToolbarView.swift
//  VETRANH-IOS
//

import SwiftUI

public struct TopToolbarView: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var music = MusicManager.shared

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
    public let onVideoTapped: () -> Void
    public let onMusicTapped: () -> Void

    public var body: some View {
        VStack(spacing: 6) {
            // Row 1: Primary Toolbar
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

                Spacer()

                // Stencil Templates Badge Button
                Button(action: onStencilTapped) {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color.electricYellow)
                        Text(currentStencil == .none ? loc.text("stencil_badge") : currentStencil.localizedTitle(isVietnamese: loc.isVietnamese))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.electricYellow)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                Capsule().stroke(Color.electricYellow.opacity(0.5), lineWidth: 1)
                            )
                    )
                }

                // Stencil Guide Visibility Eye Toggle Button (visible when stencil is active)
                if currentStencil != .none {
                    Button(action: onToggleStencilGuide) {
                        Image(systemName: isStencilVisible ? "eye" : "eye.slash")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color.neonCyan)
                            .frame(width: 34, height: 34)
                    }
                }

                // Language Switcher
                Button(action: onLanguageTapped) {
                    HStack(spacing: 3) {
                        Text(loc.isVietnamese ? "🇻🇳" : "🇬🇧")
                            .font(.system(size: 12))
                        Text(loc.isVietnamese ? "VI" : "EN")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                    )
                }

                // Save Artwork Button
                Button(action: onSaveTapped) {
                    Image(systemName: "tray.and.arrow.down.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color.limeGreen)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .overlay(Circle().stroke(Color.limeGreen.opacity(0.5), lineWidth: 1))
                        )
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(hex: "#1A1A28").opacity(0.88))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.22), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3)
            )

            // Row 2: Secondary Bar (Video Replay, Music Pill, Symmetry, Photo, Share)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    // 1. Big Glowing Video Step-by-Step Button
                    Button(action: onVideoTapped) {
                        HStack(spacing: 5) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color.neonOrange)

                            Text(loc.text("video_step_by_step"))
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color.neonOrange)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(Color.neonOrange.opacity(0.18))
                                .overlay(
                                    Capsule().stroke(Color.neonOrange.opacity(0.7), lineWidth: 1.5)
                                )
                                .shadow(color: Color.neonOrange.opacity(0.3), radius: 5)
                        )
                    }

                    // 2. Music Pill (Track name + Quick Mute toggle)
                    HStack(spacing: 5) {
                        Button(action: onMusicTapped) {
                            HStack(spacing: 4) {
                                Image(systemName: "music.note")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(music.isMuted ? Color.white.opacity(0.5) : Color.neonCyan)

                                Text(music.isMuted ? loc.text("music_off") : "\(music.currentTrack.title) (\(music.currentTrack.fileName))")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(music.isMuted ? Color.white.opacity(0.6) : Color.neonCyan)
                                    .lineLimit(1)
                            }
                        }

                        // Divider
                        Rectangle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 1, height: 14)

                        // Quick Mute / Unmute Button
                        Button(action: {
                            _ = music.toggleMute()
                        }) {
                            Image(systemName: music.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(music.isMuted ? Color.white.opacity(0.4) : Color.limeGreen)
                                .frame(width: 22, height: 22)
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.12))
                            .overlay(
                                Capsule().stroke(Color.neonCyan.opacity(0.4), lineWidth: 1)
                            )
                    )

                    // 3. Symmetry Mode
                    Button(action: onCycleSymmetry) {
                        HStack(spacing: 3) {
                            Image(systemName: "circle.grid.cross")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(symmetryMode == .none ? .white : Color.neonCyan)
                            Text(symmetryMode.label)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(symmetryMode == .none ? .white : Color.neonCyan)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                                .overlay(
                                    Capsule().stroke(Color.white.opacity(0.25), lineWidth: 1)
                                )
                        )
                    }

                    // 4. Background Photo
                    Button(action: onPhotoTapped) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                            )
                    }

                    // 5. Share Artwork
                    Button(action: onShareTapped) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.neonPink)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(Circle().stroke(Color.neonPink.opacity(0.4), lineWidth: 1))
                            )
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
        .padding(.horizontal, 10)
    }
}
