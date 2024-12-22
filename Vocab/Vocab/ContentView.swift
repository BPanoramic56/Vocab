//
//  ContentView.swift
//  Vocab
//
//  Created by Bruno Gomes Pascotto on 12/17/24.
//

import SwiftUI
import Foundation
import SwiftData

struct ContentView: View {
    @State var backgroundImage: String? = "Utah1"
    
//    let iconBlue = Color(red: 0.04, green: 0.0, blue: 1.0)
    let iconBlue = Color(red: 0.0, green: 0.909, blue: 1.0)
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image(backgroundImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea() // Ensures it covers the entire screen
                
                // Content
                VStack {
                    // Title
                    Text("Vocab\nMain Page")
                        .font(Font.custom("Rockwell-Regular", size: 50, relativeTo: .title))
                        .padding()
                        .foregroundColor(.white)
                        .background(.clear)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding(.bottom, 20)
                        .frame(alignment: .center)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 20) { // Adjust spacing for better layout
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 30))
                                .foregroundColor(iconBlue)
                            NavigationLink(destination: AddWordPage()) {
                                Text("Add Word")
                                    .font(.system(size: 30))
                                    .foregroundStyle(iconBlue)
                            }
                        }
                        HStack(spacing: 10) {
                            Image(systemName: "shuffle.circle")
                                .font(.system(size: 30))
                                .foregroundColor(iconBlue)
                            NavigationLink(destination: RandomWordPage()) {
                                Text("Add Random Word")
                                    .font(.system(size: 30))
                                    .foregroundStyle(iconBlue)
                            }
                        }
                        HStack(spacing: 10) {
                            Image(systemName: "rectangle.3.group.bubble")
                                .font(.system(size: 30))
                                .foregroundColor(iconBlue)
                            NavigationLink(destination: WordGroups()) {
                                Text("Collections")
                                    .font(.system(size: 30))
                                    .foregroundStyle(iconBlue)
                            }
                        }
                        HStack(spacing: 10) {
                            Image(systemName: "magazine")
                                .font(.system(size: 30))
                                .foregroundColor(iconBlue)
                            NavigationLink(destination: SeeWordsPage()) {
                                Text("See Words")
                                    .font(.system(size: 30))
                                    .foregroundStyle(iconBlue)
                            }
                        }
                    }
                    .padding() // Add padding inside the background
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.black.opacity(0.4)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 5) // Add shadow
                    )
                    .padding(.horizontal) // Add space outside the background

                    
                    Spacer()
                    
                    // Footer Bar
                    HStack {
                        NavigationLink(destination: ProfilePage()) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 35))
                                .foregroundColor(iconBlue)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.clear))
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: -2)
                }
                .padding() // Add padding to ensure content doesn't touch edges
            }
        }
        .onAppear(){
            self.backgroundImage = ["Utah1", "Utah2", "Utah3", "ParkCity1", "ParkCity2", "Timpanogos1", "Timpanogos2", "LCC1"].randomElement()
        }
    }
}

protocol getAmericanDate{
    func formattedDateAmericanStyle(from date: Date) -> String

    func getOrdinalSuffix(for day: Int) -> String
}

extension getAmericanDate{
    func formattedDateAmericanStyle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        // Get the month and year
        dateFormatter.dateFormat = "MMMM" // Full month name
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "yyyy" // Full year
        let year = dateFormatter.string(from: date)
        
        // Get the day and add the ordinal suffix
        let day = Calendar.current.component(.day, from: date)
        let ordinalSuffix = getOrdinalSuffix(for: day)
        
        return "\(month) \(day)\(ordinalSuffix), \(year)"
    }

    func getOrdinalSuffix(for day: Int) -> String {
        let suffixes = ["th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"]
        if (11...13).contains(day % 100) { return "th" } // Special case for 11th, 12th, 13th
        return suffixes[day % 10]
    }
}

protocol getColorForCollection{
    func decideBackgroundColor(sectionName: String) -> Color
}

