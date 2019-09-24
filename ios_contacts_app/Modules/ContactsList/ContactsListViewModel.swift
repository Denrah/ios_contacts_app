//
//  ContactsListViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactsListViewModelDelegate: class {
  func didRequestedShowDetails(for contactId: String)
}

class ContactsListViewModel {
  weak var delegate: ContactsListViewModelDelegate?
  
  let storageService: StorageService
  
  var sectionTitles: [String] = []
  private let collation = UILocalizedIndexedCollation.current()
  private var contactsWithSections = [[Contact]]()
  var contacts: [Contact] = []
  
  var didUpdate: (() -> Void)?
  var didReceiveError: ((Error) -> Void)?

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
      didReceiveError?(error)
    }
  }
  
  func updateContacts(contacts: [Contact]) {
    let (contacts, titles) = collation.partitionObjects(array: contacts,
                                                        collationStringSelector: #selector(getter: Contact.lastName))
    guard let contactsWithSections = contacts as? [[Contact]] else {
      didReceiveError?(AppError.contactsLoadFailed)
      return
    }
    self.contactsWithSections = contactsWithSections
    sectionTitles = titles
    didUpdate?()
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
  
  // MARK: - Cell selection
  
  func didSelectCell(indexPath: IndexPath) {
    guard let contactId = contactsWithSections[indexPath.section][indexPath.row].id else { return }
    delegate?.didRequestedShowDetails(for: contactId)
  }
}
