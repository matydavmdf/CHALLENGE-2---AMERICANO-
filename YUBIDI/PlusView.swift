//
//  PlusView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 16/11/25.
//

import SwiftUI


struct PlusView2: View {
    @Environment(\.dismiss) var dismiss

    // Single, consistent signature
    var onSave: (String, UIImage?) -> Void = { _, _ in }
    var body: some View {
        NewPlaylistView(onSave: { name, image in
            onSave(name, image)
        })
    }
}

struct NewPlaylistView: View {
    @Environment(\.dismiss) var dismiss
    @State private var playlistName: String = ""
    @State private var showImagePicker = false
    @State private var showPhotoPicker = false

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?

    // Single, consistent signature
    var onSave: (String, UIImage?) -> Void = { _, _ in }

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Camera button with placeholder image
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(width: 280, height: 280)
                        .overlay(
                            Group {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 280, height: 280)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        )

                    Button {
                        showImagePicker = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.indigo)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                        }
                    }
                    .confirmationDialog(
                        "",
                        isPresented: $showImagePicker,
                        titleVisibility: .hidden
                    ) {
                        Button("Take Photo") {
                                                    print("🔍 Take Photo premuto")
                                                    print("📷 Fotocamera disponibile: \(UIImagePickerController.isSourceTypeAvailable(.camera))")
                                                    sourceType = .camera
                                                    showPhotoPicker = true
                                                }
                        Button("Choose Photo") {
                            sourceType = .photoLibrary
                            showPhotoPicker = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .sheet(isPresented: $showPhotoPicker) {
                        ImagesPicker2(sourceType: sourceType, selectedImage: $selectedImage)
                    }

                    
                }
                .padding(.top, 10)

                TextField("Playlist Title", text: .init(
                    get: { playlistName },
                    set: { playlistName = $0 }
                ))
                .font(.system(size: 25, weight: .regular))
                .foregroundColor(playlistName.isEmpty ? .gray.opacity(0.3) : .primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .accentColor(.indigo)

                Spacer()
            }
            .navigationTitle("New Playlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onSave(playlistName, selectedImage)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .disabled(playlistName.isEmpty)
                    .opacity(playlistName.isEmpty ? 0.3 : 1.0)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.indigo))
                }
            }
        }
    }
}

#Preview{
    PlusView2(onSave: { name, image in
        print("Preview saved playlist named: \(name), image set: \(image != nil)")
    })
}
