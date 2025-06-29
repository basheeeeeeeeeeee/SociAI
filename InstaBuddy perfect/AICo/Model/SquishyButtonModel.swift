//
//  SquishyButtonView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/26/24.
//

import SwiftUI
import CoreHaptics

struct SquishyButton: View {
    @State private var isPressed = false
    @State private var engine: CHHapticEngine?

    var body: some View {
        Button(action: {
            print("Camera icon button pressed")
            performHapticFeedback()
        }) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.green]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(width: 100, height: 100)
                    .scaleEffect(isPressed ? 0.9 : 1.0) // Squishy scale effect
                    .shadow(color: .gray, radius: 10, x: 0, y: 5)  // Shadow effect added here
                    .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.5), value: isPressed)

                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
            }
        }
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
            if pressing {
                performHapticFeedback()
            }
        }, perform: {
            // Do nothing on perform, handled by the button action
        })
        .onAppear(perform: prepareHaptics)
    }

    func performHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()

        // Additional haptic feedback via Core Haptics
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
        let pattern = try? CHHapticPattern(events: [hapticEvent], parameters: [])
        let player = try? engine?.makePlayer(with: pattern!)
        try? player?.start(atTime: 0)
    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptics Engine Error: \(error.localizedDescription)")
        }
    }
}

struct SquishyButtonWithConfetti: View {
    @State private var isPressed = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            if showConfetti {
                ConfettiView() // Add the confetti effect
                    .ignoresSafeArea()
            }
            Button(action: {
                isPressed.toggle()
                print("Camera icon button pressed")
                performHapticFeedback()
                triggerConfetti()
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.green]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPressed ? 0.9 : 1.0) // Squishy scale effect
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)  // Shadow effect added here
                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.5), value: isPressed)

                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 40))
                }
            }
        }
    }

    func performHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }

    func triggerConfetti() {
        // Temporarily show confetti
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
