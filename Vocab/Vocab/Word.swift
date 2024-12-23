//
//  Word.swift
//  Vocab
//
//  Created by Bruno Gomes Pascotto on 12/18/24.
//

import Foundation
import SwiftData

@Model
class Word{
    @Attribute(.unique) var word: String
    var example: String
    var wordDescription: String
    var dateAdded: String
    var source: String
    var translation: String?
    
    init(wordInit: String, exampleInit: String, descriptionInit: String, date: String, source: String, translation: String?) {
        self.word               = wordInit
        self.example            = exampleInit
        self.wordDescription    = descriptionInit
        self.dateAdded          = date
        self.source             = source
    }
}

// Possible Sources:
// Random: QuizPage, randomly added word
// User: AddWordPage, added by the user
// <Collection>: Collections Page, whatever collection the word came from
