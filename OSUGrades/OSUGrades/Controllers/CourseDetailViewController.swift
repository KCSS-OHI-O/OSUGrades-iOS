//
//  CourseDetailViewController.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit
import SafariServices

class CourseDetailViewController: UIViewController {
    
    var course: Course!

    @IBOutlet weak var averageGpaView: UIView!
    @IBOutlet weak var averageRatingView: UIView!
    
    @IBOutlet weak var averageGpaLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    @IBOutlet weak var professorTable: UITableView!
    
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
    }
    
    @IBAction func addGpaPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.detailToAdd, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.detailToAdd {
            let vc = segue.destination as! AddInfoViewController
            vc.course = course
        }
    }
}

extension CourseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let professors = course.professors {
            return professors.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let professors = course.professors {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.professorCellIdentifier) as! ProfessorTableViewCell
            cell.professorNameLabel.text = professors[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Known Professors for this Class"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = URL(string: course.professors![indexPath.row].getUrl())
        
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
