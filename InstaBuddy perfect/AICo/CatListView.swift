//
//  CatListView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct CategoriesListView: View {
    let categories = ["Fitness Ideas", "Fashion Ideas", "Food Ideas", "Travel Ideas", "Tech Ideas", "Education Ideas"]

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: ViewGeneratedIdeasView(category: category)) {
                            Text(category)
                        }
                    }
                }
                .navigationTitle("Saved Idea Categories")
            }
        }
    }
}

#Preview {
    CategoriesListView()
}
