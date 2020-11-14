//
//  CourseTableViewCell.swift
//  OSUGrades
//
//  Created by John Choi on 11/14/20.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
