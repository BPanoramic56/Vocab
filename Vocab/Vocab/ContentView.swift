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
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                VStack(spacing: 10){
                    HStack(spacing: 10){
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        NavigationLink(destination: addWordPage()) {
                            Text("Add Word")
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        NavigationLink(destination: quizPage()) {
                            Text("Add Random Word")
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "magazine")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        NavigationLink(destination: seeWordsPage()) {
                            Text("See Words")
                        }
                    }
                }
                Spacer()
                HStack(spacing: 40){
                    NavigationLink(destination: profilePage()) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
        }
    }
}

struct profilePage: View {
    var body: some View {
        Text("New Place")
    }
}

struct quizPage: View {
    @State var newWord: String = ""
    @State var newDefinition: String = ""
    @State var newExample: String = ""
    let apiURL = "https://api.dictionaryapi.dev/api/v2/entries/en/"

    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                Circle()
                    .offset(x: -300, y: -400)
                    .frame(width: 1000, height: 820)
                    .foregroundColor(.blue)
            }
            .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Random Word")
                    .font(.system(size: 50))
                
                Text("In here, you will get a random word, with an example and it's description")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Text(newWord)
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Spacer()
                Button("New Word"){
                    print("New")
                    let wordList = readLinesFromFile()
                    let word: String = wordList.randomElement() ?? ""
                    print(wordList.count)
//                    let requestURL = apiURL + word
//                    Task {
//                        await newWord = randomWordFromFile(requestURL: requestURL)
//                    }
                }
                .buttonStyle(.bordered)
                .foregroundColor(.black)
            }
            .offset(y: -250)
        }
    }
    
    func readLinesFromFile() -> Array<String> {
        let fileName = "words_alpha"
        let fileType = "txt"
        var wordList: [String] = []
        // Locating the file in the app bundle
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("File not found in the bundle")
            return wordList
        }
        
        do {
            // Read the contents of the file
            let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Split the content into lines
            let lines = fileContents.split(separator: "\n")

            // Iterate through the lines
            for line in lines {
                wordList.append(String(line))
            }
            return wordList
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
        return wordList
    }


    func randomWordFromFile(requestURL: String) async -> String{
        do {
            let url = URL(string: requestURL)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            let output = "Found \(readings.count) readings"
            return output
        } catch {
            print("Download error")
        }
        return ""
    }
}

struct WordCell: View {
    var word: Word

    var body: some View {
        Text(word.word)
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
                TextField("Word", text: $word.word)
                TextField("Description", text: $word.wordDescription)
                TextField("Example", text: $word.example)
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

struct seeWordsPage: View {
    @Query private var words: [Word]
    @Environment(\.modelContext) var context
    @State private var wordEdit: Word?
    
    var body: some View {
        if (words.count != 0){
            NavigationStack {
                List{
                    ForEach(words){
                        word in WordCell(word: word)
                            .onTapGesture {
                                wordEdit = word
                            }
                    }
                    .onDelete{
                        indexSet in
                        for index in indexSet{
                            context.delete(words[index])
                            try! context.save()
                        }
                    }
                }
                .navigationTitle("Words")
                .navigationBarTitleDisplayMode(.large)
                .sheet(item:$wordEdit){
                    word in UpdateWordSheet(word: word)
                }
            }
        }
        else{
            VStack (spacing: 25){
                Image(systemName: "text.append")
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
}
    

struct addWordPage: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var word: String = ""
    @State private var example: String = ""
    @State private var description: String = ""
    @State var validWord = true;
    
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
                    .background(
                        Rectangle()
                            .foregroundColor(descriptionBack)
                            .frame(height: 50)
                            .offset(x: -50)
                    )
                    .font(.system(size: 30))
                    
                    Button("Submit Word") {
                        considerWord(word: word)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
                    
                    Text(validWord ? "" : """
                        The given word does not seem to be valid
                        Please check if you have typed it correctly and try again
                        """)
                }
                .offset(x: 20)
                .padding(.trailing, 50)
                
                Spacer()
            }
        }
    }
    
    func considerWord(word: String){
        print(isWordInFile(word:word.lowercased(), description:description, example:example))
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
                let newWord = Word(wordInit: word.capitalized, exampleInit: example, descriptionInit: description) // Create object
                context.insert(newWord) // Insert object to context
                do {
                    try context.save()
                    print("Context saved successfully")
                }
                catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
                dismiss() // Dismiss context
                print("The word was saved")
            }
            else {
                print("The word '\(word)' was NOT found in the file.")
                validWord = false
            }
        }
        catch {
            // Handle any errors that might occur while reading the file
            print("Error reading file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    quizPage()
}
