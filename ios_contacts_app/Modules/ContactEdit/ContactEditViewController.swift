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
  
  private var ringtonePickerView: RingtonePickerView?
  private var ringtonePickerToolbar: UIToolbar?
  
  let viewModel: ContactEditViewModel
  
  private enum ContactEditConstants {
    static let errorAlertTitle = "Sorry"
    static let imagePickerActionSheetTitle = "Select image"
    static let imagePickerActionSheetCameraOption = "Take photo"
    static let imagePickerActionSheerLibraryOprion = "Choose photo"
  }
  
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
    bindToViewModel()
  }
  
  private func bindToViewModel() {
    viewModel.selectedRingtone.bind = { [weak self] ringtone in
      ringtone.flatMap { self?.ringtoneTextView.text = $0 }
    }
    viewModel.ringtones.bind = { [weak self] ringtones in
      ringtones.flatMap { self?.ringtonePickerView?.viewModel.data.value = $0 }
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
    viewModel.imagePickerError.bind = { [weak self] error in
      let alert = UIAlertController(title: ContactEditConstants.errorAlertTitle,
                                    message: error?.localizedDescription,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
  }
  
  private func setupFields() {
    notesTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    notesTextView.textContainer.lineFragmentPadding = 0
    
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.isScrollEnabled = false
    
    addInputAccessoryForTextFields(input: phoneTextField, nextResponder: notesTextView)
    
    let ringtonePickerViewModel = RingtonePickerViewModel(delegate: viewModel)
    ringtonePickerView = RingtonePickerView(viewModel: ringtonePickerViewModel)
    ringtonePickerView?.viewModel.data.value = viewModel.ringtones.value
    
    let ringtoneToolbarViewModel = RingtoneToolbarViewModel(delegate: viewModel)
    ringtonePickerToolbar = RingtoneToolbarView(viewModel: ringtoneToolbarViewModel)
    
    ringtoneTextView.inputView = ringtonePickerView
    ringtoneTextView.inputAccessoryView = ringtonePickerToolbar
  }
  
  // MARK: - Image picking handling
  
  @IBAction private func onChooseImageButton() {
    let actionSheet = UIAlertController(title: ContactEditConstants.imagePickerActionSheetTitle,
                                        message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: ContactEditConstants.imagePickerActionSheetCameraOption, style: .default) { _ in
      self.viewModel.contactsEditViewControllerDidRequestedChoosePhoto(from: .camera)
    })
    actionSheet.addAction(UIAlertAction(title: ContactEditConstants.imagePickerActionSheerLibraryOprion, style: .default) { _ in
      self.viewModel.contactsEditViewControllerDidRequestedChoosePhoto(from: .photoLibrary)
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
