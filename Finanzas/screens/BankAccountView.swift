//
//  BankAccountView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

struct BankAccountView: View {
    @State private var addModalView = false
    @FetchRequest(sortDescriptors: []) var bankAccounts: FetchedResults<BankAccount>
    
    var body: some View {
        NavigationView {
            VStack {
                List(bankAccounts) { bankAccount in
                    BankAccountItemView(name: bankAccount.name, balance: bankAccount.balance, savedMoney: bankAccount.savedMoney)
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
