//
//  StartViewController.swift
//  JustASec6
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var labelHello: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delay 3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // call func
            self.showLoginScreen()
        }
    }

    func showLoginScreen() {
        // get storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // create instans login
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        // Full screen
        loginVC.modalPresentationStyle = .fullScreen
        // show
        self.present(loginVC, animated: true)
    }
}
