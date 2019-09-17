//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit
import Realm
import RealmSwift

class ContactEditCoordinator: Coordinator {
  let rootViewController: UINavigationController
  let imagePickerHandler = ImagePickerHandler()
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let ringtoneService = RingtoneService()
    let storageService = StorageService()
    
    let contactEditViewModel = ContactEditViewModel(ringtoneService: ringtoneService)
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

// MARK: - Image piker presentation

extension ContactEditCoordinator: ContactEditViewModelDelegate {
  func contactEditViewModelDidRequestedChoosePhoto(_ viewModel: ContactEditViewModel,
                                                   from sourceType: UIImagePickerController.SourceType) {
    imagePickerHandler.didFinish = { result in
      switch result {
      case .success(let image):
        viewModel.selectedImage.value = image
      case .failure(let error):
        viewModel.imagePickerError.value = error
      }
    }
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = imagePickerHandler
    imagePicker.sourceType = sourceType
    imagePicker.allowsEditing = true
    rootViewController.present(imagePicker, animated: true, completion: nil)
  }
}
