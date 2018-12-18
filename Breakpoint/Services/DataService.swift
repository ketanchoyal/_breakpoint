//
//  DataService.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 14/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    var feeds = [Feed]()
    var userEmails = [String]()
    var userIds = [String]()
    //var groupsArray = [Groups]()
    
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USERS = DB_BASE.child("users")
    public private(set) var REF_GROUPS = DB_BASE.child("groups")
    public private(set) var REF_FEED = DB_BASE.child("feeds")
    
    func createDBUser(uid : String, userData : Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func getUsername(forUid uid : String, usernameHandler : @escaping (_ username : String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (usernameSnapshot) in
            guard let usernameSnapshot = usernameSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in usernameSnapshot {
                if user.key == uid {
                    usernameHandler((user.childSnapshot(forPath: "email").value as? String)!)
                }
            }
        }
    }
    
    func uploadPost(withMessage message : String, forUid uid : String, withGroupKey groupKey : String?, sendComplete : @escaping (_ status : Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content" : message, "senderId" : uid])
            sendComplete(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content" : message, "senderId" : uid])
            sendComplete(true)
        }
    }
    
    //TODO : Remove closures in the end
    
    func getAllFeedMessages(feedHandler : @escaping (_ complete : Bool) -> ()) {
        feeds.removeAll()
        REF_FEED.observeSingleEvent(of: .value) { (feedSnapshot) in
            guard let feeds = feedSnapshot.children.allObjects as? [DataSnapshot] else {
                feedHandler(false)
                return }
            
            for feed in feeds {
                let content = feed.childSnapshot(forPath: "content").value as? String
                let senderId = feed.childSnapshot(forPath: "senderId").value as? String
                
                let newfeed = Feed.init(senderID: senderId!, content: content!)
                
                self.feeds.append(newfeed)
            }
            feedHandler(true)
        }
    }
    
    func getAllMessagesFor(desiredGroup : Groups, messageHandeler : @escaping (_ messages : [Feed]) -> ()) {
        var messageArray = [Feed]()
        REF_GROUPS.child(desiredGroup.groupId).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
            guard let messages = messageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in messages {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                
                let newMessage = Feed.init(senderID: senderId, content: content)
                
                messageArray.append(newMessage)
            }
            messageHandeler(messageArray)
        }
    }
    
    func getEmailsandIds(forSearchQuery query : String, handler : @escaping (_ complete : Bool) -> ()) {
        userEmails.removeAll()
        userIds.removeAll()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                handler(false)
                return }
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                let key = user.key
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    self.userEmails.append(email)
                    self.userIds.append(key)
                }
            }
            handler(true)
        }
    }
    
    func getEmailsFor(group: Groups, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getEmails(forUid uid : String, handler: @escaping (_ email: String) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if uid.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    handler(email)
                }
            }
        }
    }
    
    func createGroup(withTitle title : String, withDescription description : String, forUids uids : [String], groupCreated : @escaping (_ completed : Bool) -> ()) {
        var uidArray = uids
        uidArray.append((Auth.auth().currentUser?.uid)!)
        REF_GROUPS.childByAutoId().updateChildValues(["title" : title, "description" : description, "createdBy" : (Auth.auth().currentUser?.email)!, "members" : uidArray]) { (error, ref) in
            if error == nil {
                groupCreated(true)
            } else {
                groupCreated(false)
            }
        }
    }
    
//    func getAllGroups(completionHandler : @escaping (_ completed : Bool) -> ()) {
//        groupsArray.removeAll()
//        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
//            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {
//                completionHandler(false)
//                return }
//
//            for group in groupSnapshot {
//                let members = group.childSnapshot(forPath: "members").value as! [String]
//
//                if members.contains((Auth.auth().currentUser?.uid)!) {
//
//                    let createdBy = group.childSnapshot(forPath: "createdBy").value as! String
//                    let description = group.childSnapshot(forPath: "description").value as! String
//                    let title = group.childSnapshot(forPath: "title").value as! String
//                    let groupId = group.key
//
//                    let newGroup = Groups.init(createdBy: createdBy, description: description, members: members, memberCount: members.count, title: title, groupId: groupId)
//                    self.groupsArray.append(newGroup)
//                }
//            }
//            //self.groupsArray = self.groupsArray.reversed()
//            completionHandler(true)
//        }
//    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Groups]) -> ()) {
        var groupsArray = [Groups]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                let members = group.childSnapshot(forPath: "members").value as! [String]
                
                if members.contains((Auth.auth().currentUser?.uid)!) {
                    
                    let createdBy = group.childSnapshot(forPath: "createdBy").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let groupId = group.key
                    
                    let newGroup = Groups.init(createdBy: createdBy, description: description, members: members, memberCount: members.count, title: title, groupId: groupId)
                    groupsArray.append(newGroup)
                }
            }
            handler(groupsArray)
        }
    }

    
}
