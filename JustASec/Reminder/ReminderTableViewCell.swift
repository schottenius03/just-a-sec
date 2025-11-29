//
//  ReminderTableViewCell.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblReminder: UILabel!
    @IBOutlet weak var switchIsActive: UISwitch!
    
    var switchChangedAction: ((Bool) -> Void)? // closure change visible
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        switchChangedAction?(sender.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
