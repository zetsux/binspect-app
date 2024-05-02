//
//  ResultsView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 30/04/24.
//

import CoreML
import SwiftUI
import Vision

struct ResultsView: View {
    var image: UIImage
    var trashClassifier: TrashNBClassifier2
    @State var request: VNCoreMLRequest?
    @State var type: String = "Loading..."
    @State var confidence: Double = 0.0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 280, height: 382)
                    .clipShape(RoundedRectangle(cornerRadius: 24.0))
                    .padding(.bottom, 24)
                
                HStack {
                    VStack (alignment: .leading) {
                        Section {
                            Image(systemName: type == "Organic" ? "leaf.fill" : "arrow.3.trianglepath")
                            Text(type)
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(type == "Organic" ? .green : (type == "Inorganic" ? .blue : .gray))
                        .font(.largeTitle)
                        
                        Text("Confidence: \(confidence)%")
                            .font(.footnote)
                            .padding(.bottom, 12)
                        
                        Text("It’s your 15th \(type.lowercased()) trash!")
                            .font(.callout)
                            .padding(.bottom, 24)
                    }
                    .padding(.leading, 56)
                    Spacer()
                }
                
                HStack {
                    NavigationLink {
                        CameraView()
                    } label: {
                        HStack{
                            Image(systemName: "square.and.arrow.down")
                                .padding(.bottom, 2)
                            Text("Save")
                        }
                            .padding(.horizontal, 24)
                            .font(.callout)
                    }
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 40.0))
                    
                    Button {
                        dismiss()
                    } label: {
                        HStack{
                            Image(systemName: "return")
                                .padding(.top, 2)
                            Text("Re-inspect")
                        }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .font(.callout)
                    }
                        .buttonStyle(.bordered)
                        .clipShape(RoundedRectangle(cornerRadius: 40.0))
                }
                .tint(.mint)
                .frame(width: 296)
            }
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            if request == nil {
                if let visionModel = try? VNCoreMLModel(for: trashClassifier.model) {
                    request = VNCoreMLRequest(model: visionModel) { request, error in
                        if let results = request.results
                            as? [VNClassificationObservation] {
                            if results.isEmpty {
                                self.type = "Nothing found.."
                            } else {
                                self.type = results[0].identifier == "B" ? "Organic" : "Inorganic"
                                self.confidence = Double(results[0].confidence * 100)
                            }
                        } else if let error = error {
                            self.type = "Failed"
                            print("error: \(error.localizedDescription)")
                        } else {
                            self.type = "???"
                        }
                    }
                    request?.imageCropAndScaleOption = .scaleFill
                }
            }
            
            guard let ciImage = CIImage(image: image) else {
                print("Unable to create CIImage")
                return
            }
            
            if let request {
                let handler = VNImageRequestHandler(ciImage: ciImage)
                try? handler.perform([request])
            }
        }
    }
}

//#Preview {
//    ResultsView()
//}
