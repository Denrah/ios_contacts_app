//
//  ContactDetailsViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactDetailsViewController: UIViewController {
  let viewModel: ContactDetailsViewModel
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
