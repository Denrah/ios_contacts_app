//
//  RingtoneToolbarViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol RingtoneToolbarViewModelDelegate: class {
  func ringtoneViewModelDidTapDoneButton()
}

class RingtoneToolbarViewModel {
  weak var delegate: RingtoneToolbarViewModelDelegate?
  
  init(delegate: RingtoneToolbarViewModelDelegate) {
    self.delegate = delegate
  }
  
  func ringtoneToolbarDidTapDoneButton() {
    delegate?.ringtoneViewModelDidTapDoneButton()
  }
}
