//
//  ViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/13/20.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.welcomeToMain, sender: nil)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segues.welcomeToSignup, sender: nil)
    }
}

