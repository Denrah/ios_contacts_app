//
//  RingtonePickerViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol RingtonePickerViewModelDelegate: class {
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel,
                               didSelect ringtone: String)
}

class RingtonePickerViewModel {
  weak var delegate: RingtonePickerViewModelDelegate?
  
  var ringtones: [String]?
  var numberOfRows: Int { return ringtones?.count ?? 0 }
  
  func selectRingtone(ringtone: String) {
    delegate?.ringtonePickerViewModel(self, didSelect: ringtone)
  }
}
