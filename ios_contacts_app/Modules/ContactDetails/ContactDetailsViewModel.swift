//
//  ContactDetailsViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactDetailsViewModelDelegate: class {
  func contactDetailsViewModelDidFinish(_ viewModel: ContactDetailsViewModel)
}

class ContactDetailsViewModel {
  weak var delegate: ContactDetailsViewModelDelegate?
  private let storageService: StorageService
  private let contactId: String
  
  let contactName = Dynamic<String>(nil)
  let phoneNumber = Dynamic<String>(nil)
  let ringtone = Dynamic<String>(nil)
  let notes = Dynamic<String>(nil)
  let contactImage = Dynamic<UIImage>(nil)
  
  init(storageService: StorageService, contactId: String) {
    self.storageService = storageService
    self.contactId = contactId
    
    getContact()
  }
  
  func getContact() {
    let result = storageService.getContact(contactId: contactId)
    switch result {
    case .success(let contact):
      contactName.value = "\(contact.firstName) \(contact.lastName)"
      phoneNumber.value = contact.phoneNumber
      ringtone.value = contact.ringtone
      notes.value = contact.notes
      contactImage.value = contact.image
    case .failure(let error):
      print(error)
    }
  }
  
  func didTapPhoneNumber() {
    guard let phoneNumber = phoneNumber.value?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    guard let number = URL(string: "tel:" + phoneNumber) else { return }
    UIApplication.shared.open(number, options: [:], completionHandler: nil)
  }
  
  func goBack() {
    delegate?.contactDetailsViewModelDidFinish(self)
  }
}
