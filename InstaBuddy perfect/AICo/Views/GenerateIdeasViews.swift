import SwiftUI

struct GenerateIdeasView: View {
    @State private var selectedPlatform: String = ""  // Store the selected platform
    @State private var selectedNiche: String = ""
    @State private var reelIdeas: [String] = []
    @State private var loading = false

    @AppStorage("savedIdeas") private var savedIdeasString: String = ""
    @AppStorage("credits") private var credits: Int = 10  // Default credits
    @AppStorage("appFirstOpenedTimeInterval") private var appFirstOpenedTimeInterval: TimeInterval = 0  // Store the first time app was opened

    @State private var savedIdeas: [String: [String]] = [:]  // Store ideas by category
    @State private var timeUntilNextCredit: String = "24:00:00"  // Countdown display

    @State private var showPopup = false  // For showing a pop-up message when credits are deducted
    @State private var popupText = ""

    @State private var isConfettiPlaying = false  // Confetti state

    let platforms = ["YouTube", "TikTok", "Instagram", "Facebook", "Twitter", "Threads"]
    let niches = ["Fitness", "Make Money Online", "Food", "Travel", "Tech", "Education", "Fashion"]

    // Timer for countdown
    @State private var countdownTimer: Timer?

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // Banner at the top
                GoldenNewsBanner()  // Ensure this banner stretches fully
                    .padding(.top)
                    .padding(.bottom)

                CameraIconWithAmbientBackground()
                    .padding(.bottom)

                // Platform Selection
                Text("Generate AI Copy")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .bold()