extension getColorForCollection{
    func decideBackgroundColor(sectionName: String) -> Color{
        if (sectionName == "Hundred" || sectionName == "Time"){
            return Color(red: 0.376, green: 0.662, blue: 0.478).opacity(0.2)
        }
        else if (sectionName == "Places" || sectionName == "Technology"){
            return Color(red: 0.654, green: 0.678, blue: 0.776).opacity(0.2)
        }
        else if (sectionName == "Pronouns" || sectionName == "Emotions"){
            return Color(red: 0.721, green: 0.545, blue: 0.290).opacity(0.2)
        }
        else if (sectionName == "Science" || sectionName == "Travel"){
            return Color(red: 0.690, green: 0.843, blue: 1.0).opacity(0.2)
        }
        else if (sectionName == "Literature" || sectionName == "Health"){
            return Color(red: 0.639, green: 0.086, blue: 0.129).opacity(0.2)
        }
        else if (sectionName == "Business" || sectionName == "Professions"){
            return Color(red: 0.031, green: 0.498, blue: 0.549).opacity(0.3)
        }
        else if (sectionName == "TOEFL"){
            return Color(red: 0.603, green: 0.600, blue: 0.772).opacity(0.2)
        }
        else{
            return Color.purple.opacity(0.2)
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
            
            Divider()
                .background(Color.gray.opacity(0.3))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}

struct ProfilePage: View {
    @Query private var words: [Word]
    @State private var longestStreak: Int = 0
    @State private var averagePerDay: Double = 0
    
    @State private var addedWords: Int = 0
    @State private var randomWords: Int = 0
    @State private var collectionsExplored: Int = 0
    
    var body: some View {
        VStack{
            ScrollView{
                StatisticCard(title: "Total words learned", value: words.count == 1 ? "\(words.count) word" : "\(words.count) words")
                StatisticCard(title: "Most words in one day", value: "\(longestStreak)")
                StatisticCard(title: "You average", value: "\(averagePerDay) words/day")
                StatisticCard(title: "You have added", value: addedWords == 1 ? "\(addedWords) word" : "\(addedWords) words")
                StatisticCard(title: "You learned", value: randomWords == 1 ? "\(randomWords) random word" : "\(randomWords) random words")
                StatisticCard(title: "You have explored", value: collectionsExplored == 1 ? "\(collectionsExplored) collection" : "\(collectionsExplored) collections")
            }
        }
        .onAppear {
            getLongestStreak()
        }
    }
    
    func getLongestStreak() -> Void{
        var max: Int = 0
        var dateFrequency: [String: Int] = [:]
        var collectionNames: [String] = []

        for word in words {
            if dateFrequency.keys.contains(word.dateAdded){
                dateFrequency[word.dateAdded]! += 1
            }
            else{
                dateFrequency[word.dateAdded] = 1
            }
            
            if (word.source == "Added"){
                self.addedWords += 1
            }
            else if (word.source == "Random"){
                self.randomWords += 1
            }
            else{
                if (!collectionNames.contains(word.source)){
                    collectionNames.append(word.source)
                    self.collectionsExplored += 1
                }
            }
        }
        
        for (_, value) in dateFrequency{
            if (value >= max){
                max = value
            }
        }
        longestStreak = max 
        var dateCount = dateFrequency.keys.count
        if (dateCount == 0){
            dateCount = 1
        }
        averagePerDay = Double(words.count/dateCount)
    }
}

struct ImageCard: View {
    let image: Image
    let description: String
    let totalAmount: String
    
    var body: some View {
        VStack(spacing: 10) { // Adjust spacing
            image
                .resizable()
                .scaledToFit()
                .frame(height: 120) // Larger and proportionate
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
                .shadow(radius: 5)
            
            Text(description)
                .font(.headline) // Larger font for emphasis
                .multilineTextAlignment(.center)
                .foregroundColor(.primary) // Dynamic color for light/dark mode
            
            Text(totalAmount)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary) // Subtle secondary color
        }
        .padding() // Internal spacing
        .frame(width: 250, height: 200) // Uniform card size
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5) // Improved shadow effect
    }
}

