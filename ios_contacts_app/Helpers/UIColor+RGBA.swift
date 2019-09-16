//
//  UIColor+RGBA.swift
//  ios_contacts_app
//

import UIKit

extension UIColor {
  convenience init(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alphaValue: CGFloat) {
    self.init(red: redValue / 255, green: greenValue / 255, blue: blueValue / 255, alpha: alphaValue)
  }
}
