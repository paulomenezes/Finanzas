//
//  BankAccountAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

struct BankAccountAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var currencyFormatter = CurrencyFormatter.default
    
    @State private var name: String = ""
    
    @State private var balance: Double? = 0.0
    @State private var balanceText = "0"
    
    @State private var savedMoney: Double? = 0.0
    @State private var savedMoneyText = "0"
        
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        TextField("Name", text: $name)
                        
                        HStack {
                            Text("Balance")
                            CurrencyTextField(
                                configuration: .init(
                                    text: $balanceText,
                                    inputAmount: $balance,
                                    clearsWhenValueIsZero: true,
                                    formatter: $currencyFormatter,
                                    textFieldConfiguration: { uiTextField in
                                        uiTextField.keyboardType = .numbersAndPunctuation
                                        uiTextField.layer.masksToBounds = true
                                        uiTextField.textAlignment = .right
                                    }
                                )
                            )

                        }
                        
                        HStack {
                            Text("Saved")
                            CurrencyTextField(
                                configuration: .init(
                                    text: $savedMoneyText,
                                    inputAmount: $savedMoney,
                                    clearsWhenValueIsZero: true,
                                    formatter: $currencyFormatter,
                                    textFieldConfiguration: { uiTextField in
                                        uiTextField.keyboardType = .numbersAndPunctuation
                                        uiTextField.layer.masksToBounds = true
                                        uiTextField.textAlignment = .right
                                    }
                                )
                            )

                        }
                    }
                }
            }
            .navigationTitle("Add account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let bankAccount = BankAccount(context: managedObjectContext)
                        bankAccount.id = UUID()
                        bankAccount.name = name
                        bankAccount.balance = balance ?? 0.0
                        bankAccount.savedMoney = savedMoney ?? 0.0
                        bankAccount.createdAt = Date()
                        bankAccount.updateAt = Date()
                        
                        try? managedObjectContext.save()
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

struct BankAccountAddView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountAddView()
    }
}
