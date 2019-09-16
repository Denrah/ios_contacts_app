//
//  RingtoneToolbarView.swift
//  ios_contacts_app
//

import UIKit

class RingtoneToolbarView: UIToolbar {
  var viewModel: RingtoneToolbarViewModel
  
  init(viewModel: RingtoneToolbarViewModel) {
    let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0)
    self.viewModel = viewModel
    
    super.init(frame: frame)
    
    self.autoresizingMask = .flexibleHeight
    
    self.barStyle = .default
    self.barTintColor = UIColor.defaultGray
    self.backgroundColor = UIColor.defaultGray
    self.isTranslucent = false
    
    self.frame = frame
    
    let bottomBorder = CALayer()
    
    bottomBorder.frame = CGRect(x: 0.0, y: 43.0, width: frame.width, height: 1.0)
    
    bottomBorder.backgroundColor = UIColor.borderGray.cgColor
    
    self.layer.addSublayer(bottomBorder)
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ringtoneToolbarDidTapDoneButton))
    doneButton.tintColor = self.tintColor
    
    self.items = [flexSpace, doneButton]
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func ringtoneToolbarDidTapDoneButton() {
    viewModel.ringtoneToolbarDidTapDoneButton()
  }
}
