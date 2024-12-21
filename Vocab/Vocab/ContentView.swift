//
//  ContentView.swift
//  Vocab
//
//  Created by Bruno Gomes Pascotto on 12/17/24.
//
//.background(LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))

import SwiftUI
import Foundation
import SwiftData
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Title
                Text("Vocab\nMain Page")
                    .font(Font.custom("Rockwell-Regular", size: 50, relativeTo: .title))
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            .frame(height: 125)
                    )
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 20)
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 10){
                    HStack(spacing: 10){
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: AddWordPage()) {
                            Text("Add Word")
                                .font(.system(size: 30))
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "shuffle.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: RandomWordPage()) {
                            Text("Add Random Word")
                                .font(.system(size: 30))
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "rectangle.3.group.bubble")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: WordGroups()) {
                            Text("Collections")
                                .font(.system(size: 30))
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "magazine")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: SeeWordsPage()) {
                            Text("See Words")
                                .font(.system(size: 30))
                        }
                    }
                }
                
                Spacer()
                
                // Footer Bar
                HStack {
                    NavigationLink(destination: profilePage()) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: -2)
            }
            .background(LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.2)]), startPoint: .top, endPoint: .bottom))
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

struct profilePage: View {
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
        averagePerDay = Double(words.count/dateFrequency.keys.count)
    }
}

struct ImageCard: View {
    let image: Image
    let description: String
    let totalAmount: String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(height: 100) // Adjust size as needed
                .clipShape(Rectangle()) // Optional styling
                .shadow(radius: 5)  // Optional styling
                .padding(.bottom, 10)
            
            Text(description)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            Text(totalAmount)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.horizontal)
        }
        .frame(width: 250, height: 200) // Adjust card size as needed
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}


