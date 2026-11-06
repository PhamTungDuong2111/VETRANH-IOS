//
//  ShareSheet.swift
//  VETRANH-IOS
//

import SwiftUI
import UIKit

public struct ShareSheet: UIViewControllerRepresentable {
    public let items: [Any]
    public var excludedActivityTypes: [UIActivity.ActivityType]? = nil

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
