//
//  Course.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import Foundation

struct Course: Hashable {
    
    let courseName: String
    var averageGpa: Float
    var rating: Float
    var reported: Int
    var professors: [String]?
    
    init(courseName: String, averageGpa: Float, rating: Float, reported: Int, professors: [String]?) {
        self.courseName = courseName
        self.averageGpa = averageGpa
        self.rating = rating
        self.reported = reported
        self.professors = professors
    }
}
