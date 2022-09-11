//
//  Dashboard.swift
//  Finanzas
//
//  Created by Paulo Menezes on 05/09/22.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var bankAccounts: FetchedResults<BankAccount>
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date),
        SortDescriptor(\.name)
    ]) var transactions: FetchedResults<Transaction>
    
    let calendar = Calendar.current

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Balance")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Text(formatCurrency(value: calculateBalance()))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.gray.opacity(0.2))
                )
                .padding()
                
                List {
                    ForEach(transactionsByDay(), id: \.key) { key, value in
                        Text(key)
                        ForEach(value) { transaction in
                            TransactionItemView(name: transaction.name, value: transaction.value, paid: transaction.paid, type: transaction.type)
                                .swipeActions {
                                    Button("Transfered") {
//                                    Button(isExpense(transaction) ? "Paid" : isIncome(transaction) ? "Received" : "Transfered") {
//                                        if !transaction.paid {
//                                            transaction.paid = true
//
//                                            let bankAccount = bankAccounts.first(where: { account in
//                                                account.id == transaction.accountFrom?.id
//                                            })
//
//                                            if let bankAccount = bankAccount {
//                                                if isExpense(transaction) {
//                                                    bankAccount.balance -= transaction.value
//                                                } else if isIncome(transaction) {
//                                                    bankAccount.balance += transaction.value
//                                                } else if isTransfer(transaction) {
//                                                    let bankAccountTo = bankAccounts.first(where: { account in
//                                                        account.id == transaction.accountTo?.id
//                                                    })
//
//                                                    bankAccount.balance -= transaction.value
//
//                                                    if let bankAccountTo = bankAccountTo {
//                                                        bankAccountTo.balance += transaction.value
//                                                    }
//                                                }
//                                            }
//
//                                            try? managedObjectContext.save()
//                                        }
                                    }
                                    .tint(.green)
                                }
                        }
                        HStack {
                            Spacer()
                            Text(formatCurrency(value: calculateDayBalance(date: key)))
                                .fontWeight(.bold)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Finanzas")
        }
    }
    
    func calculateBalance() -> Double {
        bankAccounts.reduce(0) { partialResult, bankAccount in
            partialResult + bankAccount.balance
        }
    }
    
    func calculateDayBalance(date: String) -> Double {
        let d = date.toDate(withFormat: "dd/MM/yyyy") ?? Date()
        
        var balance = calculateBalance()
        let transactions = transactionsByDay()
        
        for transaction in transactions {
            let key = transaction.key.toDate(withFormat: "dd/MM/yyyy") ?? Date()
            
            if key <= d {
                for value in transaction.value {
                    if !value.paid {
                        if value.type == TransactionType.expense.rawValue {
                            balance -= value.value
                        } else if value.type == TransactionType.income.rawValue {
                            balance += value.value
                        }
                    }
                }
            }
        }
        
        return balance
    }
    
    func transactionsByDay() -> [(key: String, value: [TransactionDashboard])] {
        guard !transactions.isEmpty else { return [] }
        
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
                creditCardPayment: transaction.creditCardPayment,
                recurrentLastDate: transaction.recurrentLastDate
            )
            
            if !clone.paid {
                if clone.action == ActionType.installments.rawValue {
//                    let name = transaction.name ?? ""
                    clone.name = "\(transaction.name ?? "") \(transaction.installmentFrom)/\(transaction.installmentTo)"
                    
                    newTransactions.append(clone)
                    
                    let from = transaction.installmentFrom
                    let to = transaction.installmentTo

                    if to > from {
                        for index in from..<to {
                            let creditCardPaymentDateComponents = calendar.dateComponents([.year, .month, .day], from: transaction.date ?? Date())

                            var dateComponents = DateComponents()
                            dateComponents.year = creditCardPaymentDateComponents.year
                            dateComponents.month = (creditCardPaymentDateComponents.month ?? 0) + Int(index)
                            dateComponents.day = creditCardPaymentDateComponents.day
                            
                            let installmentFrom = transaction.installmentFrom + index

                            let clone = TransactionDashboard(
                                id: transaction.id,
                                name: "\(transaction.name ?? "") \(installmentFrom)/\(transaction.installmentTo)",
                                value: transaction.value,
                                date: calendar.date(from: dateComponents) ?? Date(),
                                paid: transaction.paid,
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
                            
                            newTransactions.append(clone)
                        }
                    }
                } else if clone.action == ActionType.recurrent.rawValue {
                    newTransactions.append(clone)
                } else {
                    newTransactions.append(clone)
                }
            }
        }
        
        return Dictionary(grouping: newTransactions) { transaction in
            if transaction.paymentType == PaymentType.credit.rawValue {
                let creditCardPaymentDate = transaction.creditCardPayment?.paymentDate ?? Date()
                let itemDate = transaction.date ?? Date()
                
                if itemDate > creditCardPaymentDate {
                    // Data do cartão: 12/09/2022
                    // Data da compra: 15/09/2022
                    // Create date from components
                    let creditCardPaymentDateComponents = calendar.dateComponents([.year, .month, .day], from: creditCardPaymentDate)

                    var dateComponents = DateComponents()
                    dateComponents.year = creditCardPaymentDateComponents.year
                    dateComponents.month = (creditCardPaymentDateComponents.month ?? 0) + 1
                    dateComponents.day = creditCardPaymentDateComponents.day

                    return calendar.date(from: dateComponents)?.toFormattedString() ?? ""
                } else {
                    return transaction.creditCardPayment?.paymentDate?.toFormattedString() ?? ""
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
