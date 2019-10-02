//
//  ContactsListCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactsListCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactsListViewModel: ContactsListViewModel?
  private var searchResultsUpdater: SearchResultsUpdater?
  private let appDependency: AppDependency
  
  private enum Contants {
    static let screenTitle = "Contacts"
  }
 
  // MARK: - Coordinator setup
  
  init(rootViewController: UINavigationController, appDependency: AppDependency) {
    self.rootViewController = rootViewController
    self.appDependency = appDependency
  }
  
  override func start() {
    contactsListViewModel = ContactsListViewModel(dependencies: appDependency)
    guard let contactsListViewModel = contactsListViewModel else { return }
    contactsListViewModel.delegate = self
    searchResultsUpdater = SearchResultsUpdater(viewModel: contactsListViewModel)
    let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
    setupNavigationBar(viewController: contactsListViewController)
    rootViewController.pushViewController(contactsListViewController, animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    setNavigationBarAppearance()
    rootViewController.navigationBar.prefersLargeTitles = true
    viewController.navigationItem.title = Contants.screenTitle
    viewController.navigationItem.largeTitleDisplayMode = .always
    
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = searchResultsUpdater
    searchController.obscuresBackgroundDuringPresentation = false
    viewController.navigationItem.searchController = searchController
    viewController.navigationItem.hidesSearchBarWhenScrolling = false
  
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: contactsListViewModel,
                                                                       action: #selector(contactsListViewModel?.didTapAddContact))
  }
  
  private func setNavigationBarAppearance() {
    rootViewController.navigationBar.barTintColor = UIColor.white
    rootViewController.navigationBar.isTranslucent = false
  }
  
  // MARK: - Moving between screens
  
  func showAddContactScreen() {
    let contactEditNavigationController = UINavigationController()
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: contactEditNavigationController,
                                                        appDependency: appDependency)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
    rootViewController.present(contactEditNavigationController, animated: true)
  }
}

extension ContactsListCoordinator: ContactsListViewModelDelegate {
  func contactsListViewModelDidRequestShowContactAddScreen() {
    showAddContactScreen()
  }

  func contactsListViewModelDidRequestShowDetails(for contactID: String) {
    let contactDetailsCoordinator = ContactDetailsCoordinator(rootViewController: rootViewController,
                                                              appDependency: appDependency, contactID: contactID)
    contactDetailsCoordinator.delegate = self
    addChildCoordinator(contactDetailsCoordinator)
    contactDetailsCoordinator.start()
  }
}

extension ContactsListCoordinator: ContactEditCoordinatorDelegate {
  func didRequestReturnToMainScreen(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    rootViewController.dismiss(animated: true, completion: nil)
    rootViewController.popToRootViewController(animated: true)
  }
  
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    rootViewController.dismiss(animated: true, completion: nil)
    contactsListViewModel?.loadContacts()
  }
}

extension ContactsListCoordinator: ContactDetailsCoordinatorDelegate {
  func didFinish(from coordinator: ContactDetailsCoordinator) {
    setNavigationBarAppearance()
    contactsListViewModel?.loadContacts()
  }
}
