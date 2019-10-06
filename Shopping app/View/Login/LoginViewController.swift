//
//  LoginViewController.swift
//  Shopping app
//
//  Created by KOVIGROUP on 04/10/2019.
//  Copyright © 2019 KOVIGROUP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
@IBOutlet private weak var loginButton: UIButton!
@IBOutlet private weak var usernameTextField: UITextField!
@IBOutlet private weak var passwordTextField: UITextField!
}

extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

extension LoginViewController {
    @IBAction func login(_ sender: Any) {
      
    }
}
