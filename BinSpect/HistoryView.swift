//
//  HistoryView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 02/05/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query var histories: [History]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(histories) { history in
                        NavigationLink {
                            DetailView(history: history)
                        } label: {
                            VStack(alignment: .leading) {
                                if let uiImg = UIImage(data: history.image) {
                                    Image(uiImage: uiImg)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width:172, height:172)
                                        .clipped()
                                        .padding(.bottom, 8)
                                }
                                
                                Section {
                                    Section {
                                        Image(systemName: history.type == "Organic" ? "leaf.fill" : (history.type == "Inorganic" ? "arrow.3.trianglepath" : "questionmark.app.fill") )
                                        Text(history.type)
                                    }
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(history.type == "Organic" ? Color(UIColor.systemGreen) : (history.type == "Inorganic" ? Color(UIColor.systemBlue) : Color(UIColor.systemGray)))

                                    Text("Confidence: \(history.confidence, format: .number.precision(.fractionLength(2)))%")
                                        .font(.footnote)
                                        .padding(.bottom, 12)
                                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    
                                    Text(history.timestamp.formatted(date: .long, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(Color(UIColor.systemGray))
                                }
                                    .padding(.horizontal, 12)
                            }
                                .padding(.bottom, 16)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        }
                    }
                        .padding(.vertical, 4)
                }
            }
                .padding(.horizontal, 12)
                .background(Color(UIColor.secondarySystemBackground))
                .navigationTitle("History")
        }
    }
}

#Preview {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            History.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    for i in (1...10) {
        if let uiImg = UIImage(systemName: "globe"), let imgData = uiImg.heicData() {
            sharedModelContainer.mainContext.insert(History(image: imgData))
        }
    }
    
    return HistoryView()
        .modelContainer(sharedModelContainer)
}
