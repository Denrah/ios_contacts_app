//
//  ImagePickerCoordinator.swift
//  ios_contacts_app
//

import UIKit

protocol ImagePickerCoordinatorDelegate: class {
  func didFinish(from coordinator: ImagePickerCoordinator)
  func imagePickerCoordinator(didSelectImageWith result: Result<UIImage, Error>)
}

class ImagePickerCoordinator: Coordinator {
  weak var delegate: ImagePickerCoordinatorDelegate?
  
  let rootViewController: UINavigationController
  let sourceType: UIImagePickerController.SourceType
  let imagePickerHandler = ImagePickerHandler()
  
  init(rootViewController: UINavigationController, sourceType: UIImagePickerController.SourceType) {
    self.rootViewController = rootViewController
    self.sourceType = sourceType
  }
  
  override func start() {
    imagePickerHandler.didFinish = { [weak self] result in
      self?.delegate?.imagePickerCoordinator(didSelectImageWith: result)
      self?.finish()
    }
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = imagePickerHandler
    imagePicker.sourceType = sourceType
    imagePicker.allowsEditing = true
    rootViewController.present(imagePicker, animated: true, completion: nil)
  }
  
  override func finish() {
    delegate?.didFinish(from: self)
  }
}
