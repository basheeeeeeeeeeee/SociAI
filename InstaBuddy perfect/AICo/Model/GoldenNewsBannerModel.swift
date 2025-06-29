//
//  GoldenNewsBannerView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/27/24.
//

import SwiftUI

struct GoldenNewsBanner: View {
    let announcements = [
        "🚀 New feature update coming soon!",
        "🎉 Flash sale: Get 50% more credits today!",
        "🔥 Keep up with the latest trends!"
    ]
    @State private var currentAnnouncementIndex = 0
    @State private var offsetX: CGFloat = UIScreen.main.bounds.width

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background for banner
                LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.orange, Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(maxWidth: .infinity, maxHeight: 40)  // Ensure full width and set height for the banner
                .edgesIgnoringSafeArea(.all)  // Ensure it ignores horizontal safe area insets

                // Scrolling text
                Text(announcements[currentAnnouncementIndex])
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .offset(x: offsetX)
                    .onAppear {
                        animateText(in: geometry)
                    }
                    .onChange(of: currentAnnouncementIndex, perform: { _ in
                        offsetX = geometry.size.width
                        animateText(in: geometry)
                    })
            }
        }
        .frame(width: 450, height: 40)  // Set height of banner
    }

    // Function to animate the scrolling text
    func animateText(in geometry: GeometryProxy) {
        let duration: Double = 10.0  // Adjust speed by changing duration
        withAnimation(Animation.linear(duration: duration)) {
            offsetX = -geometry.size.width
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            currentAnnouncementIndex = (currentAnnouncementIndex + 1) % announcements.count
        }
    }
}
