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
  
  let ringtones = Dynamic<[String]>(nil)
  var numberOfRows: Int { return ringtones.value?.count ?? 0 }
  
  func selectRingtone(_ ringtone: String) {
    delegate?.ringtonePickerViewModel(self, didSelect: ringtone)
  }
}
