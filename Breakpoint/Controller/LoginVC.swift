//
//  LoginVC.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 15/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self

    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        if emailField.text != nil && passwordField.text != nil {
            
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(error?.localizedDescription as Any)
                }
                
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, error) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
                
            }
            
        }
        
    }
}

extension LoginVC : UITextFieldDelegate {
    
}
