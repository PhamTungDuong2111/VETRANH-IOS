//
//  TemplateGallerySheet.swift
//  VETRANH-IOS
//

import SwiftUI

public struct TemplateGallerySheet: View {
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    public let currentSelection: StencilType
    public let onSelect: (StencilType) -> Void
    public let onRemoveStencil: () -> Void

    @State private var selectedCategoryIndex: Int = 0

    private let categories = [
        ("cat_all", "All"),
        ("cat_cute", "Cute"),
        ("cat_animals", "Animals"),
        ("cat_cosmic", "Cosmic"),
        ("cat_mandala", "Mandala")
    ]

    private let allTemplates: [StencilType] = StencilType.allCases.filter { $0 != .none }

    private var filteredTemplates: [StencilType] {
        switch selectedCategoryIndex {
        case 1:
            return allTemplates.filter { $0.categoryVi == "Dễ thương" }
        case 2:
            return allTemplates.filter { $0.categoryVi == "Động vật" }
        case 3:
            return allTemplates.filter { $0.categoryVi == "Vũ trụ" }
        case 4:
            return allTemplates.filter { $0.categoryVi == "Mandala" }
        default:
            return allTemplates
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    public var body: some View {
        ZStack {
            Color(hex: "#0E101A").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(loc.text("dialog_templates_title"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color.neonCyan)
                        Text(loc.text("dialog_templates_subtitle"))
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#AAAAAA"))
                    }
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<categories.count, id: \.self) { idx in
                            let isSelected = (idx == selectedCategoryIndex)
                            Button(action: {
                                selectedCategoryIndex = idx
                            }) {
                                Text(loc.text(categories[idx].0))
                                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? Color.neonCyan : .white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
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
                }

                // Grid of Template Cards
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredTemplates) { template in
                            let isSelected = (template == currentSelection)
                            Button(action: {
                                onSelect(template)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                VStack(spacing: 4) {
                                    TemplateThumbnailView(stencil: template, size: 66)
                                        .frame(height: 66)

                                    Text(template.localizedTitle(isVietnamese: loc.isVietnamese))
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(isSelected ? Color.neonCyan : .white)
                                        .lineLimit(1)

                                    Text(template.localizedCategory(isVietnamese: loc.isVietnamese))
                                        .font(.system(size: 9))
                                        .foregroundColor(Color.white.opacity(0.6))
                                        .lineLimit(1)
                                }
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isSelected ? Color.neonCyan.opacity(0.2) : Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(isSelected ? Color.neonCyan : Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                }

                // Bottom Remove Stencil Button
                Button(action: {
                    onRemoveStencil()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                        Text(loc.text("btn_remove_stencil"))
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.18))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.3), lineWidth: 1))
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}
