//
//  ContactsEditViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactEditViewController: UIViewController {
  @IBOutlet private weak var notesTextView: UITextView!
  @IBOutlet private weak var notesPlaceholderLabel: UILabel!
  @IBOutlet private weak var ringtoneTextView: UITextField!
  @IBOutlet private weak var imagePickerButton: UIButton!
  @IBOutlet private weak var firstNameTextField: UITextField!
  @IBOutlet private weak var lastNametextField: UITextField!
  @IBOutlet private weak var phoneTextField: UITextField!
  
  private let viewModel: ContactEditViewModel
  
  private var ringtonePickerView: RingtonePickerView
  private var ringtonePickerToolbar: UIToolbar
  
  private enum Constants {
    static let errorAlertTitle = "Sorry"
    static let imagePickerActionSheetTitle = "Select image"
    static let imagePickerActionSheetCameraOption = "Take photo"
    static let imagePickerActionSheerLibraryOprion = "Choose photo"
  }
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactEditViewModel) {
    self.viewModel = viewModel
    self.ringtonePickerView = RingtonePickerView(viewModel: viewModel.ringtonePickerViewModel)
    self.ringtonePickerToolbar = RingtoneToolbarView(viewModel: viewModel.ringtoneToolbarViewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupFields()
    bindToViewModel()
  }
  
  private func setupFields() {
    notesTextView.delegate = self
    notesTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    notesTextView.textContainer.lineFragmentPadding = 0
    
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.isScrollEnabled = false
    
    addInputAccessoryForTextFields(input: phoneTextField, nextResponder: notesTextView)
    
    ringtoneTextView.inputView = ringtonePickerView
    ringtoneTextView.inputAccessoryView = ringtonePickerToolbar
  }
  
  private func bindToViewModel() {
    viewModel.selectedRingtone.bind = { [weak self] ringtone in
      ringtone.flatMap { self?.ringtoneTextView.text = $0 }
    }
    viewModel.ringtoneIsEditing.bind = { [weak self] isEditing in
      guard let isEditing = isEditing else { return }
      if !isEditing {
        self?.ringtoneTextView.resignFirstResponder()
      }
    }
    viewModel.selectedImage.bind = { [weak self] image in
      image.flatMap { self?.imagePickerButton.setImage($0, for: .normal) }
    }
    viewModel.didReceiveError.bind = { [weak self] error in
      let alert = UIAlertController(title: Constants.errorAlertTitle,
                                    message: error?.localizedDescription,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
  }
  
  // MARK: - Image picking handling
  
  @IBAction private func onChooseImageButton() {
    let actionSheet = UIAlertController(title: Constants.imagePickerActionSheetTitle,
                                        message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: Constants.imagePickerActionSheetCameraOption, style: .default) { _ in
      self.viewModel.chooseImage(sourceType: .camera)
    })
    actionSheet.addAction(UIAlertAction(title: Constants.imagePickerActionSheerLibraryOprion, style: .default) { _ in
      self.viewModel.chooseImage(sourceType: .photoLibrary)
    })
    present(actionSheet, animated: true, completion: nil)
  }
}

// MARK: - Enable/disable notes placeholder and handle "Done" press

extension ContactEditViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    notesPlaceholderLabel.isHidden = !textView.text.isEmpty
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    return true
  }
}
