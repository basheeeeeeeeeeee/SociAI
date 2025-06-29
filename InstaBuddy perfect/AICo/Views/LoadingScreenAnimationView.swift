//
//  LoadingScreenAnimationView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/26/24.
//

import SwiftUI
import UIKit

struct LoadingScreenView: View {
    @State private var cameraPressed = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Ambient gradient background
            AnimatedGradientBackground {
                VStack(spacing: 30) {
                    // Display confetti on camera click
                    if showConfetti {
                        ConfettiView()
                            .frame(width: 200, height: 200) // Confetti size can be adjusted
                    }
                }
            }

            // Button overlay to simulate camera press
            Button(action: {
                cameraPressed.toggle()
                triggerConfetti()
                print("Camera icon pushed")
            }) {
                CameraIconWithAmbientBackground()
                    .frame(width: 100, height: 100)
                    .padding(.bottom)
            }
            .buttonStyle(SquishyButtonStyle()) // Add the squishy effect to the button
        }
    }

    // Trigger the confetti effect
    func triggerConfetti() {
        withAnimation {
            showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfetti = false
            }
        }
    }
}

struct SquishyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Squishy effect
            .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.5), value: configuration.isPressed)
    }
}
