//
//  SignUpViewController.swift
//  SampleChat
//
//  Created by 濱田一輝 on 2020/03/21.
//  Copyright © 2020 Kazuki Hamada. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        guard let email = emailTextField.text else {
            print("email is nil")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("password is nil")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                print("cannot create user")
            } else {
                print("create user")
            }
        }
    }
}
