//
//  MainViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}

extension MainViewController: FirebaseDelegate {
    func dataUpdated() {
        DispatchQueue.main.async {
            
            self.table.reloadData()
        }
    }
}