struct WordGroups: View{
    var body: some View {
        ScrollView{
            VStack{
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
                        description: "Words for time",
                        totalAmount: "(21 words)"
                    )
                }
                NavigationLink(destination: CollectionPage(title: "Technology")) {
                    ImageCard(
                        image: Image(systemName: "network"),
                        description: "Words associated with technology",
                        totalAmount: "(19 words)"
                    )
                }
                NavigationLink(destination: CollectionPage(title: "Places")) {
                    ImageCard(
                        image: Image(systemName: "map"),
                        description: "Words for places in a city",
                        totalAmount: "(19 words)"
                    )
                }
                NavigationLink(destination: CollectionPage(title: "Pronouns")) {
                    ImageCard(
                        image: Image(systemName: "figure.wave"),
                        description: "Pronouns in the English Language",
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
        
        ZStack{
            GeometryReader { geometry in
                Circle()
                    .offset(x: -300, y: -400)
                    .frame(width: 1000, height: 820)
                    .foregroundColor(Color(red: 0.949, green: 0.950, blue: 0.85))
            }
            .edgesIgnoringSafeArea(.all)
            .offset(y: -150)
            
            VStack(spacing: 20) {
                Text("Random Word")
                    .font(.system(size: 50))
                Spacer()
                
                Text("""
                    In here, you will get a random word. You should provide an example and a description for it.
                    Press "New Word" to start and to change the word provided.
                    """)
                    .font(.system(size: 25))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                    .offset(y: -150)
                Spacer()
                
                Button("New Word") {
                    updateWord(colorArray: colorArray)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.black)
                
                Spacer()
                
                Button("Submit Word") {
                    if (considerExample(word: newWord, example: newExample)) {
                        validExample = true
                        wordAdded = true
                        let newWord = Word(wordInit: newWord.capitalized, exampleInit: newExample, descriptionInit: newDefinition, date: formattedDateAmericanStyle(from: Date.now), source: "Random") // Create object
                        context.insert(newWord) // Insert object to context
                        wordAdded = true
                        
                        do {
                            try context.save()
                            print("SAVE")
                        }
                        catch {
                            print("Error saving context: \(error)")
                        }
                        
                        print("The word was saved")
                        updateWord(colorArray: colorArray)
                    }
                    else {
                        validExample = false
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: -10) {
                Text(newWord.capitalized)
                    .font(.system(size: 40))
                    .foregroundColor(randomWordColor)
                    .offset(y: -10)
                    .opacity(wordOpacity) // Bind opacity to the state variable
                    .underline(true)
                
                // Example TextField
                TextField("Example", text: $newExample)
                    .padding()
                    .disableAutocorrection(true)
                    .background(
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(height: 50)
                            .cornerRadius(10)
                    )
                    .font(.system(size: 30))
                    .offset(x: 50)
                
                // Description TextField
                TextField("Description", text: $newDefinition)
                    .padding()
                    .disableAutocorrection(true)
                    .background(
                        Rectangle()
                            .foregroundColor(.orange)
                            .frame(height: 50)
                            .cornerRadius(10)
                    )
                    .font(.system(size: 30))
                    .offset(x: 50)
                
                Text(validExample ? "" : """
                    The example does not utilize the word
                    """)
                .frame(width: 500)
                .frame(height: 50)
                
                Text(wordAdded ? """
                    The word was successfully added!
                    """ : "")
                .frame(width: 500)
                .frame(height: 50)
            }
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

struct SeeWordsPage: View {
    @Query private var words: [Word]
    @Environment(\.modelContext) var context
    @State private var wordEdit: Word?
    @State private var opacityRatio: Double = 1.0
    @State private var typeColor: Color = .blue
    
    var body: some View {
        if (words.count != 0){
            NavigationStack {
                List{
                    Section() {
                        Image("backgroundSee")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350, height: 200, alignment: .center)
                    }
                    .listSectionSpacing(.compact)
                    Section {
                        HStack {
                            Spacer()
                            Text("Word")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                            Text("Date")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 5)
                        .padding()
                    }
                    .listSectionSpacing(.compact)
                    .listRowBackground(
                        Capsule()
                            .fill(.white)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                            .padding()
                    )
                    ForEach(Array(words.enumerated()), id: \.offset) { index, word in
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
                    .onDelete{
                        indexSet in
                        for index in indexSet{
                            context.delete(words[index])
                            try! context.save()
                        }
                    }
                }
                .navigationTitle("Words Added")
                .navigationBarTitleDisplayMode(.large)
                .sheet(item:$wordEdit){
                    word in UpdateWordSheet(word: word)
                }
            }
        }
        else{
            VStack (spacing: 25){
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 100))
                Text("""
                    It seems like you haven't added any words yet.
                    You can click "Add Word" in the main menu to start.
                    """)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 20)
                    .offset(x: 10)
            }
        }
    }
    
    func setColor(source: String) -> Color{
        
//        let blue = Color(red: 0.04, green: 1.0, blue: 1.0)
        let argentinianBlue = Color(red: 0.376, green: 0.686, blue: 1.0)
        let deepSkyBlue = Color(red: 0.156, green: 0.76, blue: 1.0)
//        let aqua = Color(red: 0.164, green: 0.96, blue: 1.0)
        let celeste = Color(red: 0.725, green: 0.98, blue: 0.97)
        
        if (source == "Added"){
            return argentinianBlue
        }
        else if (source == "Random"){
            return deepSkyBlue
        }
        else{
            return celeste
        }
    }
}

struct Collection: Codable {
    let title: String
    let description: String
    let wordSet: [String]
}

struct CollectionPage: View, getAmericanDate {
    @Query private var words: [Word]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
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
            GeometryReader { _ in
                Circle()
                    .offset(x: -200, y: -300)
                    .frame(width: 900, height: 740)
                    .foregroundColor(Color.purple.opacity(0.2))
            }
            .edgesIgnoringSafeArea(.all)
            if (currentWord == "No more words"){
                VStack (spacing: 25){
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 100))
                    Text("""
                        You have learned all words from this collection
                        Congratulations!
                        """)
                        .font(.system(size: 25))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.trailing, 20)
                        .offset(x: 10)
                }
            }
            else if (!currentWord.isEmpty) {
                VStack {
                    // Title and descriptive text
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
                    
                    // Form Section
                    VStack(spacing: 25) {
                        // Word display
                        Text(currentWord)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(height: 55)
                            )
                            .font(.system(size: 32))
                            .padding(.horizontal, 20)
                        
                        // Example input
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
                        
                        // Description input
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
                        
                        // Submit Button
                        Button("Submit Word") {
                            handleWordSubmission()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!isFormValid)
                        
                        // Messages
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
            }
            else {
                // Loading State
                VStack {
                    Text("Loading...")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .onAppear {
            initializeWords()
        }
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

    // Handle word submission
    private func handleWordSubmission() {
        guard !currentWord.isEmpty, considerExample(word: currentWord, example: example) else {
            validExample = false
            return
        }
        
        validExample = true
        let newWord = Word(
            wordInit: currentWord.capitalized,
            exampleInit: example,
            descriptionInit: description,
            date: formattedDateAmericanStyle(from: Date()),
            source: self.title
        )
        
        context.insert(newWord)
        
        do {
            try context.save()
            wordAdded = true
            updateNextWord()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    // Update to the next word
    private func updateNextWord() {
        newWords.removeFirst()
        currentWord = newWords.first ?? "No more words"
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
    
    let wordBack = Color(red: 0.81, green: 0.73, blue: 0.89)
    let exampleBack = Color(red: 0.83, green: 0.75, blue: 0.89)
    let descriptionBack = Color(red: 0.81, green: 0.73, blue: 1)
    let logoColor = Color(red: 0.90, green: 0.92, blue: 1)
    
    var isFormValid: Bool {
        return !word.isEmpty && !example.isEmpty && !description.isEmpty
    }

    var body: some View {
        ZStack{
            GeometryReader { geometry in
                Circle()
                    .offset(x: -300, y: -400)
                    .frame(width: 1000, height: 820)
                    .foregroundColor(logoColor)
            }
            .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Add Word")
                    .font(.system(size: 50))
                Text("In here you can add new words to your vocabulary.")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                Text("Provide a short description and an example for every word. This is made to ensure you understand the words you are adding.")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 20)
                Spacer()
                VStack(spacing: 20){
                    TextField(
                        "Word",
                        text: $word
                    )
                    .disableAutocorrection(true)
                    .background(
                        Rectangle()
                            .foregroundColor(wordBack)
                            .frame(height: 50)
                            .offset(x: -50)
                    )
                    .font(.system(size: 30))
                    
                    TextField(
                        "Example",
                        text: $example
                    )
                    .disableAutocorrection(true)
                    .background(
                        Rectangle()
                            .foregroundColor(exampleBack)
                            .frame(height: 50)
                            .offset(x: -50)
                    )
                    .font(.system(size: 30))
                    
                    TextField(
                        "Description",
                        text: $description
                    )
                    .disableAutocorrection(true)
                    .background(
                        Rectangle()
                            .foregroundColor(descriptionBack)
                            .frame(height: 50)
                            .offset(x: -50)
                    )
                    .font(.system(size: 30))
                    
                    Button("Submit Word") {
                        if (considerExample(word: word, example: example)){
                            considerWord(word: word)
                            validExample = true
                        }
                        else{
                            validExample = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                    
                    Text(validWord ? "" : """
                        The given word does not seem to be valid
                        Please check if you have typed it correctly and try again
                        """)
                    Text(validExample ? "" : """
                        The example does not utilize the word
                        """)
                    Text(wordAdded ? """
                        The word was sucessufuly added!
                        """ : "")
                    .multilineTextAlignment(.center)
                }
                .offset(x: 20)
                .padding(.trailing, 50)
                
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

    func isWordInFile(word: String, description: String, example: String) -> Void {
        let fileName = "words_alpha"
        let fileType = "txt"
        // Locating the file in the app bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("File not found in the bundle")
            return
        }
        
        // Reading the contents of the file
        do {
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Searching for the word in the file content
            if fileContents.contains(word) {
                print("The word '\(word)' was found in the file.")
                let newWord = Word(wordInit: word.capitalized, exampleInit: example, descriptionInit: description, date:formattedDateAmericanStyle(from: Date.now), source: "Added") // Create object
                context.insert(newWord) // Insert object to context
                wordAdded = true
                do {
                    try context.save()
                    print("SAVE")
                }
                catch {
                    print("Error saving context: \(error)")
                }
//                dismiss()  Dismiss context
                print("The word was saved")
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
