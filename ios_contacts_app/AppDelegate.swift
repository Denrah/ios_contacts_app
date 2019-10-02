//
//  AppDelegate.swift
//  ios_contacts_app
//
//  Created by iOS Intern on 12/09/2019.
//  Copyright © 2019 iOS Intern. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  private lazy var appCoordinator: AppCoordinator = {
    return AppCoordinator(window: self.window, appDependency: self.appDependency)
  }()
  private lazy var appDependency = AppDependency.makeDefault()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    appCoordinator.start()
    return true
  }
}
