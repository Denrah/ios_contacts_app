//
//  StorageService+Contacts.swift
//  ios_contacts_app
//

import UIKit

extension StorageService {
  func saveContact(_ contact: Contact) -> (Result<Void, Error>) {
    let realmContact = RealmContact.fromContact(contact)
    
    let result = saveObject(realmContact)
    
    switch result {
    case .success:
      return .success(())
    case .failure:
      return .failure(StorageError.generalSaveFailure)
    }
  }
  
  func getContacts() -> Result<[Contact], Error> {
    let result = getObjects(ofType: RealmContact.self)
    
    switch result {
    case .success(let realmContacts):
      let contacts = realmContacts.map { contact -> Contact in
        contact.toContact()
      }
      return Result.success(contacts)
    case .failure(let error):
      return Result.failure(error)
    }
  }
  
  func getContact(contactId: String) -> Result<Contact, Error> {
    let result = getObjectById(ofType: RealmContact.self, id: contactId)
    
    switch result {
    case .success(let realmContact):
      return Result.success(realmContact.toContact())
    case .failure(let error):
      return Result.failure(error)
    }
  }
}
