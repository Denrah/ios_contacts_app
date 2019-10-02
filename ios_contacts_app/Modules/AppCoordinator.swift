//
//  AppCoordinator.swift
//  ios_contacts_app
//

import UIKit

class AppCoordinator: Coordinator {
  // MARK: - Properties
  private let window: UIWindow?
  private let rootViewController = UINavigationController()
  private let appDependency: AppDependency
  
  // MARK: - Coordinator
  init(window: UIWindow?, appDependency: AppDependency) {
    window?.backgroundColor = UIColor.white
    self.window = window
    self.appDependency = appDependency
  }
  
  override func start() {
    guard let window = window else {
      return
    }
    
    let contactsListCoordinator = ContactsListCoordinator(rootViewController: rootViewController, appDependency: appDependency)
    self.addChildCoordinator(contactsListCoordinator)
    contactsListCoordinator.start()
    
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
  }
  
  override func finish() {
  }
}
