//
//  TimelapseReplaySheet.swift
//  VETRANH-IOS
//

import SwiftUI
import Photos

public struct TimelapseReplaySheet: View {
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    public let canvasView: DrawingCanvasUIView

    @State private var currentProgress: CGFloat = 0.05
    @State private var isPlaying: Bool = true
    @State private var speed: CGFloat = 1.0
    @State private var previewImage: UIImage? = nil

    // Exporting
    @State private var isExporting: Bool = false
    @State private var exportProgress: Int = 0
    @State private var exportedVideoURL: URL? = nil
    @State private var showExportSuccess: Bool = false
    @State private var showShareSheet: Bool = false

    private let timer = Timer.publish(every: 0.033, on: .main, in: .common).autoconnect()

    private var totalSteps: Int {
        max(1, canvasView.getTotalSteps())
    }

    private var currentStep: Int {
        max(1, min(totalSteps, Int(currentProgress * CGFloat(totalSteps))))
    }

    public var body: some View {
        ZStack {
            Color(hex: "#0E101A").ignoresSafeArea()

            VStack(spacing: 10) {
                // Top bar
                HStack {
                    Image(systemName: "video.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.neonOrange)

                    Text(loc.text("video_step_by_step"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        isPlaying = false
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                // Preview Canvas Display
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )

                    if let img = previewImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.neonCyan))
                    }

                    // Overlay Play icon when paused
                    if !isPlaying && !isExporting {
                        Button(action: {
                            if currentProgress >= 1.0 {
                                currentProgress = 0.02
                            }
                            isPlaying = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.6))
                                    .frame(width: 60, height: 60)
                                    .overlay(Circle().stroke(Color.limeGreen, lineWidth: 2))

                                Image(systemName: "play.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.limeGreen)
                                    .offset(x: 2)
                            }
                        }
                    }
                }
                .frame(height: 310)
                .padding(.horizontal, 16)

                // Step Indicator & Progress text
                HStack {
                    Text(loc.text("step_counter", currentStep, totalSteps))
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color.neonCyan)

                    Spacer()

                    Text("\(Int(currentProgress * 100))%")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.neonOrange)
                }
                .padding(.horizontal, 18)

                // Progress Scrubber Slider
                Slider(
                    value: Binding(
                        get: { currentProgress },
                        set: {
                            currentProgress = $0
                            isPlaying = false
                            updateFrame()
                        }
                    ),
                    in: 0...1
                )
                .accentColor(Color.neonOrange)
                .padding(.horizontal, 16)

                // Controls Row: [⏮️] [▶️/⏸️] [⏭️] [🔄] | 1x 2x 4x
                HStack(spacing: 8) {
                    // Prev Step
                    Button(action: {
                        isPlaying = false
                        let delta = 1.0 / CGFloat(totalSteps)
                        currentProgress = max(0.02, currentProgress - delta)
                        updateFrame()
                    }) {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.neonCyan)
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                            )
                    }

                    // Play/Pause
                    Button(action: {
                        if isPlaying {
                            isPlaying = false
                        } else {
                            if currentProgress >= 1.0 {
                                currentProgress = 0.02
                            }
                            isPlaying = true
                        }
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color.limeGreen)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .overlay(Circle().stroke(Color.limeGreen.opacity(0.6), lineWidth: 1.5))
                            )
                    }

                    // Next Step
                    Button(action: {
                        isPlaying = false
                        let delta = 1.0 / CGFloat(totalSteps)
                        currentProgress = min(1.0, currentProgress + delta)
                        updateFrame()
                    }) {
                        Image(systemName: "forward.end.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.neonCyan)
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                            )
                    }

                    // Replay
                    Button(action: {
                        currentProgress = 0.02
                        isPlaying = true
                        updateFrame()
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 38, height: 38)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.12))
                                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                            )
                    }

                    Spacer()

                    // Speed Selector Pills: 1x, 2x, 4x
                    ForEach([1.0, 2.0, 4.0], id: \.self) { s in
                        let isSelected = (speed == s)
                        Button(action: {
                            speed = s
                        }) {
                            Text("\(Int(s))x")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(isSelected ? Color.neonCyan : .white)
                                .frame(width: 34, height: 30)
                                .background(
                                    Capsule()
                                        .fill(isSelected ? Color.neonCyan.opacity(0.25) : Color.white.opacity(0.12))
                                        .overlay(
                                            Capsule().stroke(isSelected ? Color.neonCyan : Color.white.opacity(0.25), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)

                // Export Video Progress & Button
                VStack(spacing: 6) {
                    if isExporting {
                        ProgressView(value: Double(exportProgress), total: 100)
                            .accentColor(Color.limeGreen)
                            .padding(.horizontal, 16)

                        Text(loc.text("exporting_video", exportProgress))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.limeGreen)
                    }

                    Button(action: {
                        startExportVideo()
                    }) {
                        HStack {
                            Image(systemName: "film")
                                .font(.system(size: 15, weight: .bold))
                            Text(loc.text("export_mp4_video"))
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundColor(Color.limeGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.limeGreen.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Color.limeGreen, lineWidth: 1.5)
                                )
                                .shadow(color: Color.limeGreen.opacity(0.3), radius: 6)
                        )
                    }
                    .disabled(isExporting)
                    .opacity(isExporting ? 0.5 : 1.0)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 4)
                .padding(.bottom, 14)
            }
        }
        .onAppear {
            updateFrame()
        }
        .onReceive(timer) { _ in
            guard isPlaying && !isExporting else { return }
            let step = (0.012 * speed)
            currentProgress += step
            if currentProgress >= 1.0 {
                currentProgress = 1.0
                isPlaying = false
            }
            updateFrame()
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedVideoURL {
                ShareSheet(items: [url])
            }
        }
        .alert(isPresented: $showExportSuccess) {
            Alert(
                title: Text(loc.text("video_replay_title")),
                message: Text(loc.text("video_export_success")),
                primaryButton: .default(Text(loc.text("btn_view_photo"))) {
                    if let photosAppURL = URL(string: "photos-redirect://") {
                        UIApplication.shared.open(photosAppURL)
                    }
                },
                secondaryButton: .default(Text(loc.text("share"))) {
                    showShareSheet = true
                }
            )
        }
    }

    private func updateFrame() {
        let bmp = canvasView.renderProgressToBitmap(
            progress: currentProgress,
            targetSize: CGSize(width: 540, height: 960)
        )
        self.previewImage = bmp
    }

    private func startExportVideo() {
        isPlaying = false
        isExporting = true
        exportProgress = 0

        VideoExporter.exportDrawingTimelapse(
            drawingView: canvasView,
            durationSeconds: 6,
            fps: 30,
            width: 720,
            height: 1280,
            onProgress: { p in
                exportProgress = p
            },
            completion: { url in
                isExporting = false
                if let savedURL = url {
                    exportedVideoURL = savedURL
                    showExportSuccess = true
                }
            }
        )
    }
}

