//
//  ImagePickView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 29/04/24.
//

import SwiftUI
import PhotosUI

struct ImagePickView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                        }
                        print("Failed to load the image")
                    }
                }
            
            if let image {
             Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding()
    }
}

#Preview {
    ImagePickView()
}
