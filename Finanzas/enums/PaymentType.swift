//
//  PaymentType.swift
//  Finanzas
//
//  Created by Paulo Menezes on 10/09/22.
//

import Foundation

enum PaymentType: String, CaseIterable, Identifiable, Equatable {
    case debit
    case credit
    
    var id: String { self.rawValue }
}
