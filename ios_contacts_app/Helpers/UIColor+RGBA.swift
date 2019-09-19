//
//  UIColor+RGBA.swift
//  ios_contacts_app
//

import UIKit

extension UIColor {
  static func color(fromRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
    return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
  }
}
