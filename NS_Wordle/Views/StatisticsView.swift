//
//  StatisticsView.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-20.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var viewModel: WordleViewModel
    var body: some View {
        let stats = viewModel.statistics
        VStack() {
            Spacer()
            HStack(alignment: .top) {
                Spacer()
                Button {
                    viewModel.showStats.toggle()
                } label: {
                    Text("X")
                }
            }
            Text("STATISTICS")
                .font(.headline)
                .fontWeight(.bold)
            HStack(alignment: .top) {
                SingleStat(value: stats.gamesPlayed, text: "Played")
                if stats.gamesPlayed != 0 {
                    SingleStat(value: Int(100 * stats.wins / stats.gamesPlayed) , text: "Win %")
                }
                SingleStat(value: stats.streak, text: "Current Streak")
                    .fixedSize(horizontal: false, vertical: true)
                SingleStat(value: stats.maxStreak, text: "Max Streak")
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            Text("GUESS DISTRIBUTION")
                .font(.headline)
                .fontWeight(.bold)
            VStack(spacing: 5) {
                ForEach(0 ..< Global.NUM_GUESSES, id: \.self) { i in
                    HStack {
                        Text("\(i+1)")
                            .frame(width: 20, height: 20, alignment: .center)
                        if stats.frequencies[i] == 0 {
                            Rectangle()
                                .fill(Color.wrong)
                                .frame(width: 22, height: 20)
                                .overlay(
                                    Text("0")
                                        .foregroundColor(.white)
                                )
                        } else {
                            if let maxValue = stats.frequencies.max() {
                                Rectangle()
                                    .fill(viewModel.currentRow == i && viewModel.gameOver ? Color.correct : Color.wrong)
                                    .frame(width: CGFloat(stats.frequencies[i]) / CGFloat(maxValue) * 210, height: 20)
                                    .overlay(
                                        Text("\(stats.frequencies[i])")
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 5),
                                        alignment: .trailing
                                        
                                    )
                                
                            }
                        }
                        Spacer()
                    }
                }
                if viewModel.gameOver {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.shareResult()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.correct)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(width: 320, height: 370)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.secondary)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.systemBackground))
        )
        .padding()
        .shadow(color: .black.opacity(0.3), radius: 10)
        .offset(y: -70)
    }
}

struct SingleStat: View {
    let value: Int
    let text: String
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.largeTitle)
            
            Text(text)
                .font(.caption)
                .frame(width: 50)
                .multilineTextAlignment(.center)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var viewModel = WordleViewModel()
    static var previews: some View {
        StatisticsView()
            .environmentObject(
                { () -> WordleViewModel in
                    let viewModel = WordleViewModel()
                    viewModel.gameOver = true
                    return viewModel
                }()
            )
    }
}
