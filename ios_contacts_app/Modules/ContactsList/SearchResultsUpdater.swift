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
  
  // MARK: - Update data in table
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchInput = searchController.searchBar.text else { return }
    viewModel.filterContacts(input: searchInput)
  }
}
