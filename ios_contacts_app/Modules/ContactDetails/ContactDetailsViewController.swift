//
//  ContactDetailsViewController.swift
//  ios_contacts_app
//

import UIKit
import SnapKit

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
  
  private enum Constants {
    static let errorAlertTitle = "Sorry"
  }
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  deinit {
    viewModel.goBack()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bindToViewModel()
  }
  
  private func setup() {
    contactNameLabel.text = viewModel.contactName.value
    phoneNumberButton.setTitle(viewModel.phoneNumber.value, for: .normal)
    ringtoneLabel.text = viewModel.ringtone.value
    notesLabel.text = viewModel.notes.value
    
    if let contactImage = viewModel.contactImage.value {
      contactImageView.image = contactImage
      contactImagePlaceholderLabel.isHidden = true
    } else {
      contactImagePlaceholderLabel.text = viewModel.contactImagePlaceholder.value
      contactImagePlaceholderLabel.isHidden = false
    }
    
    setupScrollView()
  }
  
  // MARK: - Add a gray view to the top in order to hide white background when user drags scrollview down
  
  private func setupScrollView() {
    let topView = UIView()
    scrollView.addSubview(topView)
    topView.snp.makeConstraints { make in
      make.left.right.equalTo(0)
      make.bottom.equalTo(scrollView.snp.top)
      make.top.equalTo(contentView.snp.top)
    }
    topView.backgroundColor = UIColor.headerGray
  }
  
  private func bindToViewModel() {
    viewModel.contactName.bind = { [weak self] name in
      name.flatMap { self?.contactNameLabel.text = $0 }
    }
    viewModel.phoneNumber.bind = { [weak self] phone in
      phone.flatMap { self?.phoneNumberButton.setTitle($0, for: .normal) }
    }
    viewModel.ringtone.bind = { [weak self] ringtone in
      ringtone.flatMap { self?.ringtoneLabel.text = $0 }
    }
    viewModel.notes.bind = { [weak self] notes in
      notes.flatMap { self?.notesLabel.text = $0 }
    }
    viewModel.contactImage.bind = { [weak self] image in
      if let contactImage = image {
        self?.contactImageView.image = contactImage
        self?.contactImagePlaceholderLabel.isHidden = true
      } else {
        self?.contactImagePlaceholderLabel.isHidden = false
      }
    }
    viewModel.contactImagePlaceholder.bind = { [weak self] placeholder in
      placeholder.flatMap { self?.contactImagePlaceholderLabel.text = $0 }
    }
    viewModel.didReceiveError = { [weak self] error in
      let alert = UIAlertController(title: Constants.errorAlertTitle,
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
  }
  
  // MARK: - Handle user interactions
  
  @IBAction private func didTapPhoneNumber() {
    viewModel.didTapPhoneNumber()
  }
}
