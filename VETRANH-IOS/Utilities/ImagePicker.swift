//
//  ImagePicker.swift
//  VETRANH-IOS
//

import SwiftUI
import PhotosUI

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding public var image: UIImage?
    public var onImagePicked: ((UIImage) -> Void)?
    @Environment(\.presentationMode) var presentationMode

    public init(image: Binding<UIImage?>, onImagePicked: ((UIImage) -> Void)? = nil) {
        self._image = image
        self.onImagePicked = onImagePicked
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let uiImage = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.parent.image = uiImage
                        self?.parent.onImagePicked?(uiImage)
                    }
                }
            }
        }
    }
}
