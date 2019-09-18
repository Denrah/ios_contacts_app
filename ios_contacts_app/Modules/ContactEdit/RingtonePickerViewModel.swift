//
//  RingtonePickerViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol RingtonePickerViewModelDelegate: class {
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel,
                               didSelected ringtone: String)
}

class RingtonePickerViewModel {
  let data = Dynamic<[String]>(nil)
  weak var delegate: RingtonePickerViewModelDelegate?
  
  func ringtonePickerView(didSelected ringtone: String) {
    delegate?.ringtonePickerViewModel(self, didSelected: ringtone)
  }
}
