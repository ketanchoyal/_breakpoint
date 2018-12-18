//
//  SecondViewController.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 14/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Firebase

class GroupVC: UIViewController {

    @IBOutlet weak var groupTabel: UITableView!
    
    var groups = [Groups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTabel.delegate = self
        groupTabel.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (groups) in
            DataService.instance.getAllGroups { (groupsArray) in
                self.groups = groupsArray.reversed()
                self.groupTabel.reloadData()
            }
        }
    }
    
}

extension GroupVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else { return UITableViewCell() }
        
        let group = groups[indexPath.row]
        
        //TODO : Extra information for Displaying group info on force Touch
        
        cell.configureCell(groupTitle: group.title, groupDescription: group.description, membersCount: group.memberCount, groupId: group.groupId, groupMembers: group.members, groupCreatedBy: group.createdBy)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupFeedVC = self.storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC
        
        groupFeedVC?.initData(forGroup: groups[indexPath.row])
        
        self.present(groupFeedVC!, animated: true, completion: nil)
    }
    
}
