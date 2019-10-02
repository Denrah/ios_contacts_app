//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactEditViewModelDelegate: class {
  func contactEditViewModelDidRequestChooseImage(_ viewModel: ContactEditViewModel,
                                                 sourceType: UIImagePickerController.SourceType)
  func contactEditViewModelDidRequestClose()
  func contactEditViewModelDidDeleteContact()
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
  typealias Dependencies = HasStorageService & HasRingtoneService
  
  private let dependencies: Dependencies
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
  
  init(dependencies: Dependencies, contactID: String? = nil) {
    self.dependencies = dependencies
    self.contactID = contactID
    prepareData()
  }
  
  private func prepareData() {
    if let contactID = contactID {
      let result = dependencies.storageService.getContact(contactID: contactID)
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
    
    getRingtones()
  }
  
  private func getRingtones() {
    selectedRingtone.value = selectedRingtone.value ?? dependencies.ringtoneService.getDefaultRingtone()
    ringtonePickerViewModel.ringtones.value = dependencies.ringtoneService.getRingtones()
    ringtonePickerViewModel.setDefaultRingtone(selectedRingtone.value)
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
    
    let result = dependencies.storageService.saveContact(contact)
    
    switch result {
    case .success:
      delegate?.contactEditViewModelDidRequestClose()
    case .failure(let error):
      didReceiveError?(error)
    }
  }
  
  func deleteContact() {
    guard let contactID = contactID else { return }
    let result = dependencies.storageService.deleteContactByID(contactID)
    
    switch result {
    case .success:
      delegate?.contactEditViewModelDidDeleteContact()
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
