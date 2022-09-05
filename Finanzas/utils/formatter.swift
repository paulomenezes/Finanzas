//
//  formatter.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation
import CurrencyFormatter

func formatCurrency(value: Double?) -> String {
    let numberFormatter = CurrencyFormatter.default
    
    return numberFormatter.string(from: value ?? 0.0) ?? "0"
}
