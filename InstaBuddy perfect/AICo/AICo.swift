 //
//  InstaBuddyApp.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

@main
struct InstaBuddyApp: App {
    @State private var showLoadingScreen = true // Show loading screen initially

    var body: some Scene {
        WindowGroup {
            if showLoadingScreen {
                LoadingScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 3 seconds delay
                            withAnimation {
                                showLoadingScreen = false // Transition to ContentView
                            }
                        }
                    }
            } else {
                ContentView()  // The main entry point that holds the TabView
            }
        }
    }
}
