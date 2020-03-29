//
//  AuthViewController.swift
//  SampleChat
//
//  Created by 濱田一輝 on 2020/03/21.
//  Copyright © 2020 Kazuki Hamada. All rights reserved.
//

import UIKit
import FirebaseAuth


class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "chatViewSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
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
            if error != nil {
                print("cannot sign up")
            } else {
                self.performSegue(withIdentifier: "chatViewSegue", sender: nil)
            }
        }
    }
    
    @IBAction func didTapSignInButton(_ sender: Any) {
        guard let email = emailTextField.text else {
            print("email is nil")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("password is nil")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print("cannot sign in")
            } else {
                self.performSegue(withIdentifier: "chatViewSegue", sender: nil)
            }
        }
    }
    
    @IBAction func didTapView(_ sender: Any) {
        self.view.endEditing(true)
    }
}
