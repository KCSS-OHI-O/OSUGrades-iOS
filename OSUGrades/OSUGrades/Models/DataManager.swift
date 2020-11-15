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
                    print(courseName)
                    let averageGpa = document.data()["averageGpa"] as! Double
                    let rating = document.data()["rating"] as! Double
                    let reported = document.data()["reported"] as! Int
                    let professors = document.data()["professors"] as! [String]
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
    
    func updateCourse(courseName: String, gpa: Double, rating: Int, professor: String?) {
        let index = coursesMap[courseName]
        let course = courses[index!]
        course.averageGpa = ((course.averageGpa * Double(course.reported)) + gpa) / (Double(course.reported) + 1)
        course.rating = ((course.rating * Double(course.reported)) + Double(rating)) / (Double(course.reported) + 1)
        course.reported += 1
        
        // update course on Firebase
        var dataset: [String: Any] = [
            "averageGpa": course.averageGpa,
            "course": course.courseName,
            "rating": course.rating,
            "reported": course.reported
        ]
        // if professor list exists, add
        if let profName = professor {
            // check if professor list in course exists
            var tempProfList = [String]()
            course.professors.append(profName)
            tempProfList = course.professors
            dataset["professors"] = tempProfList
        }
        db.collection("courses").document(courseName).setData(dataset) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
        }
        delegate?.dataUpdated()
    }
}
