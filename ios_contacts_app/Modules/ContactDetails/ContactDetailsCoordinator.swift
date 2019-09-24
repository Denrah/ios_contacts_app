//
//  ContactDetailsCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactDetailsCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let contactDetailsViewModel = ContactDetailsViewModel()
    contactDetailsViewModel.delegate = self
    let contactDetailsViewController = ContactDetailsViewController(viewModel: contactDetailsViewModel)
    setupNavigationBar(viewController: contactDetailsViewController)
    rootViewController.setViewControllers([contactDetailsViewController], animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    rootViewController.navigationBar.barTintColor = UIColor.headerGray
    rootViewController.navigationBar.backgroundColor = UIColor.headerGray
    rootViewController.navigationBar.shadowImage = UIImage()
    rootViewController.navigationBar.isTranslucent = false
    
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
  }
}

extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
}
