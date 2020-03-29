//
//  SettingViewController.swift
//  SampleChat
//
//  Created by 濱田一輝 on 2020/03/28.
//  Copyright © 2020 Kazuki Hamada. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
            if let displayName = user.displayName {
                self.displayNameTextField.text = displayName
            } else {
                self.displayNameTextField.text = ""
            }
        } else {
            self.displayNameTextField.text = ""
        }
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = displayNameTextField.text
        changeRequest?.commitChanges(completion: { (error) in
            if error == nil {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("some error occured")
            }
        })
        
        self.activityIndicator.startAnimating()
    }
}
