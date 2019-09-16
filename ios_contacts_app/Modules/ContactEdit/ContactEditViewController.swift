//
//  ContactsEditViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactEditViewController: UIViewController {
  @IBOutlet private weak var notesTextView: UITextView!
  @IBOutlet private weak var notesPlaceholderLabel: UILabel!
  @IBOutlet private weak var ringtoneTextView: UITextField!
  private var ringtonePickerView: RingtonePickerView?
  private var ringtonePickerToolbar: UIToolbar?
  
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
  }
  
  private func setupFields() {
    notesTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    notesTextView.textContainer.lineFragmentPadding = 0
    
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.isScrollEnabled = false
    
    let ringtonePickerViewModel = RingtonePickerViewModel(delegate: viewModel)
    ringtonePickerView = RingtonePickerView(viewModel: ringtonePickerViewModel)
    ringtonePickerView?.viewModel.data.value = viewModel.ringtones.value
    
    let ringtoneToolbarViewModel = RingtoneToolbarViewModel(delegate: viewModel)
    ringtonePickerToolbar = RingtoneToolbarView(viewModel: ringtoneToolbarViewModel)
    
    ringtoneTextView.inputView = ringtonePickerView
    ringtoneTextView.inputAccessoryView = ringtonePickerToolbar
  }
  
  @IBAction private func onChooseImageButton() {
    let actionSheet = UIAlertController(title: "Select image", message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "From camera", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.viewModel.contactsEditViewControllerDidRequestedChoosePhoto(from: .camera)
      } else {
        let alert = UIAlertController(title: "Sorry",
                                      message: "Taking photos from camera is not avaliable on your device",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    })
    actionSheet.addAction(UIAlertAction(title: "From gallery", style: .default) { _ in
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        self.viewModel.contactsEditViewControllerDidRequestedChoosePhoto(from: .photoLibrary)
      } else {
        let alert = UIAlertController(title: "Sorry",
                                      message: "Taking photos from gallery is not avaliable on your device",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    })
    present(actionSheet, animated: true, completion: nil)
  }
}

// MARK: - Resizing TextView on content change

extension ContactEditViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    notesPlaceholderLabel.isHidden = !textView.text.isEmpty
  }
}

/*extension ContactEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print(info[.editedImage] )
  }

}*/
