//
//  MainViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manager.delegate = self
        table.dataSource = self
        table.delegate = self
        
        table.register(UINib(nibName: K.Cells.CourseTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cells.courseCellIdentifier)
        table.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out \(signOutError)")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.courseCellIdentifier) as! CourseTableViewCell
        cell.courseName.text = manager.courses[indexPath.row].courseName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let course = manager.courses[indexPath.row]
        performSegue(withIdentifier: K.Segues.mainToDetail, sender: course)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Courses"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.mainToDetail {
            let course = sender as! Course
            let vc = segue.destination as! CourseDetailViewController
            vc.course = course
        }
    }
}

extension MainViewController: FirebaseDelegate {
    func dataUpdated() {
        self.table.reloadData()
    }
}
