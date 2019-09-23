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
    
    let contactsListCoordinator = ContactDetailsCoordinator(rootViewController: rootViewController)
    self.addChildCoordinator(contactsListCoordinator)
    contactsListCoordinator.start()
    
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
  override func finish() {
  }
}
