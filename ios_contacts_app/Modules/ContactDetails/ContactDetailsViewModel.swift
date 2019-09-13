//
//  ContactDetailsViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol ContactDetailsViewModelDelegate: class {
}

class ContactDetailsViewModel {
  weak var delegate: ContactDetailsViewModelDelegate?
}