struct WordGroups: View {
    var body: some View {
        ZStack {
            // Solid background color for the entire view
            Color.purple.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    // Simplified Title Section
                    Text("Collections")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                                .cornerRadius(10)
                        )
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    // Cards Section
                    VStack(spacing: 15) {
                        // Simplified NavigationLinks with cards
                        NavigationLink(destination: CollectionPage(title: "Hundred")) {
                            ImageCard(
                                image: Image(systemName: "book.pages"),
                                description: "100 Most Used Nouns",
                                totalAmount: "(100 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Time")) {
                            ImageCard(
                                image: Image(systemName: "timer"),
                                description: "Time",
                                totalAmount: "(26 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Technology")) {
                            ImageCard(
                                image: Image(systemName: "network"),
                                description: "Technology",
                                totalAmount: "(19 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Places")) {
                            ImageCard(
                                image: Image(systemName: "map"),
                                description: "Places",
                                totalAmount: "(19 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Pronouns")) {
                            ImageCard(
                                image: Image(systemName: "figure.wave"),
                                description: "Pronouns",
                                totalAmount: "(39 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Emotions")) {
                            ImageCard(
                                image: Image(systemName: "person.3.fill"),
                                description: "Emotions",
                                totalAmount: "(22 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Travel")) {
                            ImageCard(
                                image: Image(systemName: "airplane.arrival"),
                                description: "Travel",
                                totalAmount: "(18 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Science")) {
                            ImageCard(
                                image: Image(systemName: "testtube.2"),
                                description: "Science",
                                totalAmount: "(19 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Literature")) {
                            ImageCard(
                                image: Image(systemName: "text.book.closed"),
                                description: "Literature",
                                totalAmount: "(35 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Health")) {
                            ImageCard(
                                image: Image(systemName: "stethoscope.circle"),
                                description: "Health",
                                totalAmount: "(36 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Business")) {
                            ImageCard(
                                image: Image(systemName: "building.2"),
                                description: "Business",
                                totalAmount: "(28 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Professions")) {
                            ImageCard(
                                image: Image(systemName: "person.text.rectangle"),
                                description: "Professions",
                                totalAmount: "(29 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "TOEFL")) {
                            ImageCard(
                                image: Image(systemName: "append.page"),
                                description: "TOEFL test",
                                totalAmount: "(79 words)"
                            )
                        }
                        NavigationLink(destination: CollectionPage(title: "Phrasal")) {
                            ImageCard(
                                image: Image(systemName: "textformat.size"),
                                description: "Phrasal Verbs",
                                totalAmount: "(68 words)"
                            )
                        }
                    }
                    .padding(.horizontal) // Add padding to the card stack
                    .frame(maxWidth: .infinity) // Center cards horizontally
                }
                .frame(maxWidth: .infinity) // Center the entire VStack inside the ScrollView
                .padding() // Add some padding around the ScrollView content
            }
        }
    }

}


struct RandomWordPage: View, getAmericanDate{
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State var newWord: String = ""
    @State var newDefinition: String = ""
    @State var newExample: String = ""
    @State var wordOpacity = 1.0
    
    @State var validExample = true
    @State var wordAdded = false
    @State var validWord = false
    @State var randomWordColor: Color = .blue
    
    let blue = Color(red: 0.04, green: 0.0, blue: 1.0)
    let argentinianBlue = Color(red: 0.376, green: 0.686, blue: 1.0)
    let deepSkyBlue = Color(red: 0.156, green: 0.76, blue: 1.0)
    let aqua = Color(red: 0.19, green: 0.96, blue: 1.0)
    let celeste = Color(red: 0.08, green: 0.298, blue: 0.47)

