//
//  PeopleTableViewController.swift
//  Nomad-Party 

import UIKit

class PeopleTableViewController: UITableViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            
            view.endEditing(true)
            
        } else {
            
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
            
        }
        
        
        
    }

    var users: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResults: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBarController()
        setupNavigationBar()
        setupTableView() 
        observeUsers()
        

        
    }
    
    func setupTableView() {
        
        tableView.tableFooterView = UIView()
        
    }
    
    // Allows the user to search for other users
    func setupSearchBarController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search users"
        searchController.searchBar.barTintColor = UIColor.white
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true 
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
    }
    
    // Creates large title. Implements location button in the top left that takes the user to the UsersAroundViewController.
    func setupNavigationBar() {
        
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let location = UIBarButtonItem(image: UIImage(named: "icon-location"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(locationDidTapped))
        navigationItem.leftBarButtonItem = location
        
//        let project = UIBarButtonItem(image: UIImage(named: "icon-plus"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        navigationItem.rightBarButtonItem = project 
    }
    
    // Takes user to UsersAroundViewController
    @objc func locationDidTapped() {
           let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let usersAroundVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_USER_AROUND) as! UsersAroundViewController
            self.navigationController?.pushViewController(usersAroundVC, animated: true)
    }

    
    func observeUsers() {
        
        Api.User.observeUsers { (user) in
            
            self.users.append(user)
            self.tableView.reloadData()
            
        }
    }
        
        func filterContent(for searchText: String) {
            
            searchResults = self.users.filter {
                
                return $0.username.lowercased().range(of: searchText) != nil
                
            }
            
            tableView.reloadData()
            
        }
        
    

    // Adjust number of rows on the screen based on search results
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? searchResults.count : self.users.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_USERS, for: indexPath) as! UserTableViewCell 

        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.controller = self 
        cell.loadData(user) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    // Takes user to the chat view controller, where the user can send a text message.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell {
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_CHAT) as! ChatViewController
            chatVC.imagePartner = cell.avatar.image
            chatVC.partnerUsername = cell.usernameLbl.text
            chatVC.partnerId = cell.user.uid 
            self.navigationController?.pushViewController(chatVC, animated: true) 
        } 
    }
}
