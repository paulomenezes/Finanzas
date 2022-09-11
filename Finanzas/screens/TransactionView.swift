//
//  TransactionView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct TransactionView: View {
    @State private var addModalView = false
    @State private var transaction: Transaction?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date),
        SortDescriptor(\.name)
    ]) var transactions: FetchedResults<Transaction>
    
    var body: some View {
        NavigationView {
            VStack {
                if transactions.count == 0 {
                    EmptyView(title: "No transactions found")
                } else {
                    List(transactionsData(transactions: transactions)) { transaction in
                        TransactionItemView(
                            name: transaction.name,
                            value: transaction.value,
                            paid: transaction.paid,
                            type: transaction.type,
                            date: transaction.date,
                            installmentsTo: transaction.installmentTo
                        )
                            .swipeActions {
                                Button("Delete") {
//                                    managedObjectContext.delete(transaction)
//                                    try? managedObjectContext.save()
                                }
                                .tint(.red)
                            }
//                            .onTapGesture {
//                                self.transaction = transaction
//                                addModalView.toggle()
//                            }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addModalView.toggle()
                    } label: {
                        Label("Plus", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $addModalView) {
                TransactionAddView(transactionItem: transaction)
                    .onDisappear {
                        transaction = nil
                    }
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView()
    }
}