                // Credits and Time Until Next Credit
                Text("Credits: \(credits)")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("Next credits in: \(timeUntilNextCredit)")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)  // Add more padding to the bottom here

                // Platform Selection Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(platforms, id: \.self) { platform in
                            Button(action: {
                                selectedPlatform = platform  // Update platform on click
                            }) {
                                Text(platform)
                                    .padding()
                                    .background(selectedPlatform == platform ? Color.blue : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.leading, 15)  // Add padding to the left
                }
                .padding(.bottom, 10)

                // Niche Picker Section
                if !selectedPlatform.isEmpty {
                    Text("Select a Niche")
                        .font(.headline)
                        .padding(.top, 10)

                    Picker("Select your niche", selection: $selectedNiche) {
                        ForEach(niches, id: \.self) { niche in
                            Text(niche)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)  // Ensure the picker is always visible with enough height
                    .clipped()  // Ensure the picker doesn't overflow

                    if selectedNiche.isEmpty {
                        Text("Please select a niche to generate ideas")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    } else if loading {
                        ProgressView("Generating Ideas...")
                            .padding(.top, 10)
                    } else if !reelIdeas.isEmpty {
                        List {
                            ForEach(reelIdeas.indices, id: \.self) { index in
                                Text(reelIdeas[index])
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 20)
                                    .background(Color.clear)
                                    .textSelection(.enabled)
                            }
                            .onDelete(perform: deleteIdea)
                        }
                        .listStyle(PlainListStyle())
                        
                        Button(action: saveIdeas) {
                            Text("Save Ideas")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    } else {
                        Button(action: {
                            generateIdeas()
                            isConfettiPlaying = true
                        }) {
                            Text("Generate 3 Reel Ideas")
                                .padding()
                                .background(credits >= 3 ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 20)
                        .disabled(credits < 3)
                    }
                }

                Spacer()  // Ensure the content doesn't get pushed off the screen

                // Conditionally show the descriptive text
                if selectedPlatform.isEmpty {
                    Text("""
                    Generate AI Social Media Ideas and Copy with the touch of a button. This AI Model has been trained with thousands of top-performing copy across various social media platforms. V1.1
                    """)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .opacity(0.5)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)  // Padding at the bottom for spacing
                }
            }
            .padding(.horizontal)
            .onAppear {
                loadSavedIdeas()  // Load saved ideas when the view appears
                initializeAppFirstOpenedTime()  // Initialize or set first open time
                startTimer()  // Start the timer for real-time countdown
            }

            // Credit Deduction Popup
            if showPopup {
                VStack {
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)
                    Text(popupText)
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .padding(.top, 5)
                }
                .frame(width: 150, height: 150)
                .background(Color.black.opacity(0.8))
                .cornerRadius(15)
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showPopup = false
                        }
                    }
                }
            }

            // Confetti Animation (Triggered when generating ideas)
            if isConfettiPlaying {
                ConfettiView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isConfettiPlaying = false
                        }
                    }
            }
        }
    }

    // Initialize the appFirstOpenedTimeInterval on the first launch
    func initializeAppFirstOpenedTime() {
        if appFirstOpenedTimeInterval == 0 {
            appFirstOpenedTimeInterval = Date().timeIntervalSince1970  // Set the first open time
        }
        updateCountdown()  // Check time difference and update countdown
    }

    // Generate ideas using ChatGPT and deduct 3 credits
    func generateIdeas() {
        guard !selectedNiche.isEmpty else { return }
        guard credits >= 3 else { return }
        loading = true

        let chatGPTService = ChatGPTService()

        // Call the appropriate function based on the selected platform
        switch selectedPlatform {
        case "YouTube":
            chatGPTService.generateYouTubeIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        case "TikTok":
            chatGPTService.generateTikTokIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        case "Instagram":
            chatGPTService.generateInstagramIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        case "Facebook":
            chatGPTService.generateFacebookIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        case "Twitter":
            chatGPTService.generateTwitterIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        case "Threads":
            chatGPTService.generateThreadsIdeas(niche: selectedNiche) { ideas in
                updateIdeas(ideas: ideas)
            }
        default:
            break
        }
    }

    func updateIdeas(ideas: [String]) {
        DispatchQueue.main.async {
            self.reelIdeas = ideas
            self.loading = false
            self.credits -= 3  // Deduct 3 credits
            popupText = "- 3 Credits"
            withAnimation {
                showPopup = true
            }
        }
    }

    // Save the generated ideas as a new note under a category
    func saveIdeas() {
        let categoryName = "\(selectedNiche) Ideas"

        if savedIdeas[categoryName] == nil {
            savedIdeas[categoryName] = []
        }
        savedIdeas[categoryName]?.append(contentsOf: reelIdeas)

        if let jsonData = try? JSONEncoder().encode(savedIdeas),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            savedIdeasString = jsonString
        }

        reelIdeas = []  // Clear the current list of ideas after saving
    }

    // Load saved ideas from @AppStorage
    func loadSavedIdeas() {
        if let jsonData = savedIdeasString.data(using: .utf8),
           let decodedIdeas = try? JSONDecoder().decode([String: [String]].self, from: jsonData) {
            savedIdeas = decodedIdeas
        }
    }

    // Delete ideas
    func deleteIdea(at offsets: IndexSet) {
        reelIdeas.remove(atOffsets: offsets)
    }

    // Function to start the countdown for adding credits
    func updateCountdown() {
        let currentTime = Date().timeIntervalSince1970
        let timeElapsed = currentTime - appFirstOpenedTimeInterval

        if timeElapsed >= 86400 {  // 86400 seconds in a day
            credits += 3  // Add 3 credits after 24 hours
            appFirstOpenedTimeInterval = Date().timeIntervalSince1970  // Reset the time
        } else {
            let remainingTime = 86400 - timeElapsed
            updateTimeUntilNextCredit(remainingTime)
        }
    }

    // Update the remaining time for the countdown
    func updateTimeUntilNextCredit(_ remainingTime: TimeInterval) {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        timeUntilNextCredit = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Start a timer to update countdown every second
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateCountdown()
        }
    }
}



struct CameraIconWithAmbientBackground: View {
    var body: some View {
        ZStack {
            AnimatedGradientBackground {
            }
            .frame(width: 100, height: 100)
            
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
        }
        .clipShape(Circle())
        .shadow(radius: 10)
    }
}
