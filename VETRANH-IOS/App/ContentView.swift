//
//  ContentView.swift
//  VETRANH-IOS
//

import SwiftUI
import Photos

public struct ContentView: View {
    @StateObject private var loc = LocalizationManager.shared

    // Canvas instance
    @State private var canvasView = DrawingCanvasUIView()

    // History state
    @State private var canUndo: Bool = false
    @State private var canRedo: Bool = false

    // Tools state
    @State private var currentBrushType: BrushType = .neon
    @State private var currentBrushWidth: CGFloat = 24.0
    @State private var currentColorIndex: Int = 0 // Neon Cyan
    @State private var currentSymmetryMode: SymmetryMode = .none
    @State private var currentStencil: StencilType = .none
    @State private var isStencilVisible: Bool = true

    // Sheets & Dialogs
    @State private var showTemplateGallery: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showBackgroundOptions: Bool = false
    @State private var showClearAlert: Bool = false
    @State private var showLanguageDialog: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var shareImage: UIImage? = nil
    @State private var savedArtworkImage: UIImage? = nil
    @State private var showSaveSuccess: Bool = false

    // Toast
    @State private var toast: ToastMessage? = nil

    private let neonUIColors = UIColor.neonPaletteUI

    public var body: some View {
        ZStack {
            // Fullscreen Canvas
            DrawingCanvasRepresentable(
                canvasView: $canvasView,
                onHistoryChanged: { u, r in
                    canUndo = u
                    canRedo = r
                }
            )
            .ignoresSafeArea()

            // Overlay UI Controls
            VStack {
                // Top Header Toolbar
                TopToolbarView(
                    canUndo: canUndo,
                    canRedo: canRedo,
                    symmetryMode: currentSymmetryMode,
                    currentStencil: currentStencil,
                    isStencilVisible: isStencilVisible,
                    onUndo: {
                        canvasView.undo()
                    },
                    onRedo: {
                        canvasView.redo()
                    },
                    onCycleSymmetry: {
                        let next = currentSymmetryMode.next
                        currentSymmetryMode = next
                        canvasView.setSymmetryMode(next)
                        showToast("\(loc.text("symmetry")): \(next.label)")
                    },
                    onLanguageTapped: {
                        showLanguageDialog = true
                    },
                    onStencilTapped: {
                        showTemplateGallery = true
                    },
                    onToggleStencilGuide: {
                        isStencilVisible = canvasView.toggleStencilGuideVisibility()
                    },
                    onPhotoTapped: {
                        if canvasView.hasBackgroundPhoto() {
                            showBackgroundOptions = true
                        } else {
                            showImagePicker = true
                        }
                    },
                    onShareTapped: {
                        let img = canvasView.exportBitmap()
                        shareImage = img
                        showShareSheet = true
                    },
                    onSaveTapped: {
                        saveArtworkToGallery()
                    }
                )
                .padding(.top, 8)

                // Toast Banner
                if let t = toast {
                    ToastView(text: t.text)
                        .padding(.top, 6)
                }

                Spacer()

                // Bottom Tools Toolbar
                BottomToolbarView(
                    currentBrushType: $currentBrushType,
                    currentBrushWidth: $currentBrushWidth,
                    currentColorIndex: $currentColorIndex,
                    onClearTapped: {
                        showClearAlert = true
                    }
                )
                .padding(.bottom, 12)
            }

            // Save Success Glow Dialog
            if showSaveSuccess, let img = savedArtworkImage {
                SaveSuccessDialog(
                    image: img,
                    onOpenPhotos: {
                        showSaveSuccess = false
                        if let url = URL(string: "photos-redirect://") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    },
                    onShare: {
                        showSaveSuccess = false
                        shareImage = img
                        showShareSheet = true
                    },
                    onContinue: {
                        showSaveSuccess = false
                    }
                )
            }
        }
        // Change Brush Type
        .onChange(of: currentBrushType) { newType in
            canvasView.setBrushType(newType)
        }
        // Change Brush Width
        .onChange(of: currentBrushWidth) { newWidth in
            canvasView.setBrushWidth(newWidth)
        }
        // Change Color
        .onChange(of: currentColorIndex) { newIdx in
            let col = neonUIColors[newIdx]
            canvasView.setBrushColor(col)
        }
        // Template Gallery Sheet
        .sheet(isPresented: $showTemplateGallery) {
            TemplateGallerySheet(
                currentSelection: currentStencil,
                onSelect: { selected in
                    currentStencil = selected
                    canvasView.setStencil(selected)
                    isStencilVisible = true
                    showToast(loc.text("toast_stencil_selected", selected.emoji, selected.localizedTitle(isVietnamese: loc.isVietnamese)))
                },
                onRemoveStencil: {
                    currentStencil = .none
                    canvasView.setStencil(.none)
                    isStencilVisible = false
                    showToast(loc.text("toast_freehand_mode"))
                }
            )
        }
        // Photo Picker Sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                image: .constant(nil),
                onImagePicked: { picked in
                    canvasView.setBackgroundPhoto(picked)
                    showToast(loc.text("toast_photo_loaded"))
                }
            )
        }
        // Share Sheet
        .sheet(isPresented: $showShareSheet) {
            if let img = shareImage {
                ShareSheet(items: [img])
            }
        }
        // Clear Confirmation Alert
        .alert(isPresented: $showClearAlert) {
            Alert(
                title: Text(loc.text("dialog_clear_title")),
                message: Text(loc.text("dialog_clear_msg")),
                primaryButton: .destructive(Text(loc.text("dialog_clear_confirm"))) {
                    canvasView.clear()
                    showToast(loc.text("toast_canvas_cleared"))
                },
                secondaryButton: .cancel(Text(loc.text("dialog_clear_cancel")))
            )
        }
        // Background Photo Options Action Sheet
        .actionSheet(isPresented: $showBackgroundOptions) {
            ActionSheet(
                title: Text(loc.text("clear_photo_prompt")),
                buttons: [
                    .default(Text(loc.text("change_photo"))) {
                        showImagePicker = true
                    },
                    .destructive(Text(loc.text("remove_photo"))) {
                        canvasView.setBackgroundPhoto(nil)
                    },
                    .cancel(Text(loc.text("dialog_clear_cancel")))
                ]
            )
        }
        // Language Choice Dialog
        .actionSheet(isPresented: $showLanguageDialog) {
            ActionSheet(
                title: Text(loc.text("dialog_language_title")),
                buttons: [
                    .default(Text(loc.text("lang_english"))) {
                        loc.setLanguage(vietnamese: false)
                        showToast(loc.text("toast_lang_changed"))
                    },
                    .default(Text(loc.text("lang_vietnamese"))) {
                        loc.setLanguage(vietnamese: true)
                        showToast(loc.text("toast_lang_changed"))
                    },
                    .cancel(Text(loc.text("dialog_clear_cancel")))
                ]
            )
        }
    }

    private func showToast(_ text: String) {
        withAnimation {
            toast = ToastMessage(text)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                if toast?.text == text {
                    toast = nil
                }
            }
        }
    }

    private func saveArtworkToGallery() {
        let bitmap = canvasView.exportBitmap()

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                guard status == .authorized || status == .limited else {
                    showToast(loc.text("toast_permission_needed"))
                    return
                }

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: bitmap)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            savedArtworkImage = bitmap
                            withAnimation {
                                showSaveSuccess = true
                            }
                            showToast(loc.text("toast_save_success"))
                        } else {
                            let msg = error?.localizedDescription ?? "Unknown error"
                            showToast(loc.text("toast_save_error", msg))
                        }
                    }
                }
            }
        }
    }
}
