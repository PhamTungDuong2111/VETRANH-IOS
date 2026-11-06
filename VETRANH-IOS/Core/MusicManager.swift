//
//  MusicManager.swift
//  VETRANH-IOS
//

import Foundation
import AVFoundation
import Combine

public struct MusicTrack: Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let fileName: String
    public let resourceName: String

    public init(id: Int, title: String, fileName: String, resourceName: String) {
        self.id = id
        self.title = title
        self.fileName = fileName
        self.resourceName = resourceName
    }
}

public final class MusicManager: ObservableObject {
    public static let shared = MusicManager()

    private let keySelectedTrack = "neon_selected_track_id"
    private let keyIsMuted = "neon_music_is_muted"
    private let keyVolume = "neon_music_volume"

    public static let tracks: [MusicTrack] = [
        MusicTrack(id: 1, title: "Bài 1", fileName: "1.mp3", resourceName: "music_1"),
        MusicTrack(id: 2, title: "Bài 2", fileName: "22222.mp3", resourceName: "music_22222"),
        MusicTrack(id: 3, title: "Bài 3", fileName: "333.mp3", resourceName: "music_333"),
        MusicTrack(id: 4, title: "Bài 4", fileName: "44.mp3", resourceName: "music_44"),
        MusicTrack(id: 5, title: "Bài 5", fileName: "5.mp3", resourceName: "music_5"),
        MusicTrack(id: 6, title: "Bài 6", fileName: "6.mp3", resourceName: "music_6")
    ]

    private var audioPlayer: AVAudioPlayer?

    @Published public var currentTrackId: Int = 1
    @Published public var isMuted: Bool = false
    @Published public var volume: Float = 0.8

    public var currentTrack: MusicTrack {
        MusicManager.tracks.first(where: { $0.id == currentTrackId }) ?? MusicManager.tracks[0]
    }

    private init() {
        let prefs = UserDefaults.standard
        let savedId = prefs.integer(forKey: keySelectedTrack)
        self.currentTrackId = savedId > 0 ? savedId : 1

        if prefs.object(forKey: keyIsMuted) != nil {
            self.isMuted = prefs.bool(forKey: keyIsMuted)
        } else {
            self.isMuted = false
        }

        if prefs.object(forKey: keyVolume) != nil {
            self.volume = prefs.float(forKey: keyVolume)
        } else {
            self.volume = 0.8
        }

        setupAudioSession()

        if !isMuted {
            playTrack(id: currentTrackId)
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioSession setup error: \(error.localizedDescription)")
        }
    }

    public func playTrack(id: Int) {
        let track = MusicManager.tracks.first(where: { $0.id == id }) ?? MusicManager.tracks[0]
        currentTrackId = track.id
        isMuted = false
        savePrefs()

        guard let url = Bundle.main.url(forResource: track.resourceName, withExtension: "wav") ??
                        Bundle.main.url(forResource: track.resourceName, withExtension: "mp3") else {
            print("Audio file not found: \(track.resourceName)")
            return
        }

        do {
            audioPlayer?.stop()
            audioPlayer = nil

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    public func toggleMute() -> Bool {
        isMuted.toggle()
        if isMuted {
            audioPlayer?.pause()
        } else {
            if audioPlayer == nil {
                playTrack(id: currentTrackId)
            } else {
                audioPlayer?.volume = volume
                audioPlayer?.play()
            }
        }
        savePrefs()
        return isMuted
    }

    public func setMute(_ mute: Bool) {
        guard isMuted != mute else { return }
        isMuted = mute
        if isMuted {
            audioPlayer?.pause()
        } else {
            if audioPlayer == nil {
                playTrack(id: currentTrackId)
            } else {
                audioPlayer?.volume = volume
                audioPlayer?.play()
            }
        }
        savePrefs()
    }

    public func setVolume(_ vol: Float) {
        self.volume = max(0.0, min(vol, 1.0))
        audioPlayer?.volume = self.volume
        savePrefs()
    }

    public func nextTrack() {
        let currentIndex = MusicManager.tracks.firstIndex(where: { $0.id == currentTrackId }) ?? 0
        let nextIndex = (currentIndex + 1) % MusicManager.tracks.count
        playTrack(id: MusicManager.tracks[nextIndex].id)
    }

    public func onPause() {
        audioPlayer?.pause()
    }

    public func onResume() {
        if !isMuted {
            audioPlayer?.play()
        }
    }

    private func savePrefs() {
        let prefs = UserDefaults.standard
        prefs.set(currentTrackId, forKey: keySelectedTrack)
        prefs.set(isMuted, forKey: keyIsMuted)
        prefs.set(volume, forKey: keyVolume)
    }
}
