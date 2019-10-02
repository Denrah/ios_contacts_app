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
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(scrollView.snp.top)
      make.top.equalTo(contentView.snp.top)
    }
    topView.backgroundColor = UIColor.headerGray
  }
  
  private func bindToViewModel() {
    viewModel.contactName.bind = { [weak self] name in
      self?.contactNameLabel.text = name
    }
    viewModel.phoneNumber.bind = { [weak self] phone in
      self?.phoneNumberButton.setTitle(phone, for: .normal)
    }
    viewModel.ringtone.bind = { [weak self] ringtone in
      self?.ringtoneLabel.text = ringtone
    }
    viewModel.notes.bind = { [weak self] notes in
      self?.notesLabel.text = notes
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
      self?.contactImagePlaceholderLabel.text = placeholder
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
