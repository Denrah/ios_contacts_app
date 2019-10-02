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
  private let contactID: String
  private let appDependency: AppDependency
  
  // MARK: - Delegate
  
  weak var delegate: ContactDetailsCoordinatorDelegate?
  
  // MARK: - Coordinator setup
  
  init(rootViewController: UINavigationController, appDependency: AppDependency, contactID: String) {
    self.rootViewController = rootViewController
    self.appDependency = appDependency
    self.contactID = contactID
  }
  
  override func start() {
    contactDetailsViewModel = ContactDetailsViewModel(dependencies: appDependency, contactID: contactID)
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
    let contactEditNavigationController = UINavigationController()
    let contactEditCoordinator = ContactEditCoordinator(rootViewController: contactEditNavigationController,
                                                        appDependency: appDependency, contactID: contactID)
    contactEditCoordinator.delegate = self
    addChildCoordinator(contactEditCoordinator)
    contactEditCoordinator.start()
    rootViewController.present(contactEditNavigationController, animated: true)
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
  func didRequestReturnToMainScreen(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    rootViewController.dismiss(animated: true, completion: nil)
    rootViewController.popToRootViewController(animated: true)
  }
  
  func didFinish(from coordinator: ContactEditCoordinator) {
    removeChildCoordinator(coordinator)
    rootViewController.dismiss(animated: true, completion: nil)
    setNavigationBarAppearance()
    contactDetailsViewModel?.loadContact()
  }
}
