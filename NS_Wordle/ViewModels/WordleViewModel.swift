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
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    
    var selectedWordFromBank = ""
    var currentWord = ""
    var currentRow = 0
    
    var inPlay = false
    var gameOver = false
    
    var gameStarted: Bool {
        !currentWord.isEmpty || currentRow > 0
    }
    
    var disabledLetters: Bool {
        !inPlay || currentWord.count >= Global.WORD_SIZE
    }
    
    var disabledBackSpace: Bool {
        !inPlay || currentWord.count == 0 || gameOver
    }
    
    var disabledEnterButton: Bool {
        !inPlay || currentWord.count < 5 || gameOver
    }
    
    
    init() {
        newGame()
    }
    
    func newGame() {
        populateDefaults()
        selectedWordFromBank = Global.wordBank.randomElement()!
        currentWord = ""
        
        inPlay = true
        currentRow = 0
        gameOver = false
        print(selectedWordFromBank)
    }
    
    func populateDefaults() {
        guesses = []
        for i in 0 ..< Global.NUM_GUESSES {
            guesses.append(Guess(index: i))
        }
        
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused
        }
        matchedLetters = []
        misplacedLetters = []
    }
    
    func addLetterToCurrentWord(letter: String) {
        currentWord += letter
        
        updateRow()
    }
    
    func enterWord() {
        if disabledEnterButton { return }
        if currentWord == selectedWordFromBank {
            gameOver = true
            print("You win!")
            setCurrentGuessColors()
            inPlay = false
        } else {
            if verifyWord() {
                print("valid word")
                setCurrentGuessColors()
                currentRow += 1
                currentWord = ""
                if currentRow == 6 {
                    gameOver = true
                    inPlay = false
                    print("You lose")
                }
            } else {
                withAnimation {
                    self.incorrectAttempts[currentRow] += 1
                }
                self.incorrectAttempts[currentRow] = 0
            }
        }
    }
    
    func removeLetter() {
        if disabledBackSpace { return }
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
    
    func setCurrentGuessColors() {
        let correctLetters = selectedWordFromBank.map { String($0) }
        var frequency = [String : Int]()
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }
        for index in 0 ..< Global.WORD_SIZE {
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[currentRow].guessLetters[index]
            if guessLetter == correctLetter {
                
                guesses[currentRow].bgColors[index] = .correct
                
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correct
                }
                
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}) {
                        misplacedLetters.remove(at: index)
                    }
                }
                
                frequency[guessLetter]! -= 1
            }
        }
        for index in 0 ..< Global.WORD_SIZE {
            let guessLetter = guesses[currentRow].guessLetters[index]
            if correctLetters.contains(guessLetter) && guesses[currentRow].bgColors[index] != .correct && frequency[guessLetter]! > 0 {
                
                guesses[currentRow].bgColors[index] = .misplaced
                
                if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter) {
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplaced
                }
                
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0 ..< Global.WORD_SIZE {
            let guessLetter = guesses[currentRow].guessLetters[index]
            if keyColors[guessLetter] != .correct && keyColors[guessLetter] != .misplaced {
                keyColors[guessLetter] = .wrong
            }
        }
        
        flipCards(for: currentRow)
    }
    
    func flipCards(for row: Int) {
        for col in 0 ..< Global.WORD_SIZE {
            DispatchQueue.main.asyncAfter(deadline:  .now() + Double(col) * Global.cardFlipDelay) {
                self.guesses[row].cardsFlipped[col].toggle()
            }
        }
    }
}
