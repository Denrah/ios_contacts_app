//
//  Contact.swift
//  ios_contacts_app
//

import UIKit

class Contact {
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var ringtone: String
  var notes: String?
  var image: UIImage?
  
  init(firstName: String, lastName: String, phoneNumber: String,
       ringtone: String, notes: String? = nil, image: UIImage? = nil) {
    self.firstName = firstName
    self.lastName = lastName
    self.phoneNumber = phoneNumber
    self.ringtone = ringtone
    self.notes = notes
    self.image = image
  }
}
