//
//  RegisterViewController.swift
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirm: UITextField!
    
    // instance of userResp
    let db = UserRepository.sharedUserRepository

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerBtnPress(_ sender: Any) {

        // textfields empty
        guard !txtFieldEmail.text.isBlank else {
            showAlertMessage(title: "Validation", message: "Email is missing!")
            return
        }

        guard txtFieldEmail.text.isValidEmail else {
            showAlertMessage(title: "Validation", message: "Invalid email format!")
            return
        }

        guard !txtFieldPassword.text.isBlank else {
            showAlertMessage(title: "Validation", message: "Password is missing!")
            return
        }

        guard !txtFieldConfirm.text.isBlank else {
            showAlertMessage(title: "Validation", message: "Confirm your password!")
            return
        }
        
        // unwrap values
        guard let email = txtFieldEmail.text,
              let password = txtFieldPassword.text,
              let confirm = txtFieldConfirm.text,
                password == confirm else {
            showAlertMessage(title: "Validation", message: "Password and repeat password does not match")
            return
        }
        
        // firebase authentication
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            // guard error got value
            guard error == nil else {
                self.showAlertMessage(title: "We could not create your account", message: "\(error!.localizedDescription)")
                return
            }
            
            // email authentication
            Auth.auth().currentUser?.sendEmailVerification{ error in
                guard error == nil else {
                    self.showAlertMessage(title: "Error", message: "\(error!.localizedDescription)")
                    return
                }
                
                // db register
                let newUser = User(id: email,
                                   email: email,
                                   memberSince: Date())
                
                Task {
                    do {
                        // create new registered user
                        try await self.db.addOrUpdate(user: newUser)
                        
                        // redirect login
                        self.showAlertMessage(title: "Email confirmation sent", message: "A confirmation email has been sent to you email account, please confirm your account before you log in") {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginInsteadbtn(_ sender: Any) {
        // close pop up 
        self.dismiss(animated: true, completion: nil)
    }
}