    var body: some View {
        let colorArray = [blue, argentinianBlue, deepSkyBlue, aqua, celeste]
        
        ZStack {
            GeometryReader { geometry in
                Circle()
                    .offset(x: -geometry.size.width * 0.4, y: -geometry.size.height * 0.5)
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height * 1.2)
                    .foregroundColor(Color(red: 0.949, green: 0.950, blue: 0.85))
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("Random Word")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .font(Font.custom("Rockwell-Regular", size: 40, relativeTo: .title))
                
                Spacer()
                
                Text("""
                    In here, you will get a random word. You should provide an example and a description for it.
                    Press "New Word" to start and to change the word provided.
                    """)
                    .font(.body)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                
                Spacer()
                
                Button(action: {
                    updateWord(colorArray: colorArray)
                })
                {
                    Text("New Word")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .frame(width: 200)
                
                Spacer()
                
                VStack(spacing: 15) {
                    Text(newWord.capitalized)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(randomWordColor)
                        .opacity(wordOpacity) // Bind opacity to the state variable
                        .underline(true)
                    
                    // Example TextField
                    TextField("Enter an example...", text: $newExample)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
                        .font(.body)
                        .opacity(wordOpacity)
                        .autocorrectionDisabled(true)
                    
                    // Description TextField
                    TextField("Enter a description...", text: $newDefinition)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.2)))
                        .font(.body)
                        .opacity(wordOpacity)
                        .autocorrectionDisabled(true)
                }
                .padding(.horizontal, 20)
                
                if !validExample {
                    Text("The example does not utilize the word.")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                
                if wordAdded {
                    Text("The word was successfully added!")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
                
                Button(action: {
                    if considerExample(word: newWord, example: newExample) {
                        validExample = true
                        wordAdded = true
                        
                        let newWord = Word(
                            wordInit: newWord.capitalized,
                            exampleInit: newExample,
                            descriptionInit: newDefinition,
                            date: formattedDateAmericanStyle(from: Date.now),
                            source: "Random"
                        )
                        
                        context.insert(newWord)
                        
                        self.newExample = ""
                        self.newDefinition = ""
                        
                        do {
                            try context.save()
                        }
                        catch {
                            print("Error saving context: \(error)")
                        }
                        
                        updateWord(colorArray: colorArray)
                    }
                    else {
                        validExample = false
                    }
                })
                {
                    Text("Submit Word")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .frame(width: 200)
                
                Spacer()
            }
            .padding()
        }
    }

    func considerExample(word: String, example: String) -> Bool{
        return example.lowercased().contains(word.lowercased())
    }

    func updateWord(colorArray : [Color]) {
        // Step 1: Fade out
        withAnimation(.easeInOut(duration: 0.5)) {
            wordOpacity = 0.0
        }
        
        // Step 2: Wait, update the word, and fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            newWord = getRandomWordFromFile() // Update the word
            
            // Step 3: Fade in
            withAnimation(.easeInOut(duration: 0.5)) {
                wordOpacity = 1.0
            }
        }
    
        randomWordColor = colorArray.randomElement()!
    }
    
    func getRandomWordFromFile() -> String {
        let fileName = "words_alpha"
        let fileType = "txt"
        
        // Locating the file in the app bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("File not found in the bundle")
            return ""
        }
        
        // Reading the contents of the file
        do {
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Split the contents into words (one per line)
            // Trim any extra newlines and spaces, then split by newline
            let words = fileContents
                .split(whereSeparator: \.isNewline)  // Split by newline
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }  // Trim any leading/trailing whitespace
            
            // Ensure there are words in the array before calling randomElement()
            guard let randomWord = words.randomElement() else {
                print("Error: No words found in file.")
                return ""
            }
            
            return randomWord
        }
        catch {
            // Handle any errors that might occur while reading the file
            print("Error reading file: \(error.localizedDescription)")
        }
        
        return ""
    }
}

struct WordCell: View {
    var word: Word

    var body: some View {
        HStack {
            Spacer()
            Text(word.word)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(word.dateAdded)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: 5)
        .padding()
    }
}

struct UpdateWordSheet: View{
    @Environment(\.dismiss) private var dismiss
    @Bindable var word: Word
    
    var isFormValid: Bool {
        return !word.word.isEmpty && !word.example.isEmpty && !word.wordDescription.isEmpty
    }
    
