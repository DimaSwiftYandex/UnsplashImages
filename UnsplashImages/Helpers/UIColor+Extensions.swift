//
//  UIColor+Extensions.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 14.1.2024.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    static let ypBlack = UIColor(hex: 0x1A1B22)
    static let ypGray = UIColor(hex: 0xAEAFB4)
    static let ypBackground = UIColor(hex: 0x1A1B22, alpha: 0.5)
    static let ypWhite = UIColor(hex: 0xFFFFFF)
    static let ypWhiteAlpha50 = UIColor(hex: 0xFFFFFF, alpha: 0.5)
    static let ypRed = UIColor(hex: 0xF56B6C)
    static let ypBlue = UIColor(hex: 0x3772E7)
}
