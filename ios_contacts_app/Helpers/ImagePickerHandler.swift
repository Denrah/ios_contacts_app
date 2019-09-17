//
//  ImagePickerHandler.swift
//  ios_contacts_app
//

import UIKit

class ImagePickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var didFinish: ((Result<UIImage, Error>) -> Void)?
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.editedImage] as? UIImage else {
      if let didFinish = didFinish {
        didFinish(.failure(ImagePickerErrors.pickerError))
      }
      return
    }
    if let didFinish = didFinish {
      didFinish(.success(image))
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
