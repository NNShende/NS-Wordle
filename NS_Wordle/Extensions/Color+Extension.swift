//
//  Color+Extension.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-08.
//

import SwiftUI

extension Color {
    
    static var wrong: Color {
        Color(UIColor(named: "wrong")!)
    }
    
    static var misplaced: Color {
        Color(UIColor(named: "misplaced")!)
    }
    
    static var correct: Color {
        Color(UIColor(named: "correct")!)
    }
    
    static var unused: Color {
        Color(UIColor(named: "unused")!)
    }
    
    static var systemBackground: Color {
        Color(.systemBackground)
    }
}
