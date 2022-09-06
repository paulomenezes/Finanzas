//
//  TransactionAddView.swift
//  Finanzas
//
//  Created by Paulo Menezes on 04/09/22.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

struct TransactionAddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    public var transactionItem: Transaction?
    
    @FetchRequest(sortDescriptors: []) var bankAccounts: FetchedResults<BankAccount>
    
    @State private var currencyFormatter = CurrencyFormatter.default
    
    @State private var name: String = ""
    
    @State private var value: Double? = 0.0
    @State private var valueText = "0"
    
    @State private var paid = false
    @State private var date = Date()
    @State private var paymentDate = Date()
    
    @State private var type: TransactionType = .expense
    @State private var actionType: ActionType = .none
    @State private var installmentFrom: String = "1"
    @State private var installmentTo: String = "2"
    
    @State private var accountFrom: UUID?
    @State private var accountTo: UUID?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Detail")) {
                        Picker("Type", selection: $type) {
                            ForEach(TransactionType.allCases) { transactionType in
                                Text(transactionType.rawValue.capitalized)
                                    .tag(transactionType)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        TextField("Name", text: $name)
                        
                        HStack {
                            Text("Value")
                            CurrencyTextField(
                                configuration: .init(
                                    text: $valueText,
                                    inputAmount: $value,
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
                        
                        DatePicker("Date", selection: $date, displayedComponents: [.date])
                    }
                    
                    
                    Section(header: Text("Payment")) {
                        Toggle(type == .expense ? "Paid" : type == .income ? "Received" : "Transfered", isOn: $paid)
                        
                        if paid {
                            DatePicker(type == .expense ? "Payment Date" : type == .income ? "Received Date" : "Transfer Date", selection: $paymentDate, displayedComponents: [.date])
                        }
                        
                        Picker("From", selection: $accountFrom) {
                            ForEach(bankAccounts, id: \.id) { bankAccount in
                                Text(bankAccount.name ?? "-")
                            }
                        }
                        
                        if type == .transfer {
                            Picker("To", selection: $accountTo) {
                                ForEach(bankAccounts, id: \.id) { bankAccount in
                                    Text(bankAccount.name ?? "-")
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Type")) {
                        Picker("Type", selection: $actionType) {
                            ForEach(ActionType.allCases) { actionType in
                                Text(actionType.rawValue.capitalized)
                                    .tag(actionType)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if actionType == .installments {
                            HStack {
                                Text("Installments")
                                Spacer()
                                TextField("From", text: $installmentFrom)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.trailing)
                                Text("/")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                TextField("To", text: $installmentTo)
                                    .frame(width: 50)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
            .navigationTitle(transactionItem != nil ? "Update transaction" : "Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add more") {
                        save()
                        
                        name = ""
                        value = 0
                        date = Date()
                        paid = false
                        installmentFrom = "1"
                        installmentTo = "2"
                    }
                }
            }
            .onAppear {
                if let transactionItem = transactionItem {
                    name = transactionItem.name ?? ""
                }
            }
        }
    }
    
    func save() {
        let transaction = Transaction(context: managedObjectContext)
        transaction.id = UUID()
        transaction.name = name
        transaction.value = value ?? 0.0
        transaction.date = date
        transaction.paid = paid
        transaction.paymentDate = paymentDate
        transaction.installmentFrom = Int16(installmentFrom) ?? 0
        transaction.installmentTo = Int16(installmentTo) ?? 0
        transaction.action = actionType.rawValue
        transaction.type = type.rawValue
        transaction.accountFrom = accountFrom
        transaction.accountTo = accountTo
        transaction.createdAt = Date()
        transaction.updateAt = Date()
        
        try? managedObjectContext.save()
    }
}

struct TransactionAddView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionAddView()
    }
}
