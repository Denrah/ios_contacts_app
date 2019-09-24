//
//  ContactsListViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactsListViewModelDelegate: class {
}

class ContactsListViewModel {
  weak var delegate: ContactsListViewModelDelegate?
  
  let storageService: StorageService
  
  var sectionTitles: [String] = []
  private let collation = UILocalizedIndexedCollation.current()
  private var contactsWithSections = [[Contact]]()
  var contacts: [Contact] = []
  
  let didUpdate = Dynamic<Bool>(false)
  let didError = Dynamic<Error>(nil)

  var numberOfSections: Int {
    return contactsWithSections.count
  }
  
  init(storageService: StorageService) {
    self.storageService = storageService
    getContacts()
  }
  
  // MARK: - Loading contacts
  
  func getContacts() {
    let result = storageService.getContacts()
    switch result {
    case .success(let contacts):
      self.contacts = contacts
      updateContacts(contacts: contacts)
    case .failure(let error):
      didError.value = error
    }
  }
  
  func updateContacts(contacts: [Contact]) {
    let (contacts, titles) = collation.partitionObjects(array: contacts,
                                                        collationStringSelector: #selector(getter: Contact.lastName))
    guard let contactsWithSections = contacts as? [[Contact]] else {
      didError.value = AppError.contactsLoadFailed
      return
    }
    self.contactsWithSections = contactsWithSections
    sectionTitles = titles
    didUpdate.value = true
  }
  
  // MARK: - Data for tableView
  
  func getContactName(at indexPath: IndexPath) -> NSMutableAttributedString {
    let name = NSMutableAttributedString(string: contactsWithSections[indexPath.section][indexPath.row].firstName + " ")
    let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    let lastName = NSMutableAttributedString(string: contactsWithSections[indexPath.section][indexPath.row].lastName,
                                             attributes: attrs)
    name.append(lastName)
    return name
  }
  
  func getNumberOfRowsIn(section: Int) -> Int {
    return contactsWithSections[section].count
  }
  
  func getSectionIndexTitles() -> [String] {
    return collation.sectionIndexTitles
  }
}
