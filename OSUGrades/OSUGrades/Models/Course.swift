//
//  Course.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import Foundation

class Course {
    
    let courseName: String
    var averageGpa: Double
    var rating: Double
    var reported: Int
    var professors: [String]?
    
    init(courseName: String, averageGpa: Double, rating: Double, reported: Int, professors: [String]?) {
        self.courseName = courseName
        self.averageGpa = averageGpa
        self.rating = rating
        self.reported = reported
        self.professors = professors
    }
}
