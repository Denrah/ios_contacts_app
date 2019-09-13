//
//  ContactsEditViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol ContactEditViewModelDelegate: class {
}

class ContactEditViewModel {
  weak var delegate: ContactEditViewModelDelegate?
}
