//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 18/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupMemberLabel: UILabel!
    @IBOutlet weak var groupFeedTabel: UITableView!
    @IBOutlet weak var messageField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var textFieldView: UIView!
    
    public private(set) var group : Groups?
    public private(set) var groupMessages = [Feed]()
    
    func initData(forGroup group : Groups) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupFeedTabel.delegate = self
        groupFeedTabel.dataSource = self

        view.bindToKeyboard()
        if self.groupMessages.count > 0 {
            self.groupFeedTabel.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .bottom, animated: true)
        }
        
        let tap = UITapGestureRecognizer(target: self, action:  #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.title
        DataService.instance.getEmailsFor(group: group!) { (userEmails) in
            self.groupMemberLabel.text = userEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.child((group?.groupId)!).observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, messageHandeler: { (returnedMessages) in
                self.groupMessages = returnedMessages
                self.groupFeedTabel.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.groupFeedTabel.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                }
            })
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageField.text != "" {
            messageField.isEnabled = false
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageField.text!, forUid: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.groupId) { (success) in
                if success {
                    self.messageField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    self.messageField.text = nil
                } else {
                    self.messageField.isEnabled = true
                    self.sendBtn.isEnabled = true
                }
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

extension GroupFeedVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupFeedCell") as? GroupFeedCell else { return UITableViewCell() }
        
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getEmails(forUid: message.senderID) { (email) in
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, userEmailLabel: email, contentLabel: message.content, messageId: nil)
        }
        
        return cell
    }
}
