//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestedChooseImage(_ viewModel: ContactEditViewModel,
                                                   sourceType: UIImagePickerController.SourceType)
}

enum ContactsEditErrors: Error {
  case emptyFields
}

extension ContactsEditErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .emptyFields:
      return "Fields \"First name\", \"Last name\" and \"Phone\" can not be empty"
    }
  }
}

class ContactEditViewModel {
  weak var delegate: ContactEditViewModelDelegate?
  
  var ringtonePickerView: RingtonePickerView?
  var ringtonePickerToolbar: UIToolbar?
  
  let selectedRingtone = Dynamic<String>(nil)
  let ringtoneService: RingtoneService
  let ringtoneIsEditing = Dynamic<Bool>(false)
  let selectedImage = Dynamic<UIImage>(nil)
  let didRequestedSave = Dynamic<Bool>(false)
  let didError = Dynamic<Error>(nil)
  
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
  let imagePickerHelper = ImagePickerHelper()
  let storageService: StorageService
  
  init(ringtoneService: RingtoneService, storageService: StorageService) {
    self.ringtoneService = ringtoneService
    self.storageService = storageService
    ringtonePickerView = RingtonePickerView(viewModel: ringtonePickerViewModel)
    ringtonePickerToolbar = RingtoneToolbarView(viewModel: ringtoneToolbarViewModel)
    self.storageService = storageService
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
      didError.value = ImagePickerErrors.sourceNotAvaliable
      didError.value = ImagePickerErrors.sourceNotAvaliable
    }
  }
  
  func contactsEditViewControllerDidRequestedSave(firstName: String?, lastName: String?, phone: String?, notes: String?) {
    guard let firstName = firstName, !firstName.isEmpty,
      let lastName = lastName, !lastName.isEmpty,
      let phone = phone, !phone.isEmpty, let ringtone = selectedRingtone.value else {
      didError.value = ContactsEditErrors.emptyFields
      return
    }

    let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phone,
                          ringtone: ringtone, notes: notes, image: selectedImage.value)
    
    let result = storageService.saveContact(contact: contact)
    
    switch result {
    case .success:
      return
    case .failure(let error):
      didError.value = error
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

// MARK: - Navbar events handling

extension ContactEditViewModel: ContactEditCoordinatorDelegate {
  func contactEditCoordinatorDidTapDone() {
    didRequestedSave.value = true
  }
  
  func contactEditCoordinatorDidTapCancel() {
    // TODO: - Go to contacts
  }
}
