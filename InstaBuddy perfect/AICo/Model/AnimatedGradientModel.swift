//
//  AnimatedGradientView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct AnimatedGradientBackground<Content: View>: View {
    @State private var animateGradient = false
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            // The animated gradient background
            LinearGradient(gradient: Gradient(colors: [
                animateGradient ? .green : .blue,
                animateGradient ? .blue : .green
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateGradient)
            .onAppear {
                animateGradient.toggle()
            }

            // The main content over the background
            content
                .padding()  // Apply padding or other modifiers if needed
        }
    }
}

#Preview {
    AnimatedGradientBackground {
        Text("Sample Content")
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}
