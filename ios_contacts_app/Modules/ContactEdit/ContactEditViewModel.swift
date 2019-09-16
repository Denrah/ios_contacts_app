//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactsEditViewModelDidRequestedChoosePhoto(from sourceType: UIImagePickerController.SourceType)
}

class ContactEditViewModel {
  weak var delegate: ContactEditViewModelDelegate?
  let selectedRingtone = Dynamic<String>(nil)
  let ringtones = Dynamic<[String]>(nil)
  let ringtoneService: RingtoneService
  let ringtoneIsEditing = Dynamic<Bool>(false)
  
  init(ringtoneService: RingtoneService) {
    self.ringtoneService = ringtoneService
    getRingtones()
  }
  
  private func getRingtones() {
    selectedRingtone.value = ringtoneService.getDefaultRingtone()
    ringtones.value = ringtoneService.getRingtones()
  }
  
  func contactsEditViewControllerDidRequestedChoosePhoto(from sourceType: UIImagePickerController.SourceType) {
    delegate?.contactsEditViewModelDidRequestedChoosePhoto(from: sourceType)
  }
}

extension ContactEditViewModel: RingtoneToolbarViewModelDelegate {
  func ringtoneViewModelDidTapDoneButton() {
    ringtoneIsEditing.value = false
  }
}

extension ContactEditViewModel: RingtonePickerViewModelDelegate {
  func ringtonePickerViewModel(didSelected ringtone: String) {
    selectedRingtone.value = ringtone
  }
}
