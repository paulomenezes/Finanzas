//
//  BankAccountView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct BankAccountView: View {
    @State private var addModalView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var bankAccounts: FetchedResults<BankAccount>
    
    var body: some View {
        NavigationView {
            VStack {
                if bankAccounts.count == 0 {
                    EmptyView(title: "No accounts found")
                } else {
                    List(bankAccounts) { bankAccount in
                        BankAccountItemView(name: bankAccount.name, balance: bankAccount.balance)
                            .swipeActions {
                                Button("Delete") {
                                    managedObjectContext.delete(bankAccount)
                                    try? managedObjectContext.save()
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Accounts")
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
                BankAccountAddView()
            }
        }
    }}

struct BankAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountView()
    }
}
