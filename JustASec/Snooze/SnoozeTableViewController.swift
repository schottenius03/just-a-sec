//
//  SnoozeTableViewController.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import UIKit
import FirebaseAuth

class SnoozeTableViewController: UITableViewController {
    
    let db = SnoozeRepository.sharedSnoozeRepository
    var snooze : [Snooze] = []
    
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
        
        // get snoozes for the user
        db.getAllSnoozesByUser(userId: userEmail) { returnedSnoozes in
            DispatchQueue.main.async {
                // save to array
                self.snooze = returnedSnoozes
                
                // reload table
                self.tableView.reloadData()
            }
        }
    }
    
    // num of sections for table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // num row for table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snooze.count
    }
    
    // MARK: data from Firestore
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // re-use cell from storyboard
        let cell = tableView.dequeueReusableCell(withIdentifier: "SnoozeCell", for: indexPath) as! SnoozeTableViewCell
        
        // get snooze
        let snoozeItem = snooze[indexPath.row]
        
        // set values
        cell.lblSnooze.text = snoozeItem.name
        cell.lblTime.text = snoozeItem.time
        
        return cell
    }
    
    // swipe buttons
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Edit
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            let snoozeToEdit = self.snooze[indexPath.row]

            if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SnoozeNewVC") as? SnoozeNewViewController {
                newVC.snoozeToEdit = snoozeToEdit      // skicka med snooze
                newVC.modalPresentationStyle = .fullScreen
                self.present(newVC, animated: true)
            }

            completionHandler(true)
        }

        // delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }

            let snoozeToDelete = self.snooze[indexPath.row]

            guard let snoozeId = snoozeToDelete.id,
                  let userEmail = Auth.auth().currentUser?.email else {
                completionHandler(false)
                return
            }

            // delete i Firestore
            Task {
                try? await self.db.deleteSnooze(for: userEmail, snoozeId: snoozeId)
            }

            // upd table
            self.snooze.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            completionHandler(true)
        }

        editAction.backgroundColor = .systemBlue

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

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
