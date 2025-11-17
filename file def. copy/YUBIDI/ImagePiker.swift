//
//  ImagePiker.swift
//  YUBIDI
//
//  Created by Matilde Davide on 16/11/25.
//

import SwiftUI
import UIKit

struct ImagesPicker2: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator

        // For camera, show default camera controls
        if sourceType == .camera {
            picker.showsCameraControls = true
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagesPicker2
        
        init(_ parent: ImagesPicker2) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
        
        // If you later decide to wire a custom cancel button to this:
        @objc func cancelPicker() {
            parent.dismiss()
        }
    }
}

#Preview {
    ImagesPicker2(sourceType: .photoLibrary, selectedImage: .constant(nil))
}
