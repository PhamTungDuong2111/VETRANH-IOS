//
//  VideoExporter.swift
//  VETRANH-IOS
//

import UIKit
import AVFoundation
import Photos

public final class VideoExporter {

    public static func exportDrawingTimelapse(
        drawingView: DrawingCanvasUIView,
        durationSeconds: Int = 6,
        fps: Int32 = 30,
        width: Int = 720,
        height: Int = 1280,
        onProgress: @escaping (Int) -> Void,
        completion: @escaping (URL?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let totalFrames = durationSeconds * Int(fps)
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("timelapse_\(Int(Date().timeIntervalSince1970)).mp4")

            try? FileManager.default.removeItem(at: tempURL)

            guard let videoWriter = try? AVAssetWriter(outputURL: tempURL, fileType: .mp4) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: width,
                AVVideoHeightKey: height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 4_000_000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
                ]
            ]

            let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            writerInput.expectsMediaDataInRealTime = false

            let sourceAttributes: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height,
                kCVPixelBufferCGImageCompatibilityKey as String: true,
                kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
            ]

            let adaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: writerInput,
                sourcePixelBufferAttributes: sourceAttributes
            )

            guard videoWriter.canAdd(writerInput) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            videoWriter.add(writerInput)
            guard videoWriter.startWriting() else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            videoWriter.startSession(atSourceTime: .zero)

            var frameCount = 0
            while frameCount < totalFrames {
                if writerInput.isReadyForMoreMediaData {
                    let progress = CGFloat(frameCount + 1) / CGFloat(totalFrames)
                    let frameImage = drawingView.renderProgressToBitmap(
                        progress: progress,
                        targetSize: CGSize(width: width, height: height)
                    )

                    if let pixelBuffer = newPixelBufferFromCGImage(
                        cgImage: frameImage.cgImage!,
                        width: width,
                        height: height
                    ) {
                        let frameTime = CMTime(value: Int64(frameCount), timescale: fps)
                        adaptor.append(pixelBuffer, withPresentationTime: frameTime)
                    }

                    frameCount += 1

                    let percent = (frameCount * 90) / totalFrames
                    DispatchQueue.main.async {
                        onProgress(percent)
                    }
                } else {
                    Thread.sleep(forTimeInterval: 0.005)
                }
            }

            writerInput.markAsFinished()
            videoWriter.finishWriting {
                DispatchQueue.main.async {
                    onProgress(95)
                }

                if videoWriter.status == .completed {
                    // Save video to Photos Library
                    saveVideoToPhotos(videoURL: tempURL) { success in
                        DispatchQueue.main.async {
                            onProgress(100)
                            completion(success ? tempURL : nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }

    private static func saveVideoToPhotos(videoURL: URL, completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                completion(false)
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { success, error in
                completion(success)
            }
        }
    }

    private static func newPixelBufferFromCGImage(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(buffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, [])
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, [])

        return buffer
    }
}

