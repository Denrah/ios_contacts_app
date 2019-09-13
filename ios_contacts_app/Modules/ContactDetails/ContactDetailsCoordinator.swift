//
//  ContactDetailsCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactDetailsCoordinator: Coordinator {
  let rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let contactDetailsViewModel = ContactDetailsViewModel()
    contactDetailsViewModel.delegate = self
    let contactDetailsViewController = ContactDetailsViewController(viewModel: contactDetailsViewModel)
    rootViewController.setViewControllers([contactDetailsViewController], animated: false)
  }
}

extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
}
