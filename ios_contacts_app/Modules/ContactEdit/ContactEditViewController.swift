//
//  ContactsEditViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactEditViewController: UIViewController {
  @IBOutlet private weak var notesTextView: UITextView!
  @IBOutlet private weak var notesPlaceholderLabel: UILabel!
  @IBOutlet private weak var ringtoneTextView: UITextField!
  var picker: RingtonePickerView?
  var pickerAccessory: UIToolbar?
  
  let viewModel: ContactEditViewModel
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactEditViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    notesTextView.delegate = self
    setupFields()
  }
  
  private func setupFields() {
    notesTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    notesTextView.textContainer.lineFragmentPadding = 0
    
    picker = RingtonePickerView(data: ["One", "Two", "Three", "Four", "Five"])
    pickerAccessory = RingtoneToolbarView()
    
    ringtoneTextView.inputView = picker
    ringtoneTextView.inputAccessoryView = pickerAccessory
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.shadowImage = UIImage()
    
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.isScrollEnabled = false
  }
}

// MARK: - Resizing TextView on content change

extension ContactEditViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    notesPlaceholderLabel.isHidden = !textView.text.isEmpty
  }
}
