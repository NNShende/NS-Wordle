//
//  Logger.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-20.
//

import Foundation
import os

class MyLogger {
    public static func info(msg: String) {
        os_log(template, log: .default, type: .info, msg)
    }
    
    public static func debug(msg: String) {
        os_log(template, log: .default, type: .debug, msg)
    }
    
    
    public static func error(msg: String) {
        os_log(template, log: .default, type: .error, msg)
    }
    
    private static let template: StaticString = "NS_WORDLE - Logger: %@"
}
