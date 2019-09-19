//
//  ContactsListViewController.swift
//  ios_contacts_app
//

import UIKit

class ContactsListViewController: UITableViewController {
  private let viewModel: ContactsListViewModel
  
  let searchController = UISearchController(searchResultsController: nil)
  
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
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 100
  }
  
  
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
   
   // Configure the cell...
   
   return cell
   }
  
}
