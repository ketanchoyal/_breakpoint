//
//  AuthService.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 15/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email : String, andPassword password : String, userCreationComplete : @escaping (_ status : Bool, _ error : Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            let User = user.user
            
            let userData = ["provider" : User.providerID, "email" : User.email]
            DataService.instance.createDBUser(uid: User.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true,nil)
        }
    }
    
    func loginUser(withEmail email : String, andPassword password : String, loginComplete : @escaping (_ status : Bool, _ error : Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                loginComplete(false,error)
                return
            }
            loginComplete(true,nil)
        }
    }
}
