//
//  SaveSuccessDialog.swift
//  VETRANH-IOS
//

import SwiftUI

public struct SaveSuccessDialog: View {
    @ObservedObject var loc = LocalizationManager.shared

    public let image: UIImage
    public let onOpenPhotos: () -> Void
    public let onShare: () -> Void
    public let onContinue: () -> Void

    public var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    onContinue()
                }

            VStack(spacing: 14) {
                Text(loc.text("save_success_title"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color.limeGreen)

                Text(loc.text("save_success_location"))
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#CCCCCC"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)

                // Preview Card
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 240)
                    .background(Color.black)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: Color.neonCyan.opacity(0.3), radius: 10)

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: onOpenPhotos) {
                        Text(loc.text("btn_view_photo"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.neonCyan)
                            )
                    }

                    Button(action: onShare) {
                        Text(loc.text("btn_share_saved"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.neonPink)
                            )
                    }
                }

                Button(action: onContinue) {
                    Text(loc.text("btn_continue_drawing"))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.15))
                        )
                }
            }
            .padding(20)
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "#141624"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.8), radius: 20)
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}
