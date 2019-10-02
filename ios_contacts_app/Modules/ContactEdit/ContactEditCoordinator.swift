//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit
import Realm
import RealmSwift

protocol ContactEditCoordinatorDelegate: class {
  func didFinish(from coordinator: ContactEditCoordinator)
  func didRequestReturnToMainScreen(from coordinator: ContactEditCoordinator)
}

class ContactEditCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private let appDependency: AppDependency
  private var contactEditViewModel: ContactEditViewModel?
  private let contactID: String?
  
  // MARK: - Delegate
  
  weak var delegate: ContactEditCoordinatorDelegate?
  
  // MARK: - Coordinator setup
  
  init(rootViewController: UINavigationController, appDependency: AppDependency, contactID: String? = nil) {
    self.rootViewController = rootViewController
    self.contactID = contactID
    self.appDependency = appDependency
  }
  
  override func start() {
    contactEditViewModel = ContactEditViewModel(dependencies: appDependency, contactID: contactID)
    guard let contactEditViewModel = contactEditViewModel else { return }
    contactEditViewModel.delegate = self
    let contactEditViewController = ContactEditViewController(viewModel: contactEditViewModel)
    
    setupNavigationBar(viewController: contactEditViewController,
                       navigationController: rootViewController,
                       viewModel: contactEditViewModel)
    rootViewController.pushViewController(contactEditViewController, animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController,
                                  navigationController: UINavigationController,
                                  viewModel: ContactEditViewModel) {
    navigationController.modalPresentationStyle = .fullScreen
    
    navigationController.navigationBar.barTintColor = UIColor.white
    navigationController.navigationBar.shadowImage = UIImage()
    viewController.navigationItem.largeTitleDisplayMode = .never
    
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                                      target: contactEditViewModel,
                                                                      action: #selector(contactEditViewModel?.didTapCancel))
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done,
                                                                       target: contactEditViewModel,
                                                                       action: #selector(contactEditViewModel?.didTapDone))
  }
  
  private func closeAllScreens() {
    delegate?.didRequestReturnToMainScreen(from: self)
  }
  
  private func close() {
    delegate?.didFinish(from: self)
  }
}

// MARK: - Image piker presentation

extension ContactEditCoordinator: ContactEditViewModelDelegate {
  func contactEditViewModelDidDeleteContact() {
    closeAllScreens()
  }
  
  func contactEditViewModelDidRequestClose() {
    close()
  }
  
  func contactEditViewModelDidRequestChooseImage(_ viewModel: ContactEditViewModel,
                                                 sourceType: UIImagePickerController.SourceType) {
    let imagePickerCoordinator = ImagePickerCoordinator(rootViewController: rootViewController,
                                                        sourceType: sourceType)
    imagePickerCoordinator.delegate = self
    addChildCoordinator(imagePickerCoordinator)
    imagePickerCoordinator.start()
  }
}

extension ContactEditCoordinator: ImagePickerCoordinatorDelegate {
  func imagePickerCoordinator(didSelectImageWith result: Result<UIImage, Error>) {
    switch result {
    case .success(let image):
      contactEditViewModel?.selectedImage.value = image
    case .failure(let error):
      contactEditViewModel?.didReceiveError?(error)
    }
  }
  
  func didFinish(from coordinator: ImagePickerCoordinator) {
    removeChildCoordinator(coordinator)
  }
}
