//
//  ImagePickerHandler.swift
//  ios_contacts_app
//

import UIKit

enum ImagePickerError: Error {
  case sourceNotAvaliable
  case pickerError
}

extension ImagePickerError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .sourceNotAvaliable:
      return "This option is not avaliable on your device"
    case .pickerError:
      return "Some error has occured while image picking"
    }
  }
}

class ImagePickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var didFinish: ((Result<UIImage, Error>) -> Void)?
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.editedImage] as? UIImage else {
      didFinish?(.failure(ImagePickerError.pickerError))
      return
    }
    didFinish?(.success(image))
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
