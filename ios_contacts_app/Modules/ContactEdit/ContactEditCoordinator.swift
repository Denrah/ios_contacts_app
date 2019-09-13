//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactEditCoordinator: Coordinator {
  let rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let contactEditViewModel = ContactEditViewModel()
    contactEditViewModel.delegate = self
    let contactEditViewController = ContactEditViewController(viewModel: contactEditViewModel)
    rootViewController.setViewControllers([contactEditViewController], animated: false)
  }
}

extension ContactEditCoordinator: ContactEditViewModelDelegate {
}
