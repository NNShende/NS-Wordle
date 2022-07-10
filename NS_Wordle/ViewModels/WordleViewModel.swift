//
//  WordleDataModel.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

class WordleViewModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int] (repeating: 0, count: 6)
    
    var keyColors = [String : Color]()
    
    var selectedWordFromBank = ""
    var currentWord = ""
    var currentRow = 0
    
    var inPlay = false
    
    var gameStarted: Bool {
        !currentWord.isEmpty || currentRow > 0
    }
    
    var disabledLetters: Bool {
        !inPlay || currentWord.count >= Global.WORD_SIZE
    }
    
    var disabledBackSpace: Bool {
            !inPlay || currentWord.count == 5
    }
    
    var disabledEnterButton: Bool {
        !inPlay || currentWord.count < 5
    }
    
    
    init() {
        newGame()
    }
    
    func newGame() {
        populateDefaults()
        selectedWordFromBank = Global.wordBank.randomElement()!
        currentWord = ""
        
        inPlay = true
    }
    
    func populateDefaults() {
        guesses = []
        for i in 0..<Global.NUM_GUESSES {
            guesses.append(Guess(index: i))
        }
        
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused 
        }
    }
    
    func addLetterToCurrentWord(letter: String) {
        currentWord += letter
        
        updateRow()
    }
    
    func enterWord() {
        if verifyWord() {
            print("valid word")
        } else {
            withAnimation {
                self.incorrectAttempts[currentRow] += 1
            }
            self.incorrectAttempts[currentRow] = 0
        }
    }
    
    func removeLetter() {
        currentWord.removeLast()
        
        updateRow()
    }
    
    func updateRow() {
        let guessWord = currentWord.padding(toLength: Global.WORD_SIZE, withPad: " ", startingAt: 0)
        guesses[currentRow].word = guessWord
    }

    func verifyWord() -> Bool {
        return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord )
    }
}
