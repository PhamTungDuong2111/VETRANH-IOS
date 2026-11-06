//
//  ToastView.swift
//  VETRANH-IOS
//

import SwiftUI

public struct ToastMessage: Identifiable, Equatable {
    public let id = UUID()
    public let text: String

    public init(_ text: String) {
        self.text = text
    }
}

public struct ToastView: View {
    public let text: String

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .foregroundColor(Color.neonCyan)
                .font(.system(size: 14))
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(hex: "#1E2235").opacity(0.95))
                .overlay(
                    Capsule().stroke(Color.neonCyan.opacity(0.6), lineWidth: 1.5)
                )
                .shadow(color: Color.neonCyan.opacity(0.4), radius: 8, x: 0, y: 3)
        )
        .padding(.horizontal, 24)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

