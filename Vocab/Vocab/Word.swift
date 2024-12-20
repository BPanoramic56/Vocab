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
    
    init(wordInit: String, exampleInit: String, descriptionInit: String, date: String) {
        self.word = wordInit
        self.example = exampleInit
        self.wordDescription = descriptionInit
        self.dateAdded = date
    }
}
