//
//  TransactionType.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

enum TransactionType: String, CaseIterable, Identifiable {
    case income
    case expense
    case transfer
    
    var id: String { self.rawValue }
}
