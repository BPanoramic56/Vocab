//
//  VocabApp.swift
//  Vocab
//
//  Created by Bruno Gomes Pascotto on 12/17/24.
//

import SwiftUI

@main
struct VocabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Word.self ])
        }
    }
}
