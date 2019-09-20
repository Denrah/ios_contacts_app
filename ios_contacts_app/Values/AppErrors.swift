//
//  AppErrors.swift
//  ios_contacts_app
//

import Foundation

enum AppErrors: Error {
  case initFail
  case objectConvertionFailed
  case failWriteToStorage
  case generalSaveFailure
}

extension AppErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .initFail:
      return "Can't inialize storage"
    case .objectConvertionFailed:
      return "Can't convert object to realm entity"
    case .failWriteToStorage:
      return "Can't write to storage"
    case .generalSaveFailure:
      return "Some error has occured while contact saving"
    }
  }
}
