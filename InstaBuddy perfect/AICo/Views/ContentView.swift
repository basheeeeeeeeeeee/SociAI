//
//  ContentView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            TabView {
                GenerateIdeasView()
                    .tabItem {
                        Label("Generate Ideas", systemImage: "lightbulb")
                    }

                ViewGeneratedIdeasView()  // Display saved ideas in notes format
                    .tabItem {
                        Label("View Ideas", systemImage: "doc.text")
                    }

                AddCreditsView()  // Keep Add Credits view
                    .tabItem {
                        Label("Add Credits", systemImage: "creditcard")
                    }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

