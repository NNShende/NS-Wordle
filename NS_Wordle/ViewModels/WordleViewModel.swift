//
//  WordleDataModel.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

class WordleViewModel: ObservableObject {
    @Published var guesses: [Guess] = []
    
    @Published var keyColors = [String : Color]()
    
    init() {
        newGame()
    }
    
    func newGame() {
        populateDefaults()
    }
    
    func populateDefaults() {
        guesses = []
        for i in 0...5 {
            guesses.append(Guess(index: i))
        }
        
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused 
        }
    }
    
    func addLetterToCurrentWord(letter: String) {
        
    }
    
    func enterWord() {
        
    }
    
    func removeLetter() {
        
    }
}
