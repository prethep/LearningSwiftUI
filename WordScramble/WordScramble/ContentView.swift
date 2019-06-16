//
//  ContentView.swift
//  WordScramble
//
//  Created by PP on 16.06.19.
//  Copyright © 2019 PP. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @State private var currentWord = ""
    @State private var usedWords = [String]()
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField($newWord) {
                    // On commit closure
                    self.addNewWord()
                    UIApplication.shared.keyWindow?.endEditing(true)
                }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                List(usedWords.identified(by: \.self)) { word in
                    Text(word)
                }
            }
                .navigationBarTitle(Text(currentWord))
                .onAppear {
                    self.startGame()
                }
                .presentation($showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                currentWord = allWords.randomElement() ?? "silkworm"
                return
            }

        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func addNewWord() {
        let lowerAnswer = newWord.lowercased()
        guard isOriginal(word: lowerAnswer) else {
            wordError(title: "Word used alread", message: "Be more original")
            return
        }
        
        guard isPossible(word: lowerAnswer)  else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        usedWords.insert(lowerAnswer, at: 0)
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = currentWord.lowercased()
        for letter in word {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        // get length of string (objC compatible)
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
