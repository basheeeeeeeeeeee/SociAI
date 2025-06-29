//
//  EditableView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/26/24.
//

import SwiftUI

struct EditablePostView: View {
    let category: String
    let postIndex: Int
    @Binding var post: String

    @AppStorage("savedIdeas") private var savedIdeasString: String = ""
    @State private var savedIdeas: [String: [String]] = [:]
    @State private var firstLine: String = ""

    let currentDate = Date()

    var body: some View {
        VStack(spacing: 0) {
            // Display the date like in a note app
            Text(currentDate, style: .date)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 20)  // Adjust padding for the date position
                .frame(maxWidth: .infinity, alignment: .center)

            // Full-screen text editor for editing the post content
            TextEditor(text: $post)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(0)  // Edge-to-edge effect
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: post) { _ in
                    autoSavePost()
                    updateFirstLine()
                }
        }
        .navigationBarTitle(firstLine, displayMode: .inline)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadSavedIdeas()
            updateFirstLine()
        }
    }

    // Function to update the first line of the post (used as the title in the nav bar)
    func updateFirstLine() {
        firstLine = post.components(separatedBy: "\n").first ?? ""  // Extract first line for title
    }

    // Auto-save changes to the post when it’s edited
    func autoSavePost() {
        if let jsonData = savedIdeasString.data(using: .utf8),
           var decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            
            // Update the post at the correct index for the category
            decodedIdeas[category]?[postIndex] = post
            
            // Save the updated posts back to AppStorage
            if let updatedData = try? JSONEncoder().encode(decodedIdeas),
               let updatedString = String(data: updatedData, encoding: .utf8) {
                savedIdeasString = updatedString
                print("Auto-saved post \(postIndex + 1) in category: \(category)")
            } else {
                print("Failed to auto-save post.")
            }
        } else {
            print("Failed to load saved ideas for auto-save.")
        }
    }

    // Load saved ideas for the selected category
    func loadSavedIdeas() {
        if let jsonData = savedIdeasString.data(using: .utf8),
           let decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            savedIdeas = decodedIdeas
        }
    }
}
