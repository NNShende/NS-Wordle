//
//  UIWindow+Extension.swift
//  NS_Wordle
//
//  Created by Nikhil Shende on 2022-07-20.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDeleegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDeleegate.window
        else {
            return nil
        }
        return window
    }
}
