//
//  SignupViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var delegate: SignupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if isValidPassword() && passwordsMatch() {
            let email = "\(nameField.text!)@osu.edu"
            Auth.auth().createUser(withEmail: email, password: passwordField.text!) { (authResult, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "Problem occurred while signing up", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    print("Error happened while signing up user")
                } else {
                    self.dismiss(animated: true) {
                        self.delegate?.signupCompleted()
                    }
                }
            }
        }
    }
    
    /**
     Checks if the provided password satisfies the security requirement.
     Shows the UIAlert if the check fails and returns false.
     - Returns: true if the password in the password field is valid
     */
    private func isValidPassword() -> Bool {
        if let password = passwordField.text {
            if password.count >= 6 {
                return true
            } else {
                displayAlert(title: "Password is invalid!", message: "Please reenter")
                return false
            }
        } else {
            displayAlert(title: "Password is invalid!", message: "Please enter a valid password")
            return false
        }
    }
    
    /**
     Checks if the two entered passwords match.
     If the two passwords do not match, alert is shown.
     - Returns: returns true if the passwords in the two password textfields match.
     */
    private func passwordsMatch() -> Bool {
        if let pw = passwordField.text, let pwConfirm = confirmPasswordField.text {
            if pw == pwConfirm {
                return true
            } else {
                displayAlert(title: "Passwords do not match!", message: "Please enter valid password")
                return false
            }
        } else {
            displayAlert(title: "Please enter a valid password", message: "")
            return false
        }
    }
    
    /**
     Displays alert with the provided title and message on current view.
     - Parameter title: title of the alert
     - Parameter message: message of the alert
     */
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
