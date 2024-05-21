//
//  DetailView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 02/05/24.
//

import SwiftUI

struct DetailView: View {
    var history: History
    @State private var isShowingAlert = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            GeometryReader { metrics in
                VStack {
                    Spacer()
                    if let uiImg = UIImage(data: history.image) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .scaledToFit()
                            .frame(width: metrics.size.width * 0.71)
                            .clipShape(RoundedRectangle(cornerRadius: 24.0))
                    }
                    
                    Spacer()
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Section {
                                Image(systemName: history.type == "Organic" ? "leaf.fill" : "arrow.3.trianglepath")
                                Text(history.type)
                            }
                            .fontWeight(.bold)
                            .foregroundStyle(history.type == "Organic" ? Color(UIColor.systemGreen) : (history.type == "Inorganic" ? Color(UIColor.systemBlue) : Color(UIColor.systemGray)))
                            .font(.largeTitle)
                            
                            Text("Confidence: \(history.confidence, format: .number.precision(.fractionLength(2)))%")
                                .font(.subheadline)
                                .padding(.bottom, 12)
                            
                            Text("It’s a \(history.type.lowercased()) trash!")
                                .font(.callout)
                                .padding(.bottom, 24)
                            
                            Text(history.timestamp.formatted(date: .long, time: .shortened))
                                .font(.footnote)
                                .padding(.bottom, 24)
                                .foregroundStyle(Color(UIColor.systemGray))
                        }
                        .padding(.leading, 56)
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Delete") {
                    isShowingAlert = true
                }.foregroundStyle(Color(UIColor.systemRed))
                
                .alert("Are you sure to delete this from your history?", isPresented: $isShowingAlert) {
                        Button("Delete", role: .destructive) {
                            modelContext.delete(history)
                            dismiss()
                        }
                } message: {
                    Text("This action is irreversible.")
                }
            }
        }
    }
}

#Preview {
    if let uiImg = UIImage(systemName: "globe"), let imgData = uiImg.heicData() {
        return DetailView(history: History(image: imgData))
    }
    return EmptyView()
}
