//
//  ContactsEditViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactEditViewController: UIViewController {
  @IBOutlet private weak var notesTextView: UITextView!
  
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
    setupNavigationBar()
  }
  
  private func setupFields() {
    notesTextView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    notesTextView.textContainer.lineFragmentPadding = 0
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.shadowImage = UIImage()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
  }
}

// MARK: - Resizing TextView on content change

extension ContactEditViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    let fixedWidth = textView.frame.size.width
    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    textView.translatesAutoresizingMaskIntoConstraints = true
    textView.frame.size = CGSize(width: fixedWidth, height: newSize.height)
    textView.isScrollEnabled = false
  }
}
