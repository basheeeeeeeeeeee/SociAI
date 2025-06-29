//
//  SavedOutputView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct SavedOutputsView: View {
    let category: String
    let outputs: [String]

    var body: some View {
        VStack {
            Text("\(category)")
                .font(.largeTitle)
                .padding()

            if outputs.isEmpty {
                Text("No saved outputs yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(outputs.indices, id: \.self) { index in
                    NavigationLink(destination: OutputDetailView(output: outputs[index])) {
                        Text("Output \(index + 1)")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    SavedOutputsView(category: "Fitness Ideas", outputs: ["Sample output 1", "Sample output 2"])
}

