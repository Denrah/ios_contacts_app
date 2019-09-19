//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit
import Realm
import RealmSwift

protocol ContactEditCoordinatorDelegate: class {
  func contactEditCoordinatorDidTapDone()
  func contactEditCoordinatorDidTapCancel()
}

class ContactEditCoordinator: Coordinator {
  let rootViewController: UINavigationController
  var contactEditViewModel: ContactEditViewModel?
  
  weak var delegate: ContactEditCoordinatorDelegate?
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let ringtoneService = RingtoneService()
    let storageService = StorageService()
    
    contactEditViewModel = ContactEditViewModel(ringtoneService: ringtoneService, storageService: storageService)
    guard let contactEditViewModel = contactEditViewModel else { return }
    contactEditViewModel.delegate = self
    delegate = contactEditViewModel
    let contactEditViewController = ContactEditViewController(viewModel: contactEditViewModel)
    setupNavigationBar(viewController: contactEditViewController, viewModel: contactEditViewModel)
    rootViewController.setViewControllers([contactEditViewController], animated: false)
  }
  
  private func setupNavigationBar(viewController: UIViewController, viewModel: ContactEditViewModel) {
    rootViewController.navigationBar.barTintColor = UIColor.white
    rootViewController.navigationBar.shadowImage = UIImage()
    
    viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                                      target: self, action: #selector(didTapCancel))
    viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done,
                                                                       target: self, action: #selector(didTapDone))
  }
  
  @objc private func didTapDone() {
    delegate?.contactEditCoordinatorDidTapDone()
  }
  
  @objc private func didTapCancel() {
    delegate?.contactEditCoordinatorDidTapCancel()
  }
}

// MARK: - Image piker presentation

extension ContactEditCoordinator: ContactEditViewModelDelegate {
  func contactEditViewModelDidRequestedChoosePhoto(_ viewModel: ContactEditViewModel,
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
      contactEditViewModel?.imagePickerError.value = error
  }
  
  func didFinish(from coordinator: ImagePickerCoordinator) {
    removeChildCoordinator(coordinator)
  }
}
