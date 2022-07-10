//
//  LetterButton.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

struct LetterButtonView: View {
    @EnvironmentObject var viewModel: WordleViewModel
    
    var letter: String
    
    var body: some View {
        Button {
            viewModel.addLetterToCurrentWord(letter: letter)
        } label: {
            Text(letter)
                .font(.system(size: 20))
                .frame(width: 35, height: 50)
                .background(viewModel.keyColors[letter])
                .foregroundColor(.primary)
        }
        .buttonStyle(.plain)
    }
}

struct LetterButton_Previews: PreviewProvider {
    static var previews: some View {
        LetterButtonView(letter: "L")
            .environmentObject(WordleViewModel())
    }
}
