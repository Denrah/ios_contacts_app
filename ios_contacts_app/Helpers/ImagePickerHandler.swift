//
//  ImagePickerHandler.swift
//  ios_contacts_app
//

import UIKit
import Photos
import MediaPlayer

class ImagePickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    print(123)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print(666)
  }
}
