//
//  Extensions.swift
//  JustASec
//
//  Created by Kailing Schottenius on 18/11/2025.
//

import Foundation
import UIKit
import FirebaseAuth

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension Optional where Wrapped == String {
    var isBlank: Bool {
        // return true when optional doesn't have any value
        guard let notNilBool = self else {
            return true
        }
        return notNilBool.trimmingCharacters(in: .whitespaces).isEmpty
    }
    var isValidEmail: Bool {
        let emailRegister = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegister)
        return emailPred.evaluate(with: self)
    }
}

extension UIViewController {
    // show message
    func showAlertMessage(title: String, message: String, onComplete: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // 1: skapa knappen
        let buttonOk : UIAlertAction

        // title and style
        buttonOk = UIAlertAction(title: "OK", style: .default) { _ in
            onComplete?()  // run if anything w
        }
        // add button to AlertController
        alert.addAction(buttonOk)
        present(alert, animated: true)
    }
}
