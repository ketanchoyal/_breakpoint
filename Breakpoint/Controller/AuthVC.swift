//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 15/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Auth.auth().currentUser != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func loginWithEmailPresswd(_ sender: Any) {
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        
        present(loginVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func loginWithFBPressed(_ sender: Any) {
    }
    
    @IBAction func loginWithGooglePressed(_ sender: Any) {
    }
    
    
}
