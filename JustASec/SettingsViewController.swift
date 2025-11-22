//
//  SettingsViewController.swift
//  JustASec3
//
//  Created by Kailing Schottenius on 17/11/2025.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // hide back button
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        let alert = UIAlertController(title: "Sign out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)

        // user choose yes
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            print("User has logged out")
            
            // get storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                
                // unwind segue - root view controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = loginVC
                    window.makeKeyAndVisible()
                }
            }
        }))

        // yser choose no
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
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
