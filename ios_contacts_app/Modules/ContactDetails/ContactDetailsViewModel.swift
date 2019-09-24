//
//  ContactDetailsViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol ContactDetailsViewModelDelegate: class {
  func contactDetailsViewModelDidFinish(_ viewModel: ContactDetailsViewModel)
}

class ContactDetailsViewModel {
  weak var delegate: ContactDetailsViewModelDelegate?
  private let storageService: StorageService
  private let contactId: String
  
  let contactName = Dynamic<String>(nil)
  
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
    case .failure(let error):
      print(error)
    }
  }
  
  func goBack() {
    delegate?.contactDetailsViewModelDidFinish(self)
  }
}
