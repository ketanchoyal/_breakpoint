//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 15/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
