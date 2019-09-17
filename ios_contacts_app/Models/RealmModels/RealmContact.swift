//
//  Contact.swift
//  ios_contacts_app
//

import Realm
import RealmSwift

class RealmContact: Object {
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var phoneNumber = ""
  @objc dynamic var ringtone = ""
  @objc dynamic var notes: String? = nil
  @objc dynamic var image: Data? = nil
}
