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
    var reminder: [Reminder] = []
    
    var alarmTimer: Timer? // timer to trigger alarm every minute
    var reminderItem: Reminder? // reminder in action
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // auto height adapt content
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
                
                // start timer trigger after reminders are loaded
                self.startAlarmTimer()
            }
        }
    }
    
    // start timer that checks when alarm should go
    func startAlarmTimer() {
        // calculate seconds to next minute
        let calendar = Calendar.current
        let nextMinute = calendar.nextDate(after: Date(),
                                           matching: DateComponents(second: 0),
                                           matchingPolicy: .nextTime)!
        let interval = nextMinute.timeIntervalSinceNow
        
        // timer that runs check when minute changes
        alarmTimer = Timer.scheduledTimer(timeInterval: interval,
                                          target: self,
                                          selector: #selector(startMinuteAlarmTimer),
                                          userInfo: nil,
                                          repeats: false)
        
        // run check immediately when view appears
        checkAlarms()
    }
    
    // start timer that then runs check every minute
    @objc func startMinuteAlarmTimer() {
        // run check immediately
        checkAlarms()
        
        // create timer that runs every minute
        alarmTimer = Timer.scheduledTimer(timeInterval: 60,
                                          target: self,
                                          selector: #selector(checkAlarms),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    // loop through reminders and trigger alarm if time matches
    @objc func checkAlarms() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // same format as saved in Firestore
        let currentTime = formatter.string(from: Date())
        
        for r in reminder {
            if r.isActive && r.time == currentTime {
                
                // Alarm VC
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if let alarmVC = storyboard.instantiateViewController(withIdentifier: "AlarmVC") as? AlarmViewController {
                    alarmVC.reminderItem = r // send reminder object to alarm VC
                    alarmVC.modalPresentationStyle = .fullScreen
                    self.present(alarmVC, animated: true)
                }
                break // only trigger once per minute
            }
        }
    }
    
    // stop timer when reminder view close
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        alarmTimer?.invalidate()
        alarmTimer = nil
    }

    
    // num of sections for table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // num row for table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminder.count
    }
    
    // MARK: data from Firestore
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // re-use cell from storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        
        // get reminder
        let reminderItem = reminder[indexPath.row]
        
        // set values
        cell.lblReminder.text = reminderItem.name
        cell.lblTime.text = reminderItem.time
        cell.switchIsActive.isOn = reminderItem.isActive
        
        // action in switch
        cell.switchChangedAction = { [weak self] isOn in
            guard let self = self else { return }
            
            var updatedReminder = reminderItem
            updatedReminder.isActive = isOn // upd to switch value
            
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            
            Task {
                
                try? await self.db.addOrUpdate(reminder: updatedReminder, for: userEmail)
            }
            
            // upd array
            self.reminder[indexPath.row] = updatedReminder
        }
        
        return cell
    }
    
    // swipe buttons
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Edit
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            let reminderToEdit = self.reminder[indexPath.row]

            if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ReminderNewVC") as? ReminderNewViewController {
                newVC.reminderToEdit = reminderToEdit      // skicka med reminder
                newVC.modalPresentationStyle = .fullScreen
                self.present(newVC, animated: true)
            }

            completionHandler(true)
        }

        // delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            let reminderToDelete = self.reminder[indexPath.row]

            guard let reminderId = reminderToDelete.id,
                  let userEmail = Auth.auth().currentUser?.email else {
                completionHandler(false)
                return
            }

            // delete i Firestore
            Task {
                try? await self.db.deleteReminder(for: userEmail, reminderId: reminderId)
            }

            // upd table
            self.reminder.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            completionHandler(true)
        }

        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
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
