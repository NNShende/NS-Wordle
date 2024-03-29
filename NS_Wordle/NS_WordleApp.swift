//
//  NS_WordleApp.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

@main
struct NS_WordleApp: App {
    @StateObject var viewModel = WordleViewModel()
    @StateObject var csManager = ColorSchemeManager()
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(viewModel)
                .environmentObject(csManager)
                .onAppear {
                    csManager.applyColorScheme()
                }
        }
    }
}
