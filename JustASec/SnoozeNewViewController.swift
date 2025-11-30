//
//  SnoozeNewViewController.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import UIKit
import FirebaseAuth

class SnoozeNewViewController: UIViewController {
    
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var selectedTime: UIDatePicker!
    var snoozeToEdit: Snooze?   // optional new or edit
    
    // // instance of snoozeResp
    let db = SnoozeRepository.sharedSnoozeRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // editing
        if let snooze = snoozeToEdit {
            txtFieldTitle.text = snooze.name
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            if let date = formatter.date(from: snooze.time) {
                selectedTime.date = date
            }
        }
    }
    
    
    
    @IBAction func btnHomePress(_ sender: Any) {
        // close popup
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
        
        // new snooze
        let snooze = Snooze(
            id: snoozeToEdit?.id, // keep w edit
            name: name,
            time: timeString
        )
        
        // Firestore
        Task {
            try? await db.addOrUpdate(snooze: snooze, for: currentUserEmail)
            self.dismiss(animated: true, completion: nil)
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
