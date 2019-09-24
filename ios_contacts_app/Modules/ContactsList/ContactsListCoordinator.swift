//
//  ContactsListCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactsListCoordinator: Coordinator {
  let rootViewController: UINavigationController
  var searchResultsUpdater: SearchResultsUpdater?
  var contactsListViewModel: ContactsListViewModel?
  
  private enum Contants {
    static let screenTitle = "Contacts"
  }
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let storageService = StorageService()
    contactsListViewModel = ContactsListViewModel(storageService: storageService)
    guard let contactsListViewModel = contactsListViewModel else { return }
    contactsListViewModel.delegate = self
    searchResultsUpdater = SearchResultsUpdater(viewModel: contactsListViewModel)
    let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
    setupNavigationBar(viewController: contactsListViewController)
    rootViewController.setViewControllers([contactsListViewController], animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    rootViewController.navigationBar.barTintColor = UIColor.white
    rootViewController.navigationBar.prefersLargeTitles = true
    viewController.navigationItem.title = Contants.screenTitle
    viewController.navigationItem.largeTitleDisplayMode = .always
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = searchResultsUpdater
    searchController.dimsBackgroundDuringPresentation = false
    viewController.navigationItem.searchController = searchController
    viewController.navigationItem.hidesSearchBarWhenScrolling = false
  
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                                       action: #selector(goToContactEdit))
  }
  
  // MARK: - Moving between screens
  
  @objc private func goToContactEdit() {
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: rootViewController)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
  }
}

extension ContactsListCoordinator: ContactsListViewModelDelegate {
}

extension ContactsListCoordinator: ContactEditCoordinatorDelegate {
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    contactsListViewModel?.getContacts()
  }
}
