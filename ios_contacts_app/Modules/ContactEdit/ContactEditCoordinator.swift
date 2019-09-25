//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit
import Realm
import RealmSwift

protocol ContactEditCoordinatorDelegate: class {
  func didFinish(from coordinator: ContactEditCoordinator)
}

class ContactEditCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactEditViewModel: ContactEditViewModel?
  private let contactID: String?
  
  weak var delegate: ContactEditCoordinatorDelegate?
  
  init(rootViewController: UINavigationController, contactID: String? = nil) {
    self.rootViewController = rootViewController
    self.contactID = contactID
  }
  
  override func start() {
    let ringtoneService = RingtoneService()
    let storageService = StorageService()
    
    contactEditViewModel = ContactEditViewModel(ringtoneService: ringtoneService,
                                                storageService: storageService, contactID: contactID)
    guard let contactEditViewModel = contactEditViewModel else { return }
    contactEditViewModel.delegate = self
    let contactEditViewController = ContactEditViewController(viewModel: contactEditViewModel)
    setupNavigationBar(viewController: contactEditViewController, viewModel: contactEditViewModel)
     rootViewController.pushViewController(contactEditViewController, animated: true)
  }
  
  private func setupNavigationBar(viewController: UIViewController, viewModel: ContactEditViewModel) {
    rootViewController.navigationBar.barTintColor = UIColor.white
    rootViewController.navigationBar.shadowImage = UIImage()
    viewController.navigationItem.largeTitleDisplayMode = .never
    
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                                      target: self, action: #selector(didTapCancel))
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done,
                                                                       target: self, action: #selector(didTapDone))
  }
  
  @objc private func didTapDone() {
    contactEditViewModel?.navbarDidTapDone()
  }
  
  @objc private func didTapCancel() {
    goBack()
  }
  
  private func goBackAfterDelete() {
    rootViewController.popToRootViewController(animated: true)
    delegate?.didFinish(from: self)
  }
  
  private func goBack() {
    rootViewController.popViewController(animated: true)
    delegate?.didFinish(from: self)
  }
}

// MARK: - Image piker presentation

extension ContactEditCoordinator: ContactEditViewModelDelegate {
  func contactEditViewModelDidRequestedGobackAfterDelete() {
    goBackAfterDelete()
  }
  
  func contactEditViewModelDidRequestedGoBack() {
    goBack()
  }
  
  func contactEditViewModelDidRequestedChooseImage(_ viewModel: ContactEditViewModel,
                                                   sourceType: UIImagePickerController.SourceType) {
    let imagePickerCoordinator = ImagePickerCoordinator(rootViewController: rootViewController, sourceType: sourceType)
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
