//
//  ReminderNewViewController.swift
//  JustASec4
//
//  Created by Kailing Schottenius on 18/11/2025.
//


import UIKit
import FirebaseAuth

class ReminderNewViewController: UIViewController {
    
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var selectedTime: UIDatePicker!
    
    // // instance of reminderResp
    let db = ReminderRepository.sharedReminderRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnHomePress(_ sender: Any) {
        // stäng popup / dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSavePress(_ sender: Any) {
        
        // txtfield title req
        guard let name = txtFieldTitle.text, !name.isEmpty else {
            showAlertMessage(title: "Validation", message: "Title is required.")
            return
        }
        
        // get time as string
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // hh = 12h, a = AM/PM
        let timeString = formatter.string(from: selectedTime.date)
        
        // get logged in user
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            // no throw user to login
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                loginVC.modalPresentationStyle = .fullScreen
                present(loginVC, animated: true)
            }
            return
        }
        
        // new reminder
        let newReminder = Reminder(id: nil, name: name, time: timeString)
        
        // Firestore
        Task {
            do {
                try await db.addOrUpdate(reminder: newReminder, for: currentUserEmail)
                
                // alert + dismiss
                showAlertMessage(title: "Success", message: "Reminder created!") {
                    self.dismiss(animated: true, completion: nil)
                }
                
            } catch {
                showAlertMessage(title: "Error", message: "Could not save reminder: \(error.localizedDescription)")
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
