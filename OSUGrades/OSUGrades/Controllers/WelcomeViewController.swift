//
//  ViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/13/20.
//

import UIKit
import Firebase
import FirebaseAuth

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextfield.delegate = self
        nameTextfield.tag = 0
        passwordTextfield.delegate = self
        passwordTextfield.tag = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: K.Segues.welcomeToMain, sender: nil)
        }
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        if let username = nameTextfield.text, let password = passwordTextfield.text {
            let useremail = "\(username)@osu.edu"
            Auth.auth().signIn(withEmail: useremail, password: password) { (authResult, error) in
                if error != nil {
                    print("Error happened while signing in")
                } else {
                    self.performSegue(withIdentifier: K.Segues.welcomeToMain, sender: nil)
                }
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.welcomeToSignup, sender: nil)
    }
    
    
}

extension WelcomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextfield.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
