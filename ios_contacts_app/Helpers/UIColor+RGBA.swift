//
//  UIColor+RGBA.swift
//  ios_contacts_app
//

import UIKit

extension UIColor {
  convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, forBig: Bool) {
    self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
  }
}
