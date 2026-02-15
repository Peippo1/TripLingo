//
//  ContentView.swift
//  TripLingo
//
//  Created by Tim Finch on 15/02/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            LessonsHomeView()
                .tabItem {
                    Label("Lessons", systemImage: "book")
                }

            PhrasebookHomeView()
                .tabItem {
                    Label("Phrasebook", systemImage: "text.bubble")
                }

            TranslateHomeView()
                .tabItem {
                    Label("Translate", systemImage: "globe")
                }

            ExploreHomeView()
                .tabItem {
                    Label("Explore", systemImage: "map")
                }
        }
    }
}

#Preview {
    ContentView()
}
