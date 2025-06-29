//
//  OutoutDetailsView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct OutputDetailView: View {
    let output: String

    var body: some View {
        ScrollView {
            Text(output)
                .padding()
        }
        .navigationTitle("Saved Output")
    }
}

#Preview {
    OutputDetailView(output: "This is a sample output for preview purposes.")
}

