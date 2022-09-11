//
//  PasteItem.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import Foundation

struct TransactionDashboard : Identifiable {
    var id: UUID?
    var name: String?
    var value: Double
    var date: Date?
    var paid: Bool
    var paymentType: String?
    var paymentDate: Date?
    var installmentFrom: Int16?
    var installmentTo: Int16?
    var action: String?
    var type: String?
    var accountFrom: BankAccount?
    var accountTo: BankAccount?
    var creditCardPayment: CreditCard?
    var recurrentLastDate: Date?
}
