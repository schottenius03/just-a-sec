//
//  SnoozeTableViewCell.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import UIKit

class SnoozeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSnooze: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
