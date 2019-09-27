//
//  ContactsListCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactsListCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactsListViewModel: ContactsListViewModel?
  
  private enum Contants {
    static let screenTitle = "Contacts"
  }
  
  // MARK: - Coordinator setup
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let storageService = StorageService()
    contactsListViewModel = ContactsListViewModel(storageService: storageService)
    guard let contactsListViewModel = contactsListViewModel else { return }
    contactsListViewModel.delegate = self
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
    viewController.navigationItem.searchController = searchController
    viewController.navigationItem.hidesSearchBarWhenScrolling = false
  
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: contactsListViewModel,
                                                                       action: #selector(contactsListViewModel?.didTapAddContact))
  }
  
  func showContactAddScreen() {
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: rootViewController)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
  }
}

extension ContactsListCoordinator: ContactsListViewModelDelegate {
  func contactsListViewModelDidRequestShowContactAddScreen() {
    showContactAddScreen()
  }
}

extension ContactsListCoordinator: ContactEditCoordinatorDelegate {
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    contactsListViewModel?.updateContacts()
  }
}
