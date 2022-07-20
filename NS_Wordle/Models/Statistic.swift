//
//  Statistic.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-20.
//

import Foundation

struct Statistics: Codable {
    var frequencies = [Int] (repeating: 0, count: 6)
    var gamesPlayed = 0
    var streak = 0
    var maxStreak = 0
    
    var wins: Int {
        frequencies.reduce(0, +)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "Statistics")
        }
    }
    
    static func load() -> Statistics {
        if let saved = UserDefaults.standard.object(forKey: "Statistics") as? Data {
            if let currentStats = try? JSONDecoder().decode(Statistics.self, from: saved) {
                return currentStats
            } else {
                return Statistics()
            }
        } else {
            return Statistics()
        }
    }
    
    mutating func update(win: Bool, index: Int? = nil) {
        gamesPlayed += 1
        streak = win ? streak + 1 : 0
        if win {
            frequencies[index!] += 1
            maxStreak = max(maxStreak, streak)
        }
        save()
    }
}
