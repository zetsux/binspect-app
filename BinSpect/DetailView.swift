//
//  DetailView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 02/05/24.
//

import SwiftUI

struct DetailView: View {
    var history: History
    
    var body: some View {
        NavigationStack {
            VStack {
                if let uiImg = UIImage(data: history.image) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 280, height: 382)
                        .clipShape(RoundedRectangle(cornerRadius: 24.0))
                        .padding(.bottom, 24)
                }
                
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
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    if let uiImg = UIImage(systemName: "globe"), let imgData = uiImg.heicData() {
        return DetailView(history: History(image: imgData))
    }
    return EmptyView()
}
