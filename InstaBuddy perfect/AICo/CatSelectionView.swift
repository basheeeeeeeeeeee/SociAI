//
//  CatSelectionView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct CatSelectionView: View {
    // Load categories and their saved outputs from @AppStorage
    @AppStorage("savedIdeas") private var savedIdeasString: String = ""
    @State private var savedIdeas: [String: [String]] = [:]

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(savedIdeas.keys), id: \.self) { category in
                    NavigationLink(destination: SavedOutputsView(category: category, outputs: savedIdeas[category] ?? [])) {
                        Text(category)
                    }
                }
            }
            .navigationTitle("Select a Category")
            .onAppear {
                loadSavedIdeas()
            }
        }
    }

    // Function to load saved ideas from @AppStorage
    func loadSavedIdeas() {
        if let jsonData = savedIdeasString.data(using: .utf8),
           let decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            savedIdeas = decodedIdeas
        }
    }
}
