//
//  RingtoneToolbarView.swift
//  ios_contacts_app
//

import UIKit

class RingtoneToolbarView: UIToolbar {
  init() {
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    frame.size.height = 44.0
    super.init(frame: frame)
    
    self.autoresizingMask = .flexibleHeight
    
    self.barStyle = .default
    self.barTintColor = UIColor.defaultGray
    self.backgroundColor = UIColor.defaultGray
    self.isTranslucent = false
    
    self.frame = frame
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
    doneButton.tintColor = self.tintColor
    
    self.items = [flexSpace, doneButton]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