    var body: some View{
        NavigationStack{
            Form{
                Section(header: Text("Word Form")) {
                    HStack {
                        Text("Word:")
                        Spacer()
                        Text(word.word)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.blue)
                    }
                    
                    HStack {
                        Text("Description:")
                        TextField("Enter Description", text: $word.wordDescription)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Example:")
                        TextField("Enter Example", text: $word.example)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Date Added:")
                        Spacer()
                        Text(word.dateAdded)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Text("From:")
                        Spacer()
                        Text(word.source)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.gray)
                    }
                    
                }
            }
            .navigationTitle("Update Word")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("Done"){
                        if isFormValid {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
}

struct SeeWordsPage: View, getColorForCollection {
    @Query private var words: [Word]
    @Environment(\.modelContext) var context
    
    @State private var wordEdit: Word?
    @State private var opacityRatio: Double = 1.0
    @State private var typeColor: Color = .blue
    
    var body: some View {
        if words.count != 0 {
            VStack(spacing: 0) {
                Text("Words Learned")
                    .font(Font.custom("Rockwell-Regular", size: 50, relativeTo: .title))
                    .foregroundColor(.white)
                    .padding([.top, .leading, .trailing])  // Padding only on sides and top to avoid extra space at the bottom
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            .frame(height: 125)
                    )
                    .cornerRadius(10)
                    .multilineTextAlignment(.center) // Center text within the `Text` view
                    .frame(maxWidth: .infinity) // Ensure the text spans the entire width to center
                    .onAppear()
                
                NavigationStack {
                    List {
                        Section {
                            HStack {
                                Spacer()
                                Text("Word")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Spacer()
                                Text("Date")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.vertical, 8)
                        }
                        .listSectionSpacing(.compact)
                        .listRowBackground(
                            Capsule()
                                .fill(Color.white.opacity(0.8))
                                .frame(maxWidth: .infinity)
                                .shadow(radius: 2)
                                .padding(.horizontal, 10)
                        )

                        ForEach(Array(words.enumerated()).reversed(), id: \.offset) { index, word in
                            let typeColor = setColor(source: word.source)
                            WordCell(word: word)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .onTapGesture {
                                    wordEdit = word
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(
                                    Capsule()
                                        .fill(typeColor)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 20)
                                )
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                context.delete(words[index])
                                try! context.save()
                            }
                        }
                    }
                    .sheet(item: $wordEdit) { word in
                        UpdateWordSheet(word: word)
                    }
                }
            }
            .background(Color(red: 0.949, green: 0.949, blue: 0.968))
        }
        else {
            VStack(spacing: 25) {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 100))
                    .foregroundColor(.orange)
                    .shadow(radius: 5)
                
                Text("""
                It seems like you haven't added any words yet.
                You can click "Add Word" in the main menu to start.
                """)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    func setColor(source: String) -> Color{
        
        if (source == "Added"){
            return Color(red: 0.376, green: 0.686, blue: 1.0).opacity(0.7)
        }
        else if (source == "Random"){
            return Color(red: 0.156, green: 0.76, blue: 1.0).opacity(0.7)
        }
        else{
            return decideBackgroundColor(sectionName: source)
        }
    }
}

struct Collection: Codable {
    let title: String
    let description: String
    let wordSet: [String]
}

struct CollectionPage: View, getAmericanDate, getColorForCollection {
    @Query private var words: [Word]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var backgroundColor: Color = Color.purple.opacity(0.2)
    
    @State private var collection: Collection?
    @State var definition: String = ""
    @State var title: String = ""
    
    @State private var newWords: [String] = []
    @State private var currentWord: String = ""
    @State private var wordOpacity = 1.0
    
    @State private var example: String = ""
    @State private var description: String = ""
    @State private var validWord = true
    @State private var validExample = true
    @State private var wordAdded = false
    

    var body: some View {
        ZStack {
            // Background Circle
            GeometryReader { _ in
                Circle()
                    .offset(x: -200, y: -300) // Adjust as needed for desired placement
                    .frame(width: 900, height: 740)
                    .foregroundColor(self.backgroundColor)
            }
            .edgesIgnoringSafeArea(.all)
            
            // Main Content
            if currentWord == "No more words" {
                VStack(spacing: 25) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 100))
                    Text("""
                        You have learned all words from this collection
                        Congratulations!
                        """)
                        .font(.system(size: 25))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering the VStack
            }
            else if !currentWord.isEmpty {
                VStack {
                    Text(title)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                    
                    Text(definition)
                        .font(.system(size: 28))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Text("Be sure to add an example and description for every word.")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    VStack(spacing: 25) {
                        Text(currentWord)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(height: 55)
                            )
                            .font(.system(size: 32))
                            .padding(.horizontal, 20)
                            .opacity(wordOpacity)
                        
                        TextField("Example", text: $example)
                            .disableAutocorrection(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.1))
                                    .frame(height: 55)
                            )
                            .font(.system(size: 32))
                            .padding(.horizontal, 20)
                            .opacity(wordOpacity)
                        
