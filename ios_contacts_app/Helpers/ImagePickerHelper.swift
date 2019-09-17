//
//  ImagePickerHelper.swift
//  ios_contacts_app
//

import UIKit

enum ImagePickerErrors: Error {
  case sourceNotAvaliable
  case pickerError
}

extension ImagePickerErrors: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .sourceNotAvaliable:
      return "This option is not avaliable on your device"
    case .pickerError:
      return "Some error has occured while image picking"
    }
  }
}

class ImagePickerHelper {
  func isSourceTypeAvaliable(sourceType: UIImagePickerController.SourceType) -> Bool {
    return UIImagePickerController.isSourceTypeAvailable(sourceType)
  }
}
