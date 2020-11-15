//
//  CourseDetailViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit
import SafariServices
import Firebase
import FirebaseFirestore

class CourseDetailViewController: UIViewController {
    
    var course: Course!

    @IBOutlet weak var averageGpaView: UIView!
    @IBOutlet weak var averageRatingView: UIView!
    
    @IBOutlet weak var averageGpaLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    @IBOutlet weak var professorTable: UITableView!
    
    var manager: DataManager!
    
    let db = Firestore.firestore()
    
    var professorNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "\(course.courseName) Class Info"

        averageGpaView.layer.cornerRadius = 15
        averageRatingView.layer.cornerRadius = 15
        
        averageGpaLabel.text = String(format: "%.2f", course.averageGpa)
        averageRatingLabel.text = String(format: "%.2f", course.rating)
        
        professorTable.dataSource = self
        professorTable.delegate = self
        professorTable.register(UINib(nibName: K.Cells.ProfessorTableViewCell, bundle: nil), forCellReuseIdentifier: K.Cells.professorCellIdentifier)
        readData()
    }
    
    @IBAction func addGpaPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.detailToAdd, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.detailToAdd {
            let vc = segue.destination as! AddInfoViewController
            vc.course = course
            vc.manager = manager
        }
    }
    
    private func readData() {
        db.collection("courses").document(course.courseName).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document was empty")
                return
            }
            DispatchQueue.main.async {
                self.averageGpaLabel.text = String(format: "%.2f", data["averageGpa"] as! Double)
                self.averageRatingLabel.text = String(format: "%.2f", data["rating"] as! Double)
                if let profList = data["professors"] as? [String] {
                    self.professorNames = profList
                }
                self.professorTable.reloadData()
            }
        }
    }
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professorNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.professorCellIdentifier) as! ProfessorTableViewCell
        cell.professorNameLabel.text = professorNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Professor List"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = URL(string: course.professors[indexPath.row].getUrl().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let safariVc = SFSafariViewController(url: url!)
        safariVc.modalPresentationStyle = .pageSheet
        present(safariVc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension String {
    func getUrl() -> String {
        let delimitedName = self.split(separator: " ")
        var result = "https://www.ratemyprofessors.com/search.jsp?queryBy=teacherName&query="
        for i in 0..<delimitedName.count {
            result += delimitedName[i]
            if i != delimitedName.count - 1 {
                result += "%20"
            }
        }
        return result
    }
}
