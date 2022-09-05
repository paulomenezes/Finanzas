//
//  Date.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

extension Date {
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "pt-BR")
        
        return formatter.string(from: self)
    }
}
