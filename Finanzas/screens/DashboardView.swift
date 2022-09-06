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
                                    Button(transaction.type == TransactionType.expense.rawValue ? "Paid" : transaction.type == TransactionType.income.rawValue ? "Received" : "Transfered") {
                                        if !transaction.paid {
                                            transaction.paid = true
                                            
                                            let bankAccount = bankAccounts.first(where: { account in
                                                account.id == transaction.accountFrom
                                            })
                                            
                                            if let bankAccount = bankAccount {
                                                if transaction.type == TransactionType.expense.rawValue {
                                                    bankAccount.balance -= transaction.value
                                                } else if transaction.type == TransactionType.income.rawValue {
                                                    bankAccount.balance += transaction.value
                                                } else if transaction.type == TransactionType.transfer.rawValue {
                                                    let bankAccountTo = bankAccounts.first(where: { account in
                                                        account.id == transaction.accountTo
                                                    })
                                                    
                                                    bankAccount.balance -= transaction.value
                                                    
                                                    if let bankAccountTo = bankAccountTo {
                                                        bankAccountTo.balance += transaction.value
                                                    }
                                                }
                                            }
                                            
                                            try? managedObjectContext.save()
                                        }
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

    func transactionsByDay() -> [(key: String, value: [FetchedResults<Transaction>.Element])] {
        guard !transactions.isEmpty else { return [] }
        
        return Dictionary(grouping: transactions) { transaction in
            return transaction.date?.toFormattedString() ?? ""
        }.sorted(by: { $0.key < $1.key })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
