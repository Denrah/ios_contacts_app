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
  private let contactEditNavigationController = UINavigationController()
  private var contactEditViewModel: ContactEditViewModel?
  private let contactID: String?
  
  // MARK: - Delegate
  
  weak var delegate: ContactEditCoordinatorDelegate?
  
  // MARK: - Coordinator setup
  
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
    
    contactEditNavigationController.setViewControllers([contactEditViewController], animated: false)
    
    setupNavigationBar(viewController: contactEditViewController,
                       navigationController: contactEditNavigationController,
                       viewModel: contactEditViewModel)
    rootViewController.present(contactEditNavigationController, animated: true)
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
    contactEditNavigationController.dismiss(animated: true, completion: nil)
    rootViewController.popToRootViewController(animated: true)
    delegate?.didFinish(from: self)
  }
  
  private func close() {
    contactEditNavigationController.dismiss(animated: true, completion: nil)
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
    let imagePickerCoordinator = ImagePickerCoordinator(rootViewController: contactEditNavigationController,
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
