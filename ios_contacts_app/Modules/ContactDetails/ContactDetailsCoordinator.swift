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
  
  weak var delegate: ContactDetailsCoordinatorDelegate?
  
  private let contactId: String
  private let storageService: StorageService
  
  init(rootViewController: UINavigationController, storageService: StorageService, contactId: String) {
    self.rootViewController = rootViewController
    self.storageService = storageService
    self.contactId = contactId
  }
  
  override func start() {
    let contactDetailsViewModel = ContactDetailsViewModel(storageService: storageService, contactId: contactId)
    contactDetailsViewModel.delegate = self
    let contactDetailsViewController = ContactDetailsViewController(viewModel: contactDetailsViewModel)
    setupNavigationBar(viewController: contactDetailsViewController)
    rootViewController.pushViewController(contactDetailsViewController, animated: true)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    rootViewController.navigationBar.barTintColor = UIColor.headerGray
    rootViewController.navigationBar.backgroundColor = UIColor.headerGray
    rootViewController.navigationBar.shadowImage = UIImage()
    rootViewController.navigationBar.isTranslucent = false
    
    viewController.navigationItem.largeTitleDisplayMode = .never    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
  }
  
  override func finish() {
    delegate?.didFinish(from: self)
  }
}

extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
  func contactDetailsViewModelDidFinish(_ viewModel: ContactDetailsViewModel) {
    finish()
  }
}
