//
//  AppErrors.swift
//  ios_contacts_app
//

import Foundation

enum AppError: Error {
  case contactsLoadFailed
}

extension AppError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .contactsLoadFailed:
      return "Can't load contacts"
    }
  }
}
