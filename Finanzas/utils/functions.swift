//
//  functions.swift
//  Finanzas
//
//  Created by Paulo Menezes on 05/09/22.
//

import Foundation
import SwiftUI

func isExpense(_ transaction: Transaction) -> Bool {
    transaction.type == TransactionType.expense.rawValue
}

func isIncome(_ transaction: Transaction) -> Bool {
    transaction.type == TransactionType.income.rawValue
}

func isTransfer(_ transaction: Transaction) -> Bool {
    transaction.type == TransactionType.transfer.rawValue
}

func isExpense(_ transaction: TransactionDashboard) -> Bool {
    transaction.type == TransactionType.expense.rawValue
}

func isIncome(_ transaction: TransactionDashboard) -> Bool {
    transaction.type == TransactionType.income.rawValue
}

func isTransfer(_ transaction: TransactionDashboard) -> Bool {
    transaction.type == TransactionType.transfer.rawValue
}

func isExpense(_ transaction: String?) -> Bool {
    transaction != nil && transaction == TransactionType.expense.rawValue
}

func isIncome(_ transaction: String?) -> Bool {
    transaction != nil && transaction == TransactionType.income.rawValue
}

func isTransfer(_ transaction: String?) -> Bool {
    transaction != nil && transaction == TransactionType.transfer.rawValue
}
