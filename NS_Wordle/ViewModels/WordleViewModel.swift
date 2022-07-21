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
    @Published var toastText: String?
    @Published var showStats = false
    @AppStorage("hardMode") var hardMode = false
    
    var keyColors = [String : Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var correctlyPlacedLetters = [String]()
    
    var selectedWordFromBank = ""
    var currentWord = ""
    var currentRow = 0
    
    var inPlay = false
    var gameOver = false
    
    let winWords = ["Rare W", "Noice", "Now that was epic"]
    let loseWords = ["L + Ratio", "Owned", "Mickey Mouse Player"]
    
    var statistics: Statistics
    
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
        statistics = Statistics.load()
        newGame()
    }
    
    func newGame() {
        populateDefaults()
        selectedWordFromBank = Global.wordBank.randomElement()!
        correctlyPlacedLetters = [String](repeating: "-", count: Global.WORD_SIZE)
        currentWord = ""
        
        inPlay = true
        currentRow = 0
        gameOver = false
        MyLogger.debug(msg: selectedWordFromBank)
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
            MyLogger.debug(msg: "You win!")
            showToast(with: winWords.randomElement()!)
            setCurrentGuessColors()
            inPlay = false
            statistics.update(win: true, index: currentRow)
        } else {
            if verifyWord() {
                MyLogger.debug(msg: "valid word \(currentWord)")
                if hardMode {
                    if let toastString = hardCorrectCheck() {
                        shakeWord(row: currentRow)
                        showToast(with: toastString)
                        return
                    }
                    if let toastString = hardMisplacedCheck() {
                        shakeWord(row: currentRow)
                        showToast(with: toastString)
                        return
                    }
                }
                setCurrentGuessColors()
                currentRow += 1
                currentWord = ""
                if currentRow == 6 {
                    gameOver = true
                    inPlay = false
                    MyLogger.debug(msg: "You lose")
                    showToast(with: String(format: "%@. The correct word was: %@.", loseWords.randomElement()!, selectedWordFromBank))
                    statistics.update(win: false)
                }
            } else {
                shakeWord(row: currentRow)
                showToast(with: "Not a word")
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
    
    func hardCorrectCheck() -> String? {
        let guessLetters = guesses[currentRow].guessLetters
        for i in 0 ..< Global.WORD_SIZE {
            if correctlyPlacedLetters[i] != "-" && guessLetters[i] != correctlyPlacedLetters[i] {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                return "\(formatter.string(for: i + 1)!) letter must be \(correctlyPlacedLetters[i])"
            }
        }
        return nil
    }
    
    func hardMisplacedCheck() -> String? {
        let guessLetters = guesses[currentRow].guessLetters
        for letter in guessLetters {
            if !guessLetters.contains(letter) {
                return "Must contain the letter '\(letter)'"
            }
        }
        return nil
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
                correctlyPlacedLetters[index] = correctLetter
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
    
    func showToast(with text: String) {
        withAnimation {
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3)) {
            toastText = nil
            if gameOver {
                withAnimation(Animation.linear(duration: 0.2).delay(3)) {
                    showStats.toggle()
                }
            }
        }
    }
    
    func shareResult() {
        let stat = Statistics.load()
        var resultString = "Wordle \(stat.gamesPlayed) "
        resultString += currentRow < Global.NUM_GUESSES ? "\(currentRow)" : "X"
        resultString += "/"
        resultString += "\(Global.NUM_GUESSES)\n"
        resultString += guesses.compactMap { $0.results }.joined(separator: "\n")
        
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2, y: Global.screenHeight / 2, width: 200, height: 200)
            UIWindow.key?.rootViewController?.present(activityController, animated: true)
        default:
            break
        }
    }
    
    func shakeWord(row: Int) {
        withAnimation {
            self.incorrectAttempts[row] += 1
        }
        self.incorrectAttempts[row] = 0
    }
}
