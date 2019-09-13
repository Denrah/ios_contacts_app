//
//  AppCoordinator.swift
//  ios_contacts_app
//

import UIKit

class AppCoordinator: Coordinator {
  // MARK: - Properties
  let window: UIWindow?
  
  let rootViewController = UINavigationController()
  
  // MARK: - Coordinator
  init(window: UIWindow?) {
    self.window = window
  }
  
  override func start() {
    guard let window = window else {
      return
    }
    
    let contactsEditCoordinator = ContactEditCoordinator(rootViewController: rootViewController)
    self.addChildCoordinator(contactsEditCoordinator)
    contactsEditCoordinator.start()
    
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
  override func finish() {
  }
}
