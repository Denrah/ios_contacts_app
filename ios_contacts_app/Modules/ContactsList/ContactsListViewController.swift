//
//  ContactsListViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactsListViewController: UITableViewController {
  private let viewModel: ContactsListViewModel

  private enum Constants {
    static let errorAlertTitle = "Sorry"
    static let contactCellIdentifier = "contactCell"
  }
  
  // MARK: - ViewController setup
  
  init(viewModel: ContactsListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
  }
  
  private func bindToViewModel() {
    viewModel.didReceiveError = { [weak self] error in
      let alert = UIAlertController(title: Constants.errorAlertTitle,
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self?.present(alert, animated: true, completion: nil)
    }
    viewModel.didUpdate = { [weak self] in
      self?.tableView.reloadData()
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.getNumberOfRowsIn(section: section)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.sectionTitles[section]
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: Constants.contactCellIdentifier)
    cell.textLabel?.attributedText = viewModel.getContactName(at: indexPath)

    return cell
   }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 28
  }
  
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return viewModel.getSectionIndexTitles()
  }
  
  // MARK: - Handle cell selection
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.didSelectCell(indexPath: indexPath)
  }
}
