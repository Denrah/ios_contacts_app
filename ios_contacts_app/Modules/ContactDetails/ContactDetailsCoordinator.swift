//
//  ContactDetailsCoordinator.swift
//  ios_contacts_app
//

import UIKit

protocol ContactDetailsCoordinatorDelegate: class {
  func didFinish(from coordinator: ContactDetailsCoordinator)
}

class ContactDetailsCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactDetailsViewModel: ContactDetailsViewModel?
  
  weak var delegate: ContactDetailsCoordinatorDelegate?
  
  private let contactID: String
  private let storageService: StorageService
  
  init(rootViewController: UINavigationController, storageService: StorageService, contactID: String) {
    self.rootViewController = rootViewController
    self.storageService = storageService
    self.contactID = contactID
  }
  
  override func start() {
    contactDetailsViewModel = ContactDetailsViewModel(storageService: storageService, contactID: contactID)
    guard let contactDetailsViewModel = contactDetailsViewModel else { return }
    contactDetailsViewModel.delegate = self
    let contactDetailsViewController = ContactDetailsViewController(viewModel: contactDetailsViewModel)
    setupNavigationBar(viewController: contactDetailsViewController)
    rootViewController.pushViewController(contactDetailsViewController, animated: true)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    setNavigationBarAppearance()
    viewController.navigationItem.largeTitleDisplayMode = .never    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain,
                                                                       target: self, action: #selector(didTapEdit))
  }
  
  private func setNavigationBarAppearance() {
    rootViewController.navigationBar.barTintColor = UIColor.headerGray
    rootViewController.navigationBar.backgroundColor = UIColor.headerGray
    rootViewController.navigationBar.shadowImage = UIImage()
    rootViewController.navigationBar.isTranslucent = false
  }
  
  override func finish() {
    delegate?.didFinish(from: self)
  }
  
  @objc private func didTapEdit() {
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: rootViewController, contactID: contactID)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
  }
}

extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
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
