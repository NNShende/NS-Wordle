//
//  GuessView.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

struct GuessView: View {
    
    @Binding var guess: Guess
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0 ..< Global.WORD_SIZE,  id: \.self) { i in
                FlipView(
                    isFlipped: $guess.cardsFlipped[i]) {
                        Text(guess.guessLetters[i])
                            .foregroundColor(.primary)
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                            .background(Color.systemBackground)
                    } back: {
                        Text(guess.guessLetters[i])
                            .foregroundColor(.white)
                            .frame(
                                minWidth: 0,
                                maxWidth: .infinity,
                                minHeight: 0,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                            .background(guess.bgColors[i])
                    }
                    .font(.system(size: 35, weight: .heavy))
                    .border(Color(.secondaryLabel))
            }
        }
    }
}

struct GuessView_Previews: PreviewProvider {
    static var previews: some View {
        GuessView(guess: .constant(Guess(index: 0)))
    }
}
