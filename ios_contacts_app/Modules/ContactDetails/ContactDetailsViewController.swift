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
}
