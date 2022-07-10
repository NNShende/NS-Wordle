//
//  KeyboardView.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var viewModel: WordleViewModel
    
    var topRowArray = "QWERTYUIOP".map { String($0) }
    var midRowArray = "ASDFGHJKL".map { String($0) }
    var botRowArray = "ZXCVBNM".map { String($0) }
    
    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(topRowArray, id: \.self) {
                    letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(viewModel.disabledLetters)
                .opacity(viewModel.disabledLetters ? 0.6 : 1)
            }
            
            HStack(spacing: 2) {
                ForEach(midRowArray, id: \.self) {
                    letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(viewModel.disabledLetters)
                .opacity(viewModel.disabledLetters ? 0.6 : 1)
            }
            
            HStack(spacing: 2) {
                Button {
                    viewModel.enterWord()
                } label: {
                    Text("Enter")
                }
                .font(.system(size: 20))
                .frame(width: 60, height: 50)
                .foregroundColor(.primary)
                .background(Color.unused)
                .disabled(viewModel.disabledEnterButton)
                .opacity(viewModel.disabledEnterButton  ? 0.6 : 1)
                
                ForEach(botRowArray, id: \.self) {
                    letter in
                    LetterButtonView(letter: letter)
                }
                .disabled(viewModel.disabledLetters)
                .opacity(viewModel.disabledLetters ? 0.6 : 1)
                
                Button {
                    viewModel.removeLetter()
                } label: {
                    Image(systemName: "delete.backward.fill")
                        .font(.system(size: 20, weight: .heavy))
                        .frame(width: 40, height: 50)
                        .foregroundColor(.primary)
                        .background(Color.unused)
                        .disabled(viewModel.disabledBackSpace)
                        .opacity(viewModel.disabledBackSpace  ? 0.6 : 1)

                }
            }
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView()
            .environmentObject(WordleViewModel())
            .scaleEffect(Global.keyboardScale)
    }
}
