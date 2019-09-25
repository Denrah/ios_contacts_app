//
//  ContactsListCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactsListCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactsListViewModel: ContactsListViewModel?
  private var searchResultsUpdater: SearchResultsUpdater?
  private let storageService: StorageService
  
  private enum Contants {
    static let screenTitle = "Contacts"
  }
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
    storageService = StorageService()
  }
  
  override func start() {
    contactsListViewModel = ContactsListViewModel(storageService: storageService)
    guard let contactsListViewModel = contactsListViewModel else { return }
    contactsListViewModel.delegate = self
    searchResultsUpdater = SearchResultsUpdater(viewModel: contactsListViewModel)
    let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
    setupNavigationBar(viewController: contactsListViewController)
    rootViewController.setViewControllers([contactsListViewController], animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    setNavigationBarAppearance()
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
  
  private func setNavigationBarAppearance() {
    rootViewController.navigationBar.barTintColor = UIColor.white
    // rootViewController.navigationBar.isTranslucent = true
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
  func didRequestedShowDetails(for contactID: String) {
    let contactDetailsCoordinator = ContactDetailsCoordinator(rootViewController: rootViewController,
                                                              storageService: storageService, contactID: contactID)
    contactDetailsCoordinator.delegate = self
    addChildCoordinator(contactDetailsCoordinator)
    contactDetailsCoordinator.start()
  }
}

extension ContactsListCoordinator: ContactEditCoordinatorDelegate {
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    contactsListViewModel?.getContacts()
  }
}

extension ContactsListCoordinator: ContactDetailsCoordinatorDelegate {
  func didFinish(from coordinator: ContactDetailsCoordinator) {
    setNavigationBarAppearance()
    contactsListViewModel?.getContacts()
  }
}
