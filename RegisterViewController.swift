//
//  RegisterViewController.swift
//  JustASec1
//
//  Created by Kailing Schottenius on 17/11/2025.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldRepPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerBtnPress(_ sender: Any) {
        guard !txtFieldEmail.text.isBlank else {
            print("username is missing!")
            return
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
