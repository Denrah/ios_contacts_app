//
//  SearchResultsUpdater.swift
//  ios_contacts_app
//

import UIKit

class SearchResultsUpdater: NSObject, UISearchResultsUpdating {
  private var viewModel: ContactsListViewModel
  
  init(viewModel: ContactsListViewModel) {
    self.viewModel = viewModel
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchInput = searchController.searchBar.text, !searchInput.isEmpty else { return }
    let contacts: [Contact] = viewModel.contacts.filter { contact -> Bool in
      return contact.firstName.range(of: searchInput, options: [.caseInsensitive]) != nil
        || (contact.lastName.range(of: searchInput, options: [.caseInsensitive]) != nil)
    }
    viewModel.updateContacts(contacts: contacts)
  }
}
