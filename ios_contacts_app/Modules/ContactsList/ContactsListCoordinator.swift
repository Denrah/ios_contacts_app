//
//  ContactsListCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactsListCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let contactsListViewModel = ContactsListViewModel()
    contactsListViewModel.delegate = self
    let contactsListViewController = ContactsListViewController(viewModel: contactsListViewModel)
    rootViewController.setViewControllers([contactsListViewController], animated: false)
  }
}

extension ContactsListCoordinator: ContactsListViewModelDelegate {
}
