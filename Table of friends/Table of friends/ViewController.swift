//
//  ViewController.swift
//  FriendFaces
//
//  Created by Lawrence Tsui on 14/1/21.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    
    var friends = [Friend]()
    var fileredFriends = [Friend]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = UISearchController(searchResultsController: nil)//nil is current view controller
        search.obscuresBackgroundDuringPresentation = false//when have a seperate window
        search.searchBar.placeholder = "Find a friend"
        navigationItem.searchController = search
        search.searchResultsUpdater = self
        // push data to UI that works with the main thread
        DispatchQueue.global().async {
            do{
               
                let url = Bundle.main.url(forResource: "data",
                                          withExtension: "json")!
                let data = try! Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let downloadedFriends = try decoder.decode([Friend].self, from: data)
                
                DispatchQueue.main.async {
                    self.friends = downloadedFriends//update
                    self.fileredFriends = downloadedFriends
                    print(self.friends)
                    self.tableView.reloadData()//show table
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileredFriends.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = fileredFriends[indexPath.row]
        cell.textLabel?.text = friend.name
        cell.detailTextLabel?.text = friend.friends.map { $0.name}.joined(separator: ",")
        return cell
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 0{
            fileredFriends = friends.filter{
                $0.name.contains(text)
                    || $0.company.contains(text)
                    || $0.address.contains(text)
            }
        }else {
                fileredFriends = friends
            }
            tableView.reloadData()
        }
    }


