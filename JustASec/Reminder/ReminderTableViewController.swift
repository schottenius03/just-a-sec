//
//  ReminderTableViewController.swift
//  JustASec
//
//  Created by Kailing Schottenius on 22/11/2025.
//

import UIKit
import FirebaseAuth

class ReminderTableViewController: UITableViewController {
    
    let db = ReminderRepository.sharedReminderRepository
    var reminder : [Reminder] = []
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // auto height adp content
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // get logged in user
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("No user logged in.")
            return
        }
        
        // get reminders for the user
        db.getAllRemindersByUser(userId: userEmail) { returnedReminders in
            DispatchQueue.main.async {
                // save to array
                self.reminder = returnedReminders
                
                // reload table
                self.tableView.reloadData()
            }
        }
    }
    
    // num of sec for table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // num row for table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminder.count
    }
    
    // data from Firestore
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // re-use cell from storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        
        // get reminder
        let reminderItem = reminder[indexPath.row]
        
        // set title
        cell.lblReminder.text = reminderItem.name
        
        return cell
    }
    
    
    // swipe del from table
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let reminderToDelete = reminder[indexPath.row]
            
            // info user n reminder on the move
            guard let reminderId = reminderToDelete.id,
                  let userEmail = Auth.auth().currentUser?.email else { return }
            
            // del
            Task {
                try? await db.deleteReminder(for: userEmail, reminderId: reminderId)
            }
            
            // remove from table
            reminder.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
