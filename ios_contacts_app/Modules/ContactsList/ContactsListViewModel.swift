//
//  ContactsListViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol ContactsListViewModelDelegate: class {
}

class ContactsListViewModel {
  weak var delegate: ContactsListViewModelDelegate?
  
  let storageService: StorageService
  
  var contacts: [Contact]?
  
  init(storageService: StorageService) {
    self.storageService = storageService
    let result = storageService.getContacts()
    switch result {
    case .success(let contacts):
      self.contacts = contacts
      print(contacts)
    case .failure(let error):
      print(error)
    }
  }
}
