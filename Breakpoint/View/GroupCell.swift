//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 18/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    func configureCell(groupTitle title : String, groupDescription description : String, membersCount members : Int) {
        titleLabel.text = title
        descriptionLabel.text = description
        memberCountLabel.text = "\(members) members."
    }

}
