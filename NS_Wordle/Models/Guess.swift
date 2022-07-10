//
//  Guess.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI


struct Guess {
    let index: Int
    
    var word = "     "
    
    var bgColors = [Color](repeating: .wrong, count: 5)
    
    var cardsFlipped = [Bool](repeating: false, count: 5)
    
    var guessLetters: [String] {
        word.map { c in
            String(c)
        }
    }
}
