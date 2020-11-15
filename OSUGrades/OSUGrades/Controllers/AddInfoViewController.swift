//
//  AddInfoViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit

class AddInfoViewController: UIViewController {

    var course: Course!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isModalInPresentation = true
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 5
        ratingLabel.text = String(format: "%d", Int(stepper.value))
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        ratingLabel.text = String(format: "%d", Int(sender.value))
    }
}
