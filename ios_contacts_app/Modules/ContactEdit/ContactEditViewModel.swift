//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestChooseImage(_ viewModel: ContactEditViewModel,
                                                 sourceType: UIImagePickerController.SourceType)
  func contactEditViewModelDidRequestClose()
  func contactEditViewModelDidRequestedGobackAfterDelete()
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
  private let ringtoneService: RingtoneService
  private let storageService: StorageService
  private let contactID: String?
  
  // MARK: - Delegate
  
  weak var delegate: ContactEditViewModelDelegate?
  
  // MARK: - Fields values
  
  let selectedRingtone = Dynamic<String>(nil)
  let selectedImage = Dynamic<UIImage>(nil)
  let firstName = Dynamic<String>(nil)
  let lastName = Dynamic<String>(nil)
  let phoneNumber = Dynamic<String>(nil)
  let notes = Dynamic<String>(nil)
  let deleteButtonIsHidden = Dynamic<Bool>(true)
  
  // MARK: - Events handling
  
  var ringtonePickerDidTapDone: (() -> Void)?
  var didRequestSave: (() -> Void)?
  var didReceiveError: ((Error) -> Void)?
  
  // MARK: - Children views' viewModels
  
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
  
  // MARK: - ViewModel setup
  
  init(ringtoneService: RingtoneService, storageService: StorageService, contactID: String? = nil) {
    self.ringtoneService = ringtoneService
    self.storageService = storageService
    self.contactID = contactID
    prepareData()
  }
  
  private func prepareData() {
    getRingtones()
    
    if let contactID = contactID {
      let result = storageService.getContact(contactID: contactID)
      switch result {
      case .success(let contact):
        selectedImage.value = contact.image
        selectedRingtone.value = contact.ringtone
        firstName.value = contact.firstName
        lastName.value = contact.lastName
        phoneNumber.value = contact.phoneNumber
        notes.value = contact.notes
        deleteButtonIsHidden.value = false
      case .failure(let error):
        didReceiveError?(error)
      }
    }
  }
  
  private func getRingtones() {
    selectedRingtone.value = ringtoneService.getDefaultRingtone()
    ringtonePickerViewModel.ringtones.value = ringtoneService.getRingtones()
  }
  
  // MARK: - View events handling
  
  func chooseImage(sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      delegate?.contactEditViewModelDidRequestChooseImage(self, sourceType: sourceType)
    } else {
      didReceiveError?(ImagePickerError.sourceNotAvaliable)
    }
  }
  
  func saveContact(firstName: String?, lastName: String?, phone: String?, notes: String?) {
    guard let firstName = firstName, !firstName.isEmpty,
      let lastName = lastName, !lastName.isEmpty,
      let phone = phone, !phone.isEmpty, let ringtone = selectedRingtone.value else {
        didReceiveError?(ContactsEditErrors.emptyFields)
        return
    }
    
    let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phone,
                          ringtone: ringtone, notes: notes, image: selectedImage.value, id: contactID)
    
    let result = storageService.saveContact(contact)
    
    switch result {
    case .success:
      delegate?.contactEditViewModelDidRequestClose()
    case .failure(let error):
      didReceiveError?(error)
    }
  }
  
  func deleteContact() {
    guard let contactID = contactID else { return }
    let result = storageService.deleteContactByID(contactID)
    
    switch result {
    case .success:
      delegate?.contactEditViewModelDidRequestedGobackAfterDelete()
    case .failure(let error):
      didReceiveError?(error)
    }
  }
  
  // MARK: - Navbar events handling
  
  @objc func didTapDone() {
    didRequestSave?()
  }
  
  @objc func didTapCancel() {
    delegate?.contactEditViewModelDidRequestClose()
  }
}

extension ContactEditViewModel: RingtoneToolbarViewModelDelegate {
  func ringtoneViewModelDidTapDone(_ viewModel: RingtoneToolbarViewModel) {
    ringtonePickerDidTapDone?()
  }
}

extension ContactEditViewModel: RingtonePickerViewModelDelegate {
  func ringtonePickerViewModel(_ viewModel: RingtonePickerViewModel, didSelect ringtone: String) {
    selectedRingtone.value = ringtone
  }
}
