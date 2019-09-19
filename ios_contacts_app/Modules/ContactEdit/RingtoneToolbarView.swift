//
//  RingtoneToolbarView.swift
//  ios_contacts_app
//

import UIKit
import SnapKit

class RingtoneToolbarView: UIToolbar {
  private let viewModel: RingtoneToolbarViewModel
  
  // MARK: - View setup
  
  init(viewModel: RingtoneToolbarViewModel) {
    let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    self.viewModel = viewModel
    super.init(frame: frame)
    setupToolbar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupToolbar() {
    autoresizingMask = .flexibleHeight
    barStyle = .default
    barTintColor = UIColor.defaultGray
    backgroundColor = UIColor.defaultGray
    isTranslucent = false
    
    let bottomBorder = UIView()
    bottomBorder.backgroundColor = UIColor.borderGray
    addSubview(bottomBorder)
    bottomBorder.snp.makeConstraints { make in
      make.top.equalTo(43)
      make.height.equalTo(1)
      make.left.right.equalTo(0)
    }
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButton))
    doneButton.tintColor = tintColor
    
    items = [flexSpace, doneButton]
  }
  
  // MARK: - Button press handling
  
  @objc private func onDoneButton() {
    viewModel.onDoneButton()
  }
}
