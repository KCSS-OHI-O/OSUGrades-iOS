//
//  AddInfoViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit

class AddInfoViewController: UIViewController {

    var course: Course!
    var manager: DataManager!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var gpaTextField: UITextField!
    @IBOutlet weak var professorNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.topItem!.title = "Add for \(course.courseName)"
        gpaTextField.tag = 0
        professorNameField.tag = 1
        
        professorNameField.delegate = self
        isModalInPresentation = true
        stepper.value = 1
        stepper.minimumValue = 1
        stepper.maximumValue = 5
        ratingLabel.text = String(format: "%d", Int(stepper.value))
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        saveData()
    }
    
    private func saveData() {
        if let gpaText = gpaTextField.text, let gpa = Double(gpaText) {
            if !checkGpa(gpa: gpa) {
                let alert = UIAlertController(title: "Invalid GPA", message: "GPA must be between 0.0 to 4.0", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                manager.updateCourse(courseName: course.courseName, gpa: gpa, rating: Int(stepper.value), professor: professorNameField.text!.isEmpty ? nil : professorNameField.text)
                let alert = UIAlertController(title: "Success", message: "Data is saved!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { handler in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        ratingLabel.text = String(format: "%d", Int(sender.value))
    }
    
    private func checkGpa(gpa: Double) -> Bool {
        return gpa >= 0 && gpa <= 4.0
    }
}

extension AddInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveData()
        return true
    }
}