                        TextField("Description", text: $description)
                            .disableAutocorrection(true)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange.opacity(0.1))
                                    .frame(height: 55)
                            )
                            .font(.system(size: 32))
                            .padding(.horizontal, 20)
                            .opacity(wordOpacity)
                        
                        Button("Submit Word") {
                            handleWordSubmission()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!isFormValid)
                        
                        if !validWord {
                            Text("The given word does not seem to be valid. Please check and try again.")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        if !validExample {
                            Text("The example does not utilize the word.")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        if wordAdded {
                            Text("The word was successfully added!")
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 45)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering the VStack
            }
            else {
                VStack {
                    Text("Loading...")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Centering the VStack
            }
        }
        .onAppear {
            self.backgroundColor = decideBackgroundColor(sectionName: self.title)
            initializeWords()
        }
    }

    func capitalizeFirstLetter(of string: String) -> String {
        guard !string.isEmpty else { return string }
        let firstLetter = string.prefix(1).uppercased()
        let remainingLetters = string.dropFirst()
        return firstLetter + remainingLetters
    }
    
    func considerExample(word: String, example: String) -> Bool{
        return example.lowercased().contains(word.lowercased())
    }
    
    func getWords(collectionName: String){
            guard let path = Bundle.main.path(forResource: "Collections", ofType: "json") else{
                return
            }
            let url = URL(fileURLWithPath: path)
            do{
                let jsonData = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode([String: Collection].self, from: jsonData)
                if let collection = decodedData[collectionName] {
                    self.collection = collection
                    self.title = collection.title
                    self.definition = collection.description
                }
                else {
                    print("Collection with name \(collectionName) not found.")
                }
            }
            catch{
                print("Error: \(error)")
            }
        }

    // Ensure form is valid
    private var isFormValid: Bool {
        !example.isEmpty && !description.isEmpty
    }

    // Initialize words and the first word
    private func initializeWords() {
        getWords(collectionName: title)
        updateWordList()
    }

    // Fetch and update word list
    private func updateWordList() {
        let existingWords = Set(words.map { $0.word })
        newWords = collection?.wordSet.filter { !existingWords.contains($0) } ?? []
        currentWord = newWords.first ?? "No more words"
    }
    
    func countWords(in string: String) -> Int {
        let words = string.split { $0.isWhitespace || $0.isPunctuation }
        return words.count
    }

    // Handle word submission
    private func handleWordSubmission() {
        guard !currentWord.isEmpty, considerExample(word: currentWord, example: example) else {
            validExample = false
            return
        }
        
        validExample = true
        let newWord = Word(
            wordInit: countWords(in: currentWord) > 1 ? capitalizeFirstLetter(of: currentWord) : currentWord.capitalized,
            exampleInit: example,
            descriptionInit: description,
            date: formattedDateAmericanStyle(from: Date()),
            source: self.title
        )
        
        context.insert(newWord)
        self.example = ""
        self.description = ""
        
        do {
            try context.save()
            wordAdded = true
            updateNextWord()
        }
        catch {
            print("Error saving context: \(error)")
        }
    }

    // Update to the next word
    private func updateNextWord() {
        newWords.removeFirst()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            wordOpacity = 0.0
        }
        
        // Step 2: Wait, update the word, and fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentWord = newWords.first ?? "No more words"
            
            // Step 3: Fade in
            withAnimation(.easeInOut(duration: 0.5)) {
                wordOpacity = 1.0
            }
        }
    }
}


