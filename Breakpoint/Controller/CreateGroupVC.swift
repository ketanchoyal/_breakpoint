//
//  CreateGroupVC.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 17/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var userTable: UITableView!
    
    var chosenUserEmailArray = [String]()
    var chosenUserIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.delegate = self
        userTable.dataSource = self
        emailSearchTextField.delegate = self
        
        doneBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.userEmails.removeAll()
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        if emailSearchTextField.text == "" {
            DataService.instance.userEmails.removeAll()
            userTable.reloadData()
        } else {
            DataService.instance.getEmailsandIds(forSearchQuery: emailSearchTextField.text!) { (success) in
                if success {
                    self.userTable.reloadData()
                }
            }
        }
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        
        if titleTextField.text != nil && descriptionTextField.text != nil {
            DataService.instance.createGroup(withTitle: titleTextField.text!, withDescription: descriptionTextField.text!, forUids: chosenUserIdArray) { (success) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Group couldn't be created.Please try again!.")
                }
            }
        }
        
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.userEmails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        
        if chosenUserEmailArray.contains(DataService.instance.userEmails[indexPath.row]) {
            
            cell.configureCell(profileImage: profileImage!, email: DataService.instance.userEmails[indexPath.row], key: DataService.instance.userIds[indexPath.row], isChecked: true)
        } else {
            cell.configureCell(profileImage: profileImage!, email: DataService.instance.userEmails[indexPath.row], key: DataService.instance.userIds[indexPath.row], isChecked: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        if !chosenUserEmailArray.contains(cell.userEmaillabel.text!) {
            
            chosenUserEmailArray.append(cell.userEmaillabel.text!)
            chosenUserIdArray.append(cell.userId)
            groupMemberLabel.text = chosenUserEmailArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            chosenUserEmailArray = chosenUserEmailArray.filter({ $0 != cell.userEmaillabel.text! })
            chosenUserIdArray = chosenUserIdArray.filter({$0 != cell.userId})
            if chosenUserEmailArray.count >= 1 {
                groupMemberLabel.text = chosenUserEmailArray.joined(separator: ", ")
            } else {
                groupMemberLabel.text = "add people to your group.."
                doneBtn.isHidden = true
            }
        }
        
    }
}

extension CreateGroupVC : UITextFieldDelegate {
    
}
