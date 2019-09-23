//
//  ContactsEditCoordinator.swift
//  ios_contacts_app
//

import UIKit

class ContactEditCoordinator: Coordinator {
  private let rootViewController: UINavigationController
  private var contactEditViewModel: ContactEditViewModel?
  
  init(rootViewController: UINavigationController) {
    self.rootViewController = rootViewController
  }
  
  override func start() {
    let ringtoneService = RingtoneService()
    contactEditViewModel = ContactEditViewModel(ringtoneService: ringtoneService)
    guard let viewModel = contactEditViewModel else { return }
    viewModel.delegate = self
    let contactEditViewController = ContactEditViewController(viewModel: viewModel,
                                                              ringtonePickerViewModel: viewModel.ringtonePickerViewModel,
                                                              ringtoneTollbarViewModel: viewModel.ringtoneToolbarViewModel)
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
      contactEditViewModel?.didReceiveError.value = error
    }
  }
  
  func didFinish(from coordinator: ImagePickerCoordinator) {
    removeChildCoordinator(coordinator)
  }
}
