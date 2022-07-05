//
//  ListGroupVC.swift
//  VKInterFace
//
//  Created by user on 01/07/2022.
//

import UIKit

class ListGroupVC: UIViewController {
    
    @IBOutlet var searchBarFriends: UISearchBar! {
        didSet {
            searchBarFriends.delegate = self
        }
    }
    @IBOutlet var listGroupTV: UITableView!
    
    var myFriends = [
        Friends(name: "Маршал", image: "маршал"),
        Friends(name: "Крепыш", image: "крепыш"),
        Friends(name: "Зума", image: "зума"),
        Friends(name: "Собака", image: "дог"),
        Friends(name: "Скай", image: "скай"),
        
        Friends(name: "Эверест", image: "эверест"),
        Friends(name: "Собака 7", image: "dog7"),
        Friends(name: "Собака 8", image: "dog8"),
        Friends(name: "Собака 9", image: "dog9"),
        Friends(name: "Собака 10", image: "dog10"),
        
    ]
    
    var filterFriens = [Friends]()
    var sortedFriends = [Character: [Friends]]()
    var isSorted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listGroupTV.register(
            UINib(nibName: "GroupCellXib", bundle: nil),
            forCellReuseIdentifier: Constants.Cell.groupCellXib)
        
        //todo
        self.sortedFriends = sortForDict(myFriends: myFriends)
        filterFriens = myFriends
    }
    
    private func sortForDict(myFriends: [Friends]) -> [Character: [Friends]] {
        var friendsDict = [Character: [Friends]]()
        myFriends.forEach() { friend in
            
            guard let firstChar = friend.name.first else {return}
            
            if var  thisCharFriend = friendsDict[firstChar] {
                thisCharFriend.append(friend)
                friendsDict[firstChar] = thisCharFriend
            } else {
                friendsDict[firstChar] = [friend]
            }
        }
        
        return friendsDict
    }
    
    private func presentControllerFor(indexPath: IndexPath){
        
        let stroryboard = UIStoryboard(name: "Info", bundle: nil)
        let vc = stroryboard.instantiateInitialViewController()
        if let vc = vc as? InfoVC {
            self.present(vc, animated: true)
            let nowSection = sortedFriends.keys.sorted()[indexPath.section]
            if isSorted {
                vc.configur(like: 123, image: (filterFriens[indexPath.row].image)!)
            } else {
                vc.configur(like: 123, image: (sortedFriends[nowSection]?[indexPath.row].image)!)
            }
        }
    }
}

extension ListGroupVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if isSorted {
            return 1
        } else {
            return sortedFriends.keys.count
        }
        return sortedFriends.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSorted {
            return filterFriens.count
        } else {
            let keySorted = sortedFriends.keys.sorted()
            let friends = sortedFriends[keySorted[section]]?.count ?? 0
            
            return friends
        }
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: Constants.Cell.groupCellXib, for: indexPath)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSorted {
            return "Search"
        }
        return String(sortedFriends.keys.sorted()[section])
    }
    
}
extension ListGroupVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if isSorted {
            let friend: Friends = filterFriens[indexPath.row]
            (cell as? GroupTVCell)?.configurate(
                name: friend.name,
                image: friend.image!)
        } else {
            let firstChar = sortedFriends.keys.sorted()[indexPath.section]
            let friends = sortedFriends[firstChar]!
            let friend: Friends = friends[indexPath.row]
            (cell as? GroupTVCell)?.configurate(
                name: friend.name,
                image: friend.image!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentControllerFor(indexPath: indexPath)
    }
    
    // удаление ячейки
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            self.myFriends.remove(at: indexPath.row)
            self.listGroupTV.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension ListGroupVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSorted = false
            filterFriens = myFriends
            listGroupTV.reloadData()
        } else {
            isSorted = true
            filterFriens = myFriends.filter {$0.name.contains(searchText)}
        listGroupTV.reloadData()
        }
    }
}
