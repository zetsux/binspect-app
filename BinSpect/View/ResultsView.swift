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
    @State private var isShowingAlert = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @State var resultViewModel = ResultViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { metrics in
                VStack {
                    Spacer()
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: metrics.size.width * 0.71)
                        .clipShape(RoundedRectangle(cornerRadius: 24.0))
                    
                    Spacer()
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Section {
                                Image(systemName: resultViewModel.type == "Organic" ? "leaf.fill" : "arrow.3.trianglepath")
                                Text(resultViewModel.type)
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(resultViewModel.type == "Organic" ? Color(UIColor.systemGreen) : (resultViewModel.type == "Inorganic" ? Color(UIColor.systemBlue) : Color(UIColor.systemGray)))
                            .font(.largeTitle)
                            
                            Text("Confidence: \(resultViewModel.confidence, format: .number.precision(.fractionLength(2)))%")
                                .font(.footnote)
                                .padding(.bottom, 12)
                            
                            Text("It’s a \(resultViewModel.type.lowercased()) trash!")
                                .font(.callout)
                                .padding(.bottom, 24)
                        }
                        .padding(.leading, 56)
                        Spacer()
                    }
                    
                    HStack {
                        Button {
                            guard let imgData = image.heicData() else {return}
                            modelContext.insert(History(image: imgData, type: resultViewModel.type, confidence: resultViewModel.confidence))
                            isShowingAlert = true
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
                        .tint(Color(UIColor.systemTeal))
                        .frame(width: 296)
                    
                    Spacer()
                }
                    .alert("Successfully saved to your history!", isPresented: $isShowingAlert) {
                        Button("OK") {
                            dismiss()
                        }
                    }
            }
                .navigationTitle("Results")
                .navigationBarTitleDisplayMode(.inline)
        }
            .task {
                guard let model = ModelClassifierLoader.model else {return}
                resultViewModel.classifyTrashImage(image: image, trashClassifier: model)
            }
    }
}

//#Preview {
//    ResultsView()
//}
