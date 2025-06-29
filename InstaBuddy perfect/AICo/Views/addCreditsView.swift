//
//  addCreditsView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct AddCreditsView: View {
    @AppStorage("credits") private var credits: Int = 10  // Use @AppStorage for shared credits

    var body: some View {
        VStack {
            Text("Your Credits")
                .font(.largeTitle)
                .padding()

            Text("\(credits) Credits Remaining")
                .font(.title)
                .padding()

            Button(action: {
                credits += 100  // Add 100 credits
            }) {
                Text("Add 100 Credits")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
