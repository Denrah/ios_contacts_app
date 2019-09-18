//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestedChoosePhoto(_ viewModel: ContactEditViewModel,
                                                   from sourceType: UIImagePickerController.SourceType)
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
  
  let selectedRingtone = Dynamic<String>(nil)
  let ringtones = Dynamic<[String]>(nil)
  let ringtoneIsEditing = Dynamic<Bool>(false)
  let selectedImage = Dynamic<UIImage>(nil)
  let didRequestedSave = Dynamic<Bool>(false)
  let didError = Dynamic<Error>(nil)
  
  let imagePickerHelper = ImagePickerHelper()
  let ringtoneService: RingtoneService
  let storageService: StorageService
  
  init(ringtoneService: RingtoneService, storageService: StorageService) {
    self.ringtoneService = ringtoneService
    self.storageService = storageService
    getRingtones()
  }
  
  private func getRingtones() {
    selectedRingtone.value = ringtoneService.getDefaultRingtone()
    ringtones.value = ringtoneService.getRingtones()
  }
  
  func contactsEditViewControllerDidRequestedChoosePhoto(from sourceType: UIImagePickerController.SourceType) {
    if imagePickerHelper.isSourceTypeAvaliable(sourceType: sourceType) {
      delegate?.contactEditViewModelDidRequestedChoosePhoto(self, from: sourceType)
    } else {
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

// MARK: - Navbar events handling

extension ContactEditViewModel: ContactEditCoordinatorDelegate {
  func contactEditCoordinatorDidTapDone() {
    didRequestedSave.value = true
  }
  
  func contactEditCoordinatorDidTapCancel() {
    // TODO: - Go to contacts
  }
}
