//
//  SecondViewController.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 14/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class GroupVC: UIViewController {

    @IBOutlet weak var groupTabel: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTabel.delegate = self
        groupTabel.dataSource = self
    }
}

extension GroupVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else { return UITableViewCell() }
        
        cell.configureCell(groupTitle: "Group text", groupDescription: "Firest Group", membersCount: 3)
        
        return cell
    }
}
