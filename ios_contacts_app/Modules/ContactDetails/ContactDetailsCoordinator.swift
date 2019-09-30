//
//  ContactDetailsCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactDetailsCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactDetailsViewModel: ContactDetailsViewModel?
  private let contactID: String
  private let storageService: StorageService
  
  // MARK: - Delegate
  
  weak var delegate: ContactDetailsCoordinatorDelegate?
  
  // MARK: - Coordinator setup
  
  init(rootViewController: UINavigationController, storageService: StorageService, contactID: String) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let contactDetailsViewModel = ContactDetailsViewModel()
    contactDetailsViewModel.delegate = self
    let contactDetailsViewController = ContactDetailsViewController(viewModel: contactDetailsViewModel)
    setupNavigationBar(viewController: contactDetailsViewController)
    rootViewController.pushViewController(contactDetailsViewController, animated: true)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    setNavigationBarAppearance()
    viewController.navigationItem.largeTitleDisplayMode = .never    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain,
                                                                       target: contactDetailsViewModel,
                                                                       action: #selector(contactDetailsViewModel?.didTapEdit))
  }
  
  private func setNavigationBarAppearance() {
    rootViewController.navigationBar.barTintColor = UIColor.headerGray
    rootViewController.navigationBar.backgroundColor = UIColor.headerGray
    rootViewController.navigationBar.shadowImage = UIImage()
  }
  
  override func finish() {
    delegate?.didFinish(from: self)
  }
  
  // MARK: - Moving between screens
  
  private func showEditContactScreen() {
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: rootViewController, contactID: contactID)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
  }
}

extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
  func contactDetailsViewModelDidRequestShowEditContactScreen() {
    showEditContactScreen()
  }
  
  func contactDetailsViewModelDidFinish(_ viewModel: ContactDetailsViewModel) {
    finish()
  }
}

extension ContactDetailsCoordinator: ContactEditCoordinatorDelegate {
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    setNavigationBarAppearance()
    contactDetailsViewModel?.getContact()
  }
}
