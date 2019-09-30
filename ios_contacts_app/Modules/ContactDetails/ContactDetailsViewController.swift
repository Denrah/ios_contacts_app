//
//  ContactDetailsViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactDetailsViewController: UIViewController {
  private let viewModel: ContactDetailsViewModel
  
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private var contentView: UIView!
  @IBOutlet private weak var contactNameLabel: UILabel!
  @IBOutlet private weak var phoneNumberButton: UIButton!
  @IBOutlet private weak var ringtoneLabel: UILabel!
  @IBOutlet private weak var notesLabel: UILabel!
  @IBOutlet private weak var contactImageView: UIImageView!
  @IBOutlet private weak var contactImagePlaceholderLabel: UILabel!
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    viewModel.close()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
