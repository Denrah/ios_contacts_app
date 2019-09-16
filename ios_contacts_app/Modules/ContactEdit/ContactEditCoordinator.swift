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
    setupNavigationBar(viewController: contactEditViewController)
    rootViewController.setViewControllers([contactEditViewController], animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController) {
    rootViewController.navigationBar.barTintColor = UIColor.white
    rootViewController.navigationBar.shadowImage = UIImage()
    
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
  }
}

extension ContactEditCoordinator: ContactEditViewModelDelegate {
}
