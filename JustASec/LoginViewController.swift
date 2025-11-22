//
//  LoginViewController.swift
//  JustASec
//
//  Created by Kailing Schottenius on 17/11/2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginBtnPress(_ sender: Any) {
        // textfields empty
        guard !txtFieldEmail.text.isBlank else {
            showAlertMessage(title: "Validation", message: "Email is missing!")
            return
        }
        guard !txtFieldPassword.text.isBlank else {
            showAlertMessage(title: "Validation", message: "Password is missing!")
            return
        }
        
        // login code
        let email = txtFieldEmail.text!
        let password = txtFieldPassword.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            // guard to check errors with fb auth
            guard error == nil else {
                self?.showAlertMessage(title: "Failed to log in", message: "\(error!.localizedDescription)")
                return
            }
            
            // check registered and email verified
            guard let authUser = Auth.auth().currentUser, authUser.isEmailVerified else {
                self?.showAlertMessage(title: "Pending email verification", message: "We've sent you an email to verify your account, please follow the instructions")
                return
            }
            
            // login user
            // instance of referred storyboard homeVC as tab bar controller
            let homeViewController = self?.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
            
            // remove stack n set root controller
            self?.view.window?.rootViewController = homeViewController
            self?.view.window?.makeKeyAndVisible()
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
