//
//  PeopleTableViewController.swift
//  Nomad-Party
//
//  Created by Alex Gaskins on 7/27/20.
//  Copyright © 2020 Alex Gaskins. All rights reserved.
//

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
    
    func setupSearchBarController() {
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search users"
        searchController.searchBar.barTintColor = UIColor.white
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true 
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
    }
    
    func setupNavigationBar() {
        
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let location = UIBarButtonItem(image: UIImage(named: "icon-location"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(locationDidTapped))
        navigationItem.leftBarButtonItem = location 
    }
    
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
        
        


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive {
//            return searchResults.count
//        } else {
//            return self.users.count
//        }
        
        return searchController.isActive ? searchResults.count : self.users.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_USERS, for: indexPath) as! UserTableViewCell 

        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.loadData(user) 

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
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
