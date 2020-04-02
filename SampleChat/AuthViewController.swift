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
    @IBOutlet weak var signInButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    var alertController: UIAlertController!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    enum TextFieldTag: Int {
        case email
        case password
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        
        configureActivityIndicator()
        configureAlertController()
        
        self.view.addSubview(activityIndicator)
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
    
    func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
    }
    
    func configureAlertController() {
        alertController = UIAlertController(
            title: "認証に失敗しました",
            message: "ログインできませんでした。メールアドレスかパスワードが間違っています",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default, handler: nil)
        )
        alertController.addAction(
            UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        )
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
        
        self.activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            self.activityIndicator.stopAnimating()
            
            if error != nil {
                self.present(self.alertController, animated: true, completion: nil)
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
        
        self.activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            self.activityIndicator.stopAnimating()
            
            if error != nil {
                self.present(self.alertController, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "chatViewSegue", sender: nil)
            }
        }
    }
    
    @IBAction func didTapView(_ sender: Any) {
        self.view.endEditing(true)
    }
}
