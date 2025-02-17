//
//  ContentView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 23/04/24.
//

import SwiftUI
import SwiftData
import PhotosUI
import Vision

struct InspectView: View {
    @State private var showDialog = false
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
    @State var hasImage = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(.trashIllustration)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 16)
                    .padding(.horizontal, 84)
                
                Text("Give us an image of your trash and we will categorize it as organic or inorganic.")
                    .padding(.horizontal, 92)
                    .foregroundStyle(Color(UIColor.systemGray))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 36)
                    .font(.callout)
                
                Button {
                    showDialog = true
                } label: {
                    HStack{
                        Image(systemName: "photo.fill")
                            .padding(.top, 2)
                        Text("Choose an Image")
                    }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(UIColor.systemTeal))
                    .confirmationDialog("Select Image Source", isPresented: $showDialog, titleVisibility: .visible) {
                        Button("Take from Camera") {
                            showCamera.toggle()
                        }
                        
                        Button("Pick from Gallery") {
                            showGallery.toggle()
                        }
                    }
                Spacer()
            }
                .fullScreenCover(isPresented: $showCamera) {
                    accessCameraView(selectedImage: $image, hasImage: $hasImage)
                }
                .photosPicker(isPresented: $showGallery, selection: $selectedItem, matching: .images)
                    .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                            hasImage = true
                        }
                        print("Failed to load the image")
                    }
                }
                .navigationTitle("Inspect")
                .navigationDestination(isPresented: $hasImage) {
                    if let image {
                        ResultsView(image: image)
                    }
                }
        }
        .task {
            ModelClassifierLoader.loadModel()
        }
    }
}

#Preview {
    InspectView()
}
