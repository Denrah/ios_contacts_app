//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestedChooseImage(_ viewModel: ContactEditViewModel,
                                                   sourceType: UIImagePickerController.SourceType)
}

class ContactEditViewModel {
  weak var delegate: ContactEditViewModelDelegate?
  
  private let ringtoneService: RingtoneService
  
  let selectedRingtone = Dynamic<String>(nil)
  let ringtoneIsEditing = Dynamic<Bool>(false)
  let selectedImage = Dynamic<UIImage>(nil)
  let didReceiveError = Dynamic<Error>(nil)
  
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
    ringtonePickerViewModel.ringtones.value = ringtoneService.getRingtones()
  }
  
  func chooseImage(sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      delegate?.contactEditViewModelDidRequestedChooseImage(self, sourceType: sourceType)
    } else {
      didReceiveError.value = ImagePickerError.sourceNotAvaliable
    }
  }
}

// MARK: - Ringtone editing handling

extension ContactEditViewModel: RingtoneToolbarViewModelDelegate {
  func ringtoneViewModelDidTapDone(_ viewModel: RingtoneToolbarViewModel) {
    ringtoneIsEditing.value = false
  }
}

extension ContactEditViewModel: RingtonePickerViewModelDelegate {
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel, didSelect ringtone: String) {
    selectedRingtone.value = ringtone
  }
}
