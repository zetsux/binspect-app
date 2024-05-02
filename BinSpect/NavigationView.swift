//
//  SwiftUIView.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 29/04/24.
//

import SwiftUI

struct NavigationView: View {
    var body: some View {
        TabView {
            InspectView()
                .tabItem {
                    Label("Inspect", systemImage: "magnifyingglass")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }.tint(Color(UIColor.systemTeal))
    }
}

#Preview {
    NavigationView()
}
