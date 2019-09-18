//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestedChoosePhoto(_ viewModel: ContactEditViewModel,
                                                   from sourceType: UIImagePickerController.SourceType)
}

class ContactEditViewModel {
  weak var delegate: ContactEditViewModelDelegate?
  let selectedRingtone = Dynamic<String>(nil)
  let ringtones = Dynamic<[String]>(nil)
  let ringtoneService: RingtoneService
  let ringtoneIsEditing = Dynamic<Bool>(false)
  let selectedImage = Dynamic<UIImage>(nil)
  let imagePickerError = Dynamic<Error>(nil)
  
  lazy var ringtonePickerViewModel: RingtonePickerViewModel = { [weak self] in
    let viewModel = RingtonePickerViewModel()
    viewModel.delegate = self
    return viewModel
  }()
  
  lazy var ringtoneToolbarViewModel: RingtoneToolbarViewModel = { [weak self] in
    let viewModel = RingtoneToolbarViewModel()
    viewModel.delegate = self
    return viewModel
  }()
  
  init(ringtoneService: RingtoneService) {
    self.ringtoneService = ringtoneService
    getRingtones()
  }
  
  private func getRingtones() {
    selectedRingtone.value = ringtoneService.getDefaultRingtone()
    ringtones.value = ringtoneService.getRingtones()
  }
  
  func contactsEditViewControllerDidRequestedChoosePhoto(from sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      delegate?.contactEditViewModelDidRequestedChoosePhoto(self, from: sourceType)
    } else {
      imagePickerError.value = ImagePickerError.sourceNotAvaliable
    }
  }
}

// MARK: - Ringtone editing handling

extension ContactEditViewModel: RingtoneToolbarViewModelDelegate {
  func ringtoneViewModelDidTapDoneButton(_ viewModel: RingtoneToolbarViewModel) {
    ringtoneIsEditing.value = false
  }
}

extension ContactEditViewModel: RingtonePickerViewModelDelegate {
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel, didSelected ringtone: String) {
    selectedRingtone.value = ringtone
  }
}