struct AddWordPage: View, getAmericanDate {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var word: String = ""
    @State private var example: String = ""
    @State private var description: String = ""
    @State var validWord = true;
    @State var validExample = true
    @State var wordAdded = false
    @State var wordOpacity: Double = 1.0
    
    let wordBack = Color(red: 0.81, green: 0.73, blue: 0.89)
    let exampleBack = Color(red: 0.83, green: 0.75, blue: 0.89)
    let descriptionBack = Color(red: 0.81, green: 0.73, blue: 1)
    let logoColor = Color(red: 0.90, green: 0.92, blue: 1)
    
    var isFormValid: Bool {
        return !word.isEmpty && !example.isEmpty && !description.isEmpty
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Circle()
                    .offset(x: -300, y: -400)
                    .frame(width: 1000, height: 820)
                    .foregroundColor(logoColor)
            }
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Title Text
                Text("Add Word")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .font(Font.custom("Rockwell-Regular", size: 40, relativeTo: .title))

                // Descriptions
                Text("In here you can add new\nwords to your vocabulary.")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Text("Provide a short description and an example for every word. This is made to ensure you understand the words you are adding.")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()

                // Form Fields and Button
                VStack(spacing: 20) {
                    // Word TextField
                    TextField("Word", text: $word)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(wordBack)
                                .cornerRadius(10)
                        )
                        .font(.system(size: 30))
                        .padding(.horizontal, 20)
                        .opacity(wordOpacity)

                    // Example TextField
                    TextField("Example", text: $example)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(exampleBack)
                                .cornerRadius(10)
                        )
                        .font(.system(size: 30))
                        .padding(.horizontal, 20)
                        .opacity(wordOpacity)

                    // Description TextField
                    TextField("Description", text: $description)
                        .disableAutocorrection(true)
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(descriptionBack)
                                .cornerRadius(10)
                        )
                        .font(.system(size: 30))
                        .padding(.horizontal, 20)
                        .opacity(wordOpacity)

                    // Submit Button
                    Button("Submit Word") {
                        if considerExample(word: word, example: example) {
                            considerWord(word: word)
                            validExample = true
                        } else {
                            validExample = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)

                    // Validation Messages
                    Text(validWord ? "" : """
                        The given word does not seem to be valid
                        Please check if you have typed it correctly and try again
                        """)
                        .multilineTextAlignment(.center)

                    Text(validExample ? "" : """
                        The example does not utilize the word
                        """)
                        .multilineTextAlignment(.center)

                    Text(wordAdded ? "The word was successfully added!" : "")
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                Spacer()
            }
        }
    }
    
    func considerExample(word: String, example: String) -> Bool{
        return example.lowercased().contains(word.lowercased())
    }
    
    func considerWord(word: String){
        isWordInFile(word:word.lowercased(), description:description, example:example)
    }
    
    func updateWord() {
        // Step 1: Fade out
        withAnimation(.easeInOut(duration: 0.5)) {
            wordOpacity = 0.0
        }
        
        // Step 2: Wait, update the word, and fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           
            // Step 3: Fade in
            withAnimation(.easeInOut(duration: 0.5)) {
                wordOpacity = 1.0
            }
        }
    }

    func isWordInFile(word: String, description: String, example: String) -> Void {
        // Locating the file in the app bundle
        guard let fileURL = Bundle.main.url(forResource: "words_alpha", withExtension: "txt") else {
            print("File not found in the bundle")
            return
        }
        
        // Reading the contents of the file
        do {
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Searching for the word in the file content
            if fileContents.contains(word) {
                let newWord = Word(wordInit: word.capitalized, exampleInit: example, descriptionInit: description, date:formattedDateAmericanStyle(from: Date.now), source: "Added") // Create object
                context.insert(newWord) // Insert object to context
                wordAdded = true
                do {
                    try context.save()
                    
                    self.word = ""
                    self.example = ""
                    self.description = ""
                    updateWord()
                }
                catch {
                    print("Error saving context: \(error)")
                }
            }
            else {
                print("The word '\(word)' was NOT found in the file.")
                validWord = false
                wordAdded = false
            }
        }
        catch {
            // Handle any errors that might occur while reading the file
            print("Error reading file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
