//
//  MusicSettingsSheet.swift
//  VETRANH-IOS
//

import SwiftUI

public struct MusicSettingsSheet: View {
    @ObservedObject var loc = LocalizationManager.shared
    @ObservedObject var music = MusicManager.shared
    @Environment(\.presentationMode) var presentationMode

    public var body: some View {
        ZStack {
            Color(hex: "#0E101A").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {
                // Header
                HStack(spacing: 10) {
                    Image(systemName: "music.note")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.neonCyan)

                    Text(loc.text("music_settings"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Toggle("", isOn: Binding(
                        get: { !music.isMuted },
                        set: { music.setMute(!$0) }
                    ))
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.neonCyan))
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                Text(loc.text("music_subtitle"))
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.6))
                    .padding(.horizontal, 16)

                Divider()
                    .background(Color.white.opacity(0.15))
                    .padding(.horizontal, 16)

                // Track List
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(MusicManager.tracks) { track in
                            let isPlaying = (track.id == music.currentTrackId && !music.isMuted)

                            Button(action: {
                                music.playTrack(id: track.id)
                            }) {
                                HStack(spacing: 12) {
                                    Text(isPlaying ? "▶️" : "🎵")
                                        .font(.system(size: 15))

                                    Text("\(track.title) (\(track.fileName))")
                                        .font(.system(size: 14, weight: isPlaying ? .bold : .medium))
                                        .foregroundColor(isPlaying ? Color.neonCyan : .white)

                                    Spacer()

                                    if isPlaying {
                                        Text(loc.text("music_on"))
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(Color.limeGreen)
                                    }
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(isPlaying ? Color.neonCyan.opacity(0.2) : Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(isPlaying ? Color.neonCyan : Color.white.opacity(0.2), lineWidth: isPlaying ? 2 : 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Volume Slider
                HStack(spacing: 10) {
                    Text("🔊")
                        .font(.system(size: 16))

                    Slider(
                        value: Binding(
                            get: { music.volume },
                            set: { music.setVolume($0) }
                        ),
                        in: 0...1
                    )
                    .accentColor(Color.neonCyan)

                    Text("\(Int(music.volume * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.neonCyan)
                        .frame(width: 44, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                // Close Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(loc.text("close"))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color.neonCyan)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.neonCyan.opacity(0.4), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}
