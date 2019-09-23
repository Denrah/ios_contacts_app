//
//  RingtoneToolbarViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol RingtoneToolbarViewModelDelegate: class {
  func ringtoneViewModelDidTapDone(_ viewModel: RingtoneToolbarViewModel)
}

class RingtoneToolbarViewModel {
  weak var delegate: RingtoneToolbarViewModelDelegate?
  
  func didTapDone() {
    delegate?.ringtoneViewModelDidTapDone(self)
  }
}
