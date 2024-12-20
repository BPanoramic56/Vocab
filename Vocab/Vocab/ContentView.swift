//
//  ContentView.swift
//  Vocab
//
//  Created by Bruno Gomes Pascotto on 12/17/24.
//

import SwiftUI
import Foundation
import SwiftData
import UIKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack{
                Text("Menu")
                    .font(Font.custom("Rockwell-Regular", size: 60, relativeTo: .title))
                    .background(
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(width: 2000, height: 125)
                            .offset(y: -30)
                    )
                Spacer()
                VStack(spacing: 10){
                    HStack(spacing: 10){
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: addWordPage()) {
                            Text("Add Word")
                                .font(.system(size: 30))
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: quizPage()) {
                            Text("Add Random Word")
                                .font(.system(size: 30))
                        }
                    }
                    HStack(spacing: 10){
                        Image(systemName: "magazine")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                        NavigationLink(destination: seeWordsPage()) {
                            Text("See Words")
                                .font(.system(size: 30))
                        }
                    }
                }
                Spacer()
                HStack(spacing: 40){
                    NavigationLink(destination: profilePage()) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
        }
    }
}

struct profilePage: View {
    @Query private var words: [Word]
    
    var body: some View {
        Text("So far, you have added")
            .font(.system(size: 20))
        Text(String(words.count))
            .font(.system(size: 40))
        Text(words.count == 1 ? "word" : "words")
            .font(.system(size: 20))
    }
}

struct quizPage: View {
    @State var newWord: String = ""
    @State var newDefinition: String = ""
    @State var newExample: String = ""
    @State var wordOpacity = 1.0
    
    let blue = Color(red: 0.04, green: 0.0, blue: 1.0)
    let argentinianBlue = Color(red: 0.376, green: 0.686, blue: 1.0)
    let deepSkyBlue = Color(red: 0.156, green: 0.76, blue: 1.0)
    let aqua = Color(red: 0.164, green: 0.96, blue: 1.0)
    let celeste = Color(red: 0.725, green: 0.98, blue: 0.97)
    
    var body: some View {
        let colorArray = [blue, argentinianBlue, deepSkyBlue, aqua, celeste]
        
        let randomWordColor = colorArray.randomElement()
        
        ZStack{
            GeometryReader { geometry in
                Circle()
                    .offset(x: -300, y: -400)
                    .frame(width: 1000, height: 820)
                    .foregroundColor(celeste)
            }
            .edgesIgnoringSafeArea(.all)
            .offset(y: -150)
            VStack(spacing: 20){
                Text("Random Word")
                    .font(.system(size: 50))
                
                Text("""
                    In here, you will get a random word. You should provide an example and a description for it.
                    Press "New Word" to start and to change the word provided.
                    """)
                    .font(.system(size: 25))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Spacer()
                Button("New Word"){
                    updateWord()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.black)
            }
            VStack(spacing: 20){
                Text(newWord)
                    .font(.system(size: 40))
                    .foregroundColor(randomWordColor)
                    .offset(y: -10)
                    .opacity(wordOpacity) // Bind opacity to the state variable
                TextField(
                    "Example",
                    text: $newExample
                )
                .background(
                    Rectangle()
                        .foregroundColor(aqua)
                        .frame(height: 50)
                        .offset(x: -50)
                )
                .font(.system(size: 30))
                
                TextField(
                    "Description",
                    text: $newDefinition
                )
                .background(
                    Rectangle()
                        .foregroundColor(.yellow)
                        .frame(height: 50)
                        .offset(x: -50)
                )
                .font(.system(size: 30))
                
            }
        }
    }
    
    func updateWord() {
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
        } catch {
            // Handle any errors that might occur while reading the file
            print("Error reading file: \(error.localizedDescription)")
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
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                wordEdit = word
                            }
                            .listRowBackground(
                                Capsule()
                                    .fill(Color(white: 1, opacity: 0.8))
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
    ContentView()
}
