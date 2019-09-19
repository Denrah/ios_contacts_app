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
  
  var ringtonePickerView: RingtonePickerView?
  var ringtonePickerToolbar: UIToolbar?
  
  let selectedRingtone = Dynamic<String>(nil)
  let ringtoneService: RingtoneService
  let ringtoneIsEditing = Dynamic<Bool>(false)
  let selectedImage = Dynamic<UIImage>(nil)
  let imagePickerError = Dynamic<Error>(nil)
  
  var ringtones: [String]?
  
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
    ringtonePickerView = RingtonePickerView(viewModel: ringtonePickerViewModel)
    ringtonePickerToolbar = RingtoneToolbarView(viewModel: ringtoneToolbarViewModel)
    getRingtones()
  }
  
  private func getRingtones() {
    selectedRingtone.value = ringtoneService.getDefaultRingtone()
    ringtonePickerViewModel.ringtones = ringtoneService.getRingtones()
    ringtonePickerView?.update(viewModel: ringtonePickerViewModel)
  }
  
  func chooseImage(sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      delegate?.contactEditViewModelDidRequestedChooseImage(self, sourceType: sourceType)
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
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel, didSelect ringtone: String) {
    selectedRingtone.value = ringtone
  }
}
