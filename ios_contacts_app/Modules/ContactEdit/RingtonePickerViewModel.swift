//
//  RingtonePickerViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol RingtonePickerViewModelDelegate: class {
  func ringtonePickerViewModel(didSelected ringtone: String)
}

class RingtonePickerViewModel {
  let data = Dynamic<[String]>(nil)
  weak var delegate: RingtonePickerViewModelDelegate?
  
  init(delegate: RingtonePickerViewModelDelegate) {
    self.delegate = delegate
  }
  
  func ringtonePickerView(didSelected ringtone: String) {
    delegate?.ringtonePickerViewModel(didSelected: ringtone)
  }
}
