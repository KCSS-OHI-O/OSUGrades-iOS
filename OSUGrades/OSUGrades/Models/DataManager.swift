//
//  DataManager.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import Foundation
import FirebaseFirestore

class DataManager {
    
    let db = Firestore.firestore()
    
    var coursesMap: [String: Int]
    var courses: [Course]
    
    var delegate: FirebaseDelegate?
    
    init() {
        courses = [Course]()
        coursesMap = [String: Int]()
        db.collection("courses").order(by: "course").getDocuments { (querySnapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let courseName = document.data()["course"] as! String
                    let averageGpa = document.data()["averageGpa"] as! Double
                    let rating = document.data()["rating"] as! Double
                    let reported = document.data()["reported"] as! Int
                    let professors = document.data()["professors"] as! [String]?
                    let newCourse: Course = Course(courseName: courseName, averageGpa: averageGpa, rating: rating, reported: reported, professors: professors)
                    self.courses.append(newCourse)
                    self.coursesMap[courseName] = self.courses.count - 1
                }
                
                DispatchQueue.main.async {
                    self.delegate?.dataUpdated()
                }
            }
        }
    }
}
