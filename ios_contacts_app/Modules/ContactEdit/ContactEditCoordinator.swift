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
  let imagePickerHandler = ImagePickerHandler()
  
  weak var delegate: ContactEditCoordinatorDelegate?
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let ringtoneService = RingtoneService()
    let storageService = StorageService()
    
    let contactEditViewModel = ContactEditViewModel(ringtoneService: ringtoneService, storageService: storageService)
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
                                                   from sourceType: UIImagePickerController.SourceType) {
    imagePickerHandler.didFinish = { result in
      switch result {
      case .success(let image):
        viewModel.selectedImage.value = image
      case .failure(let error):
        viewModel.didError.value = error
      }
    }
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = imagePickerHandler
    imagePicker.sourceType = sourceType
    imagePicker.allowsEditing = true
    rootViewController.present(imagePicker, animated: true, completion: nil)
  }
}
