//
//  UIColor+Hex.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/30.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    //let color = UIColor.random でランダムな色を返す
    class var random: UIColor {
        let rgb = (0..<3).map { _ -> CGFloat in
            return CGFloat(arc4random_uniform(255)) / 255
        }
        return UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1.0)
    }
}
