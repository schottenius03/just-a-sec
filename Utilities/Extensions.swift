//
//  Extensions.swift
//  JustASec
//
//  Created by Kailing Schottenius on 18/11/2025.
//

import Foundation

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
}
