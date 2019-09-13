//
//  ContactsListViewModel.swift
//  ios_contacts_app
//

import Foundation

protocol ContactsListViewModelDelegate: class {
}

class ContactsListViewModel {
  weak var delegate: ContactsListViewModelDelegate?
}
