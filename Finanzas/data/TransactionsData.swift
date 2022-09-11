//
//  TransactionsData.swift
//  Finanzas
//
//  Created by Paulo Menezes on 11/09/22.
//

import Foundation
import SwiftUI

func transactionsData(transactions: FetchedResults<Transaction>) -> [TransactionDashboard] {
    guard !transactions.isEmpty else { return [] }
    
    let calendar = Calendar.current
    
    var newTransactions: [TransactionDashboard] = []
    
    for transaction in transactions {
        var clone = TransactionDashboard(
            id: transaction.id,
            name: transaction.name,
            value: transaction.value,
            date: transaction.date,
            paid: transaction.paid,
            paymentType: transaction.paymentType,
            paymentDate: transaction.paymentDate,
            installmentFrom: transaction.installmentFrom,
            installmentTo: transaction.installmentTo,
            action: transaction.action,
            type: transaction.type,
            accountFrom: transaction.accountFrom,
            accountTo: transaction.accountTo,
            creditCardFrom: transaction.creditCardFrom,
            creditCardPayment: transaction.creditCardPayment,
            recurrentLastDate: transaction.recurrentLastDate
        )
        
        if !clone.paid {
            if clone.action == ActionType.installments.rawValue {
                clone.name = "\(transaction.name ?? "") \(transaction.installmentFrom)/\(transaction.installmentTo)"
                clone.value = transaction.value / Double(clone.installmentTo ?? 1)
                
                newTransactions.append(clone)
                
                let from = transaction.installmentFrom
                let to = transaction.installmentTo
                
                if to > from {
                    var i: Int16 = 1
                    for _ in from..<to {
                        let creditCardPaymentDateComponents = calendar.dateComponents([.year, .month, .day], from: transaction.date ?? Date())
                        
                        var dateComponents = DateComponents()
                        dateComponents.year = creditCardPaymentDateComponents.year
                        dateComponents.month = (creditCardPaymentDateComponents.month ?? 0) + Int(i)
                        dateComponents.day = creditCardPaymentDateComponents.day
                        
                        let installmentFrom = from + i

                        let newItemClone = TransactionDashboard(
                            id: UUID(),
                            name: "\(transaction.name ?? "") \(installmentFrom)/\(transaction.installmentTo)",
                            value: transaction.value / Double(transaction.installmentTo),
                            date: calendar.date(from: dateComponents) ?? Date(),
                            paid: false,
                            paymentType: transaction.paymentType,
                            paymentDate: transaction.paymentDate,
                            installmentFrom: installmentFrom,
                            installmentTo: transaction.installmentTo,
                            action: transaction.action,
                            type: transaction.type,
                            accountFrom: transaction.accountFrom,
                            accountTo: transaction.accountTo,
                            creditCardPayment: transaction.creditCardPayment,
                            recurrentLastDate: transaction.recurrentLastDate
                        )
                        
                        newTransactions.append(newItemClone)
                        
                        i += 1
                    }
                }
            } else if clone.action == ActionType.recurrent.rawValue {
                let endDate = clone.recurrentLastDate ?? Date().adding(.month, value: 12)
                
                var currentDate = Date().noon()    // "Jun 30, 2020 at 12:00 PM"

                repeat {
                    let newItemClone = TransactionDashboard(
                        id: UUID(),
                        name: "\(transaction.name!) - \(currentDate.formatted(.dateTime.month().year()))",
                        value: transaction.value / Double(transaction.installmentTo),
                        date: currentDate,
                        paid: false,
                        paymentType: transaction.paymentType,
                        paymentDate: transaction.paymentDate,
                        installmentFrom: transaction.installmentFrom,
                        installmentTo: transaction.installmentTo,
                        action: transaction.action,
                        type: transaction.type,
                        accountFrom: transaction.accountFrom,
                        accountTo: transaction.accountTo,
                        creditCardPayment: transaction.creditCardPayment,
                        recurrentLastDate: transaction.recurrentLastDate
                    )
                    
                    newTransactions.append(newItemClone)

                    currentDate = currentDate.adding(.month, value: 1)
                } while currentDate <= endDate
            } else {
                newTransactions.append(clone)
            }
        } else {
            clone.name = "\(transaction.name ?? "") \(transaction.installmentFrom)/\(transaction.installmentTo)"
            clone.value = transaction.value / Double(clone.installmentTo ?? 1)
            
            newTransactions.append(clone)
        }
    }
    
    return newTransactions.sorted {
        return $0.date! < $1.date!
    }
}

func transactionsGroupByDate(transactions: [TransactionDashboard]) -> [(key: String, value: [TransactionDashboard])] {
    guard !transactions.isEmpty else { return [] }
    
    let calendar = Calendar.current
    
    return Dictionary(grouping: transactions) { transaction in
        if transaction.paymentType == PaymentType.credit.rawValue {
            let creditCardPaymentDate = transaction.creditCardFrom?.paymentDate ?? Date()
            let itemDate = transaction.date ?? Date()
            
            if itemDate > creditCardPaymentDate {
                let creditCardPaymentDateComponents = calendar.dateComponents([.year, .month, .day], from: creditCardPaymentDate)
                let itemDateComponents = calendar.dateComponents([.year, .month, .day], from: itemDate)

                var dateComponents = DateComponents()
                dateComponents.year = itemDateComponents.year
                dateComponents.month = (itemDateComponents.month ?? 0) + 1
                dateComponents.day = creditCardPaymentDateComponents.day
                
                return calendar.date(from: dateComponents)?.toFormattedString() ?? ""
            } else {
                return transaction.creditCardFrom?.paymentDate?.toFormattedString() ?? ""
            }
        } else {
            return transaction.date?.toFormattedString() ?? ""
        }
    }.sorted(by: {
        let a = $0.key.toDate(withFormat: "dd/MM/yyyy") ?? Date()
        let b = $1.key.toDate(withFormat: "dd/MM/yyyy") ?? Date()
        
        return a < b
    })
}
