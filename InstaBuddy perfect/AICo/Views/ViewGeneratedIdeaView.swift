//
//  CategorySelectionView.swift
//  InstaBuddy
//
//  Created by Bashir Adeniran on 9/25/24.
//

import SwiftUI

struct ViewGeneratedIdeasView: View {
    @AppStorage("savedIdeas") private var savedIdeasString: String = ""
    @State private var savedIdeas: [String: [String]] = [:]  // Store ideas by category

    var body: some View {
        NavigationView {
            List {
                ForEach(savedIdeas.keys.sorted(), id: \.self) { category in
                    NavigationLink(destination: SavedNotesView(category: category, ideas: savedIdeas[category] ?? [])) {
                        Text(category)
                    }
                }
            }
            .navigationTitle("Saved Ideas")
            .onAppear {
                loadSavedIdeas()
            }
        }
    }

    // Load saved ideas from @AppStorage
    func loadSavedIdeas() {
        if let jsonData = savedIdeasString.data(using: .utf8),
           let decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            savedIdeas = decodedIdeas
        }
    }
}

struct SavedNotesView: View {
    let category: String
    @State var ideas: [String]
    @State private var titlesWithTimestamps: [String] = []

    // Use @AppStorage to save notes and timestamps by category
    @AppStorage("savedIdeas") private var savedIdeasString: String = ""
    @AppStorage("savedTitles") private var savedTitlesString: String = ""

    var body: some View {
        List {
            ForEach(ideas.indices, id: \.self) { index in
                if index < titlesWithTimestamps.count {
                    NavigationLink(destination: EditablePostView(category: category, postIndex: index, post: $ideas[index])) {
                        VStack(alignment: .leading) {
                            TextField("Edit Title", text: Binding(
                                get: { titlesWithTimestamps[index] },
                                set: { newTitle in
                                    titlesWithTimestamps[index] = newTitle
                                    saveUpdatedData()  // Save the updated title immediately when edited
                                })
                            )
                            .font(.headline)
                            .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(ideas[index])
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .lineLimit(1) // Show a preview of the idea text
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .onDelete(perform: deleteIdea) // Allow deletion
        }
        .listStyle(PlainListStyle())
        .navigationTitle(category.contains("Ideas") ? category : "\(category) Ideas") // Handle "Ideas" in title correctly
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadSavedData()  // Load saved data for this category
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addNewIdea) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Idea")
                }
            }
        }
    }

    // Function to delete ideas and timestamps
    func deleteIdea(at offsets: IndexSet) {
        ideas.remove(atOffsets: offsets)
        titlesWithTimestamps.remove(atOffsets: offsets)
        saveUpdatedData()
    }

    // Function to add a new idea with a timestamp
    func addNewIdea() {
        let newIdea = "New Idea"
        let timestamp = formatTimestamp(Date()) + ":\(ideas.count + 1)"
        
        ideas.append(newIdea)
        titlesWithTimestamps.append(timestamp)

        saveUpdatedData() // Save the updated data
    }

    // Load saved data for this category
    func loadSavedData() {
        // Load ideas
        if let jsonData = savedIdeasString.data(using: .utf8),
           let decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData),
           let categoryIdeas = decodedIdeas[category] {
            ideas = categoryIdeas
        }
        
        // Load titles
        if let jsonData = savedTitlesString.data(using: .utf8),
           let decodedTitles = try? JSONDecoder().decode([String: [String]].self, from: jsonData),
           let categoryTitles = decodedTitles[category] {
            titlesWithTimestamps = categoryTitles
        }

        // If titles and ideas don't match in count, generate missing timestamps
        if titlesWithTimestamps.count != ideas.count {
            let newTimestamps = (titlesWithTimestamps.count..<ideas.count).map { index in
                formatTimestamp(Date()) + ":\(index + 1)"
            }
            titlesWithTimestamps.append(contentsOf: newTimestamps)
        }
        
        saveUpdatedData()  // Save after loading
    }

    // Helper function to format the timestamp
    func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM:dd:yyyy:HH:mm:ss"  // Timestamp format
        return formatter.string(from: date)
    }

    // Save updated data for this category
    func saveUpdatedData() {
        // Save ideas
        var allIdeas = decodeOrInitializeStorage(for: savedIdeasString)
        allIdeas[category] = ideas
        saveToStorage(allIdeas, key: &savedIdeasString)

        // Save titles
        var allTitles = decodeOrInitializeStorage(for: savedTitlesString)
        allTitles[category] = titlesWithTimestamps
        saveToStorage(allTitles, key: &savedTitlesString)
    }

    // Decode or initialize storage for saving categories
    func decodeOrInitializeStorage(for storageString: String) -> [String: [String]] {
        if let jsonData = storageString.data(using: .utf8),
           let decodedData = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            return decodedData
        } else {
            return [:]  // Return an empty dictionary if decoding fails
        }
    }

    // Save data back to AppStorage
    func saveToStorage(_ data: [String: [String]], key: inout String) {
        if let jsonData = try? JSONEncoder().encode(data),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            key = jsonString
        }
    }
}
