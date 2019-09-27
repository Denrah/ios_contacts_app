//
//  ContactsListViewModel.swift
//  ios_contacts_app
//

import UIKit

protocol ContactsListViewModelDelegate: class {
  func contactsListViewModelDidRequestShowContactAddScreen()
}

class ContactsListViewModel {
  private let storageService: StorageService
  private let collation = UILocalizedIndexedCollation.current()
  private var contactsWithSections = [Section<Contact>]()
  
  // MARK: - Delegate
  
  weak var delegate: ContactsListViewModelDelegate?
  
  // MARK: - Events handling
  
  var didReceiveError: ((Error) -> Void)?
  var didUpdate: (() -> Void)?
  
  // MARK: - Table data values

  var numberOfSections: Int {
    return contactsWithSections.count
  }
  
  var contacts: [Contact] = []
  
  // MARK: - View setup
  
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
    let sections = collation.partitionObjects(array: contacts,
                                              collationStringSelector: #selector(getter: Contact.lastName))
    self.contactsWithSections = sections
    didUpdate?()
  }
  
  // MARK: - Add contact press handling
  
  @objc func didTapAddContact() {
    delegate?.contactsListViewModelDidRequestShowContactAddScreen()
  }
  
  // MARK: - Data for tableView
  
  func getContactName(at indexPath: IndexPath) -> NSMutableAttributedString {
    let name = NSMutableAttributedString(string: contactsWithSections[indexPath.section].rows[indexPath.row].firstName + " ")
    let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    let lastName = NSMutableAttributedString(string: contactsWithSections[indexPath.section].rows[indexPath.row].lastName,
                                             attributes: attrs)
    name.append(lastName)
    return name
  }
  
  func getSectionTitle(at section: Int) -> String {
    return contactsWithSections[section].title
  }
  
  func getNumberOfRowsIn(section: Int) -> Int {
    return contactsWithSections[section].rows.count
  }
  
  func getSectionIndexTitles() -> [String] {
    return collation.sectionIndexTitles
  }
}
