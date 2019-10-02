//
//  Contact.swift
//  ios_contacts_app
//

import Realm
import RealmSwift

class RealmContact: Object {
  @objc dynamic var id = ""
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var phoneNumber = ""
  @objc dynamic var ringtone = ""
  @objc dynamic var notes: String?
  @objc dynamic var image: Data?
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  // MARK: - Object convertion
  
  class func fromContact(_ contact: Contact) -> RealmContact {
    let realmContact = RealmContact()
    realmContact.firstName = contact.firstName
    realmContact.lastName = contact.lastName
    realmContact.phoneNumber = contact.phoneNumber
    realmContact.ringtone = contact.ringtone
    realmContact.notes = contact.notes
    realmContact.image = contact.image?.pngData()
    realmContact.id = contact.id ?? UUID().uuidString
    return realmContact
  }
  
  func toContact() -> Contact {
    var contactImage: UIImage?
    if let data = image {
      contactImage = UIImage(data: data)
    }
    return Contact(firstName: firstName, lastName: lastName,
                   phoneNumber: phoneNumber, ringtone: ringtone,
                   notes: notes, image: contactImage, id: id)
  }
}
