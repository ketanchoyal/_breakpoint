//
//  FirstViewController.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 14/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var feedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTable.delegate = self
        feedTable.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.getAllFeedMessages { (success) in
            if success {
                self.feedTable.reloadData()
            }
        }
    }

}

extension FeedVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell else { return UITableViewCell() }
        
        let feed = DataService.instance.feeds.reversed()[indexPath.row]
        let profileImage = UIImage(named: "defaultProfileImage")
        DataService.instance.getUsername(forUid: feed.senderID) { (username) in
            cell.configureCell(profileImage: profileImage!, email: username, content: feed.content)
        }
        return cell
    }
    
    
}
