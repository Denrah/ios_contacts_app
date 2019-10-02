//
//  ContactDetailsViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactDetailsViewModelDelegate: class {
  func contactDetailsViewModelDidFinish(_ viewModel: ContactDetailsViewModel)
  func contactDetailsViewModelDidRequestShowEditContactScreen()
}

class ContactDetailsViewModel {
  typealias Dependencies = HasStorageService
  
  private let dependencies: Dependencies
  private let contactID: String
  
  // MARK: - Delegate
  
  weak var delegate: ContactDetailsViewModelDelegate?
  
  // MARK: - Contact fields
  
  let contactName = Dynamic<String>(nil)
  let phoneNumber = Dynamic<String>(nil)
  let ringtone = Dynamic<String>(nil)
  let notes = Dynamic<String>(nil)
  let contactImage = Dynamic<UIImage>(nil)
  let contactImagePlaceholder = Dynamic<String>(nil)
  
  // MARK: - Events handling
  
  var didReceiveError: ((Error) -> Void)?
  
  // MARK: - ViewController setup
  
  init(dependencies: Dependencies, contactID: String) {
    self.dependencies = dependencies
    self.contactID = contactID
    
    loadContact()
  }
  
  func loadContact() {
    let result = dependencies.storageService.getContact(contactID: contactID)
    switch result {
    case .success(let contact):
      contactName.value = "\(contact.firstName) \(contact.lastName)"
      phoneNumber.value = contact.phoneNumber
      ringtone.value = contact.ringtone
      notes.value = contact.notes
      contactImage.value = contact.image
      contactImagePlaceholder.value = "\(contact.firstName.prefix(1))\(contact.lastName.prefix(1))"
    case .failure(let error):
      print(error)
    }
  }
  
  // MARK: - ViewController events handling
  
  func didTapPhoneNumber() {
    guard let phoneNumber = phoneNumber.value?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
    guard let number = URL(string: "tel:" + phoneNumber) else { return }
    UIApplication.shared.open(number, options: [:], completionHandler: nil)
  }
  
  func close() {
    delegate?.contactDetailsViewModelDidFinish(self)
  }
  
  // MARK: - Navbar events handling
  
  @objc func didTapEdit() {
    delegate?.contactDetailsViewModelDidRequestShowEditContactScreen()
  }
}
