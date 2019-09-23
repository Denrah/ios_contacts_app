//
//  UIViewController+inputAccessory.swift
//  ios_contacts_app
//

import UIKit

extension UIViewController {
  func addInputAccessoryForTextFields(input: UITextField, nextResponder: UIResponder) {
    let toolbar: UIToolbar = UIToolbar()
    toolbar.sizeToFit()

    let nextButton = UIBarButtonItem(title: "Next", style: .plain,
                                     target: nextResponder, action: #selector(becomeFirstResponder) )

    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
    
    toolbar.setItems([nextButton, spacer, doneButton], animated: false)
    input.inputAccessoryView = toolbar
  }
}