//
//  AlarmViewController.swift
//  JustASec
//
//  Created by Kailing Schottenius on 30/11/2025.
//

import UIKit
import FirebaseAuth
import AVFoundation // sound

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var lblClock: UILabel!
    @IBOutlet weak var lblReminderTitle: UILabel!
    @IBOutlet weak var btnSnooze: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    // live clock
    var timer: Timer?
    
    // reminder in action
    var reminderItem: Reminder?
    
    // sound
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // show time
        startClock()
        
        // assign title to reminder title
        if let reminder = reminderItem {
            lblReminderTitle.text = reminder.name
        }
        
        // play alarm sound
        playAlarmSound()
    }
    
    func startClock() {
        // upd clock immediately
        updateClock()
        
        // calculate sec to next min
        let calendar = Calendar.current
        let nextMinute = calendar.nextDate(after: Date(),
                                           matching: DateComponents(second: 0),
                                           matchingPolicy: .nextTime)!
        let interval = nextMinute.timeIntervalSinceNow
        
        // timer to start when min change to know when to upd next min
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(startMinuteTimer),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    // timer min
    @objc func startMinuteTimer() {
        // upd clock
        updateClock()
        
        // timer that upd
        timer = Timer.scheduledTimer(timeInterval: 60,
                                     target: self,
                                     selector: #selector(updateClock),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // time specifics
    @objc func updateClock(_ timer: Timer? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        lblClock.text = formatter.string(from: Date())
    }
    
    // sound
    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "Christmas-music-doorbell", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // loop
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    // MARK: buttons
    @IBAction func btnSnooze(_ sender: Any) {
        
        // silence sound
        audioPlayer?.stop()
        
        // check reminder object
        guard var reminder = reminderItem,
              let userEmail = Auth.auth().currentUser?.email else { return }

        // add 5 min on current time
        let newTime = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!

        // set correct form
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        reminder.time = formatter.string(from: newTime)

        // upd firestore
        Task {
            try? await ReminderRepository.sharedReminderRepository.addOrUpdate(reminder: reminder, for: userEmail)
        }

        // close reminder
        self.dismiss(animated: true)
    }
    
    @IBAction func btnStop(_ sender: UIButton) {
        
        // silence sound
        audioPlayer?.stop()
        
        guard var reminder = reminderItem else { return }
        guard let userEmail = Auth.auth().currentUser?.email else { return }

        // set inactive
        reminder.isActive = false

        // update Firestore
        Task {
            try? await ReminderRepository.sharedReminderRepository.addOrUpdate(reminder: reminder, for: userEmail)
        }

        self.dismiss(animated: true)
        
        // close popup
        self.dismiss(animated: true, completion: nil)
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
