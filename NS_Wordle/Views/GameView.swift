//
//  ContentView.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

struct GameView: View {
    
    @EnvironmentObject var viewModel: WordleViewModel
    @State var showSettings = false
    @State var showHelp = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Spacer()
                    VStack(spacing: 3) {
                        ForEach(0 ..< Global.NUM_GUESSES, id: \.self) { i in
                            GuessView(guess: $viewModel.guesses[i])
                                .modifier(
                                    Shake(
                                        animatableData: CGFloat(viewModel.incorrectAttempts[i])
                                    )
                                )
                        }
                    }
                    .frame(width: Global.boardWidth, height: 6 * Global.boardWidth / 5)
                    Spacer()
                    KeyboardView()
                        .scaleEffect(Global.keyboardScale)
                        .padding(.top)
                    Spacer()
                }
                .disabled(viewModel.showStats)
                .navigationBarTitleDisplayMode(.inline)
                .overlay(alignment: .top) {
                    if let toastText = viewModel.toastText {
                        ToastView(toastText: toastText)
                            .offset(y: 20)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Button {
                                viewModel.newGame()
                            } label: {
                                Image(systemName: "plus.circle")
                            }.disabled(viewModel.inPlay)
                            
                            Button {
                                showHelp.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle")
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("WORDLE")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(viewModel.hardMode ? Color(.systemRed) : .primary)
                            .minimumScaleFactor(0.5)
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                viewModel.showStats.toggle()
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                            
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape.fill")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showHelp) {
                    HelpView()
                }
            }
            if viewModel.showStats {
                StatisticsView()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleViewModel())
    }
}
