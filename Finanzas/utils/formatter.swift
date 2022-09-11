//
//  formatter.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation
import CurrencyFormatter

func formatCurrency(value: Double?) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "pt_BR")
    numberFormatter.numberStyle = NumberFormatter.Style.currency
    
    return numberFormatter.string(from: NSNumber(value: value ?? 0)) ?? ""
}
