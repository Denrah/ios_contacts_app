//
//  AppDependency.swift
//  ios_contacts_app
//

import Foundation

protocol HasRingtoneService {
  var ringtoneService: RingtoneService { get }
}

protocol HasStorageService {
  var storageService: StorageService { get }
}

class AppDependency: HasRingtoneService, HasStorageService {
  let ringtoneService: RingtoneService
  let storageService: StorageService
  
  init(ringtoneService: RingtoneService, storageService: StorageService) {
    self.ringtoneService = ringtoneService
    self.storageService = storageService
  }
  
  static func makeDefault() -> AppDependency {
    let ringtoneService = RingtoneService()
    let storageService = StorageService()
    return AppDependency(ringtoneService: ringtoneService, storageService: storageService)
  }
}
