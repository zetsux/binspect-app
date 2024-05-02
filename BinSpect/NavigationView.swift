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

            ImagePickView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }.tint(.mint)
    }
}

#Preview {
    NavigationView()
}
